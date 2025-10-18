#!/usr/bin/env node
/**
 * Update code links in Markdown to correct GitHub blob anchors based on Lua method definitions.
 *
 * Scope:
 *  - Scan docs/ (recursively) and the top-level README.md
 *  - Handle both:
 *      - Relative links like: dev/FSM.lua:366  or  ../../dev/FSM.lua:12-34
 *      - Absolute links like: https://github.com/<owner>/<repo>/blob/<branch>/dev/FSM.lua#L366
 *  - Recalculate the correct anchor line by extracting the intended method from the link text, e.g.:
 *      [AETHR.FSM:New()](...)
 *    and locating the corresponding function definition in dev/FSM.lua.
 *  - If the method cannot be found (or the target file doesn't exist), delete the entire Markdown line containing the link.
 *  - Convert any relative link to an absolute GitHub blob link using owner/repo/branch derived from env or CLI args.
 *
 * Usage:
 *   node scripts/update-code-links.mjs [--src docs] [--readme README.md] [--owner Gh0st352] [--repo AETHR] [--branch main]
 *
 * Env fallbacks:
 *   - owner/repo from GITHUB_REPOSITORY
 *   - branch from GITHUB_REF_NAME
 */

import fs from 'node:fs/promises';
import path from 'node:path';

function parseArgs(argv) {
  const args = {
    src: 'docs',
    readme: 'README.md',
    owner: '',
    repo: '',
    branch: '',
  };
  for (let i = 2; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--src') args.src = argv[++i];
    else if (a === '--readme') args.readme = argv[++i];
    else if (a === '--owner') args.owner = argv[++i];
    else if (a === '--repo') args.repo = argv[++i];
    else if (a === '--branch') args.branch = argv[++i];
  }

  // Env fallbacks from GitHub Actions
  const nwo = process.env.GITHUB_REPOSITORY || '';
  if (!args.owner || !args.repo) {
    const parts = nwo.split('/');
    if (parts.length === 2) {
      args.owner = args.owner || parts[0];
      args.repo = args.repo || parts[1];
    }
  }
  args.owner = args.owner || 'Gh0st352';
  args.repo = args.repo || 'AETHR';
  args.branch = args.branch || process.env.GITHUB_REF_NAME || 'main';
  return args;
}

function escapeRe(s) {
  return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function toBlobURL({ owner, repo, branch }, devPath, line) {
  const suffix = line > 0 ? `#L${line}` : '';
  return `https://github.com/${owner}/${repo}/blob/${branch}/${devPath}${suffix}`;
}

function isMarkdownFile(p) {
  return /\.md$/i.test(p);
}

async function* walk(dir) {
  const entries = await fs.readdir(dir, { withFileTypes: true });
  for (const e of entries) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) {
      if (e.name === '_site' || e.name === '.jekyll-cache' || e.name === '.git' || e.name === 'node_modules') continue;
      yield* walk(p);
    } else if (e.isFile()) {
      yield p;
    }
  }
}

/**
 * Extract dev path from an href.
 * Supports absolute GitHub blob links and relative paths with "dev/" and ":line" suffix.
 */
function extractDevPathFromHref(href) {
  if (!href) return null;
  const s = href.trim();

  // Absolute GitHub blob link
  // Example: https://github.com/owner/repo/blob/branch/dev/FSM.lua#L366
  const mAbs = s.match(/github\.com\/[^/]+\/[^/]+\/blob\/[^/]+\/(dev\/[^#?)]*)/i);
  if (mAbs) {
    return mAbs[1].replace(/^\.\/+/, '').replace(/\\/g, '/');
  }

  // Relative path that includes dev/, with optional ../../ segments
  const idx = s.indexOf('dev/');
  if (idx !== -1) {
    // Take until next ':' or '#' or '?' or end
    let tail = s.slice(idx);
    const stopIdx = (() => {
      const candidates = [tail.indexOf(':'), tail.indexOf('#'), tail.indexOf('?')].filter((x) => x !== -1);
      return candidates.length ? Math.min(...candidates) : -1;
    })();
    if (stopIdx !== -1) tail = tail.slice(0, stopIdx);
    return tail.replace(/^\.\/+/, '').replace(/\\/g, '/');
  }

  return null;
}

/**
 * Extract a numeric line spec from an href if present.
 * - Relative "dev/FSM.lua:12" or ":12-34"
 * - Absolute "...#L12" or "#L12-L34"
 */
function extractLineSpecFromHref(href) {
  if (!href) return '';
  const s = href.trim();

  const mRel = s.match(/dev\/[^#?):]+:(\d+(?:-\d+)?)/);
  if (mRel) return mRel[1];

  const mAbs = s.match(/#L(\d+)(?:-L(\d+))?/i);
  if (mAbs) return mAbs[2] ? `${mAbs[1]}-${mAbs[2]}` : `${mAbs[1]}`;

  return '';
}

/**
 * Attempt to parse the method from Markdown link text.
 * Examples:
 *   "AETHR.FSM:New()" -> { container: "AETHR.FSM", method: "New" }
 *   "AETHR.FSM.New()" -> { container: "AETHR.FSM", method: "New" }
 *   "FSM:New()"       -> { container: "FSM",       method: "New" }
 *   "UTILS.deepcopy"  -> { container: "UTILS",     method: "deepcopy" }
 *   "New()"           -> { container: "",          method: "New" }
 */
function parseMethodFromText(text) {
  if (!text) return { container: '', method: '' };
  const t = String(text).trim();

  // Full form with container and method, parens optional
  let m = t.match(/([A-Za-z_][\w\.]*)\s*[:\.]\s*([A-Za-z_][\w]*)\s*\(?\s*\)?/);
  if (m) {
    return { container: m[1], method: m[2] };
  }

  // Method-only form with trailing parens
  m = t.match(/\b([A-Za-z_][\w]*)\s*\(\s*\)?/);
  if (m) {
    return { container: '', method: m[1] };
  }

  // Fallback: last wordy token might be method
  m = t.match(/([A-Za-z_][\w]*)$/);
  if (m) {
    return { container: '', method: m[1] };
  }

  return { container: '', method: '' };
}

/**
 * Find the 1-based line number of a Lua method definition in a given dev file.
 * Heuristics:
 *  - Prefer fully-qualified matches using the provided container chain (e.g., AETHR.FSM:New)
 *  - Try container's last segment (e.g., FSM:New)
 *  - Try file base name (e.g., FSM:New if file is dev/FSM.lua)
 *  - Fallback generic patterns (any table/method with the target method)
 * Skips pure comment lines and naive block comments --[[ ... ]].
 */
function findMethodLineInLua(devFileContent, devPath, method, container) {
  if (!devFileContent || !method) return 0;

  const baseName = path.basename(devPath, '.lua');
  const containers = [];
  if (container) containers.push(container);
  if (container) {
    const last = container.split('.').filter(Boolean).pop();
    if (last && !containers.includes(last)) containers.push(last);
  }
  if (!containers.includes(baseName)) containers.push(baseName);

  const makePats = (cont) => {
    const c = escapeRe(cont);
    const m = escapeRe(method);
    return [
      new RegExp(`^\\s*function\\s+${c}\\s*:\\s*${m}\\s*\\(`),
      new RegExp(`^\\s*function\\s+${c}\\s*\\.\\s*${m}\\s*\\(`),
      new RegExp(`^\\s*${c}\\s*\\.\\s*${m}\\s*=\\s*function\\s*\\(`),
      new RegExp(`^\\s*${c}\\s*:\\s*${m}\\s*=\\s*function\\s*\\(`),
    ];
  };

  const genericPats = (() => {
    const m = escapeRe(method);
    return [
      new RegExp(`^\\s*function\\s+[\\w\\.]+\\s*[:\\.]\\s*${m}\\s*\\(`),
      new RegExp(`^\\s*[\\w\\.]+\\s*\\.\\s*${m}\\s*=\\s*function\\s*\\(`),
    ];
  })();

  const lines = devFileContent.split(/\r?\n/);

  let inBlock = false;
  function isCommentLine(line) {
    const s = line.trim();
    return /^--/.test(s);
  }
  function scanForLineWithPatterns(patterns) {
    for (let i = 0; i < lines.length; i++) {
      const line = lines[i];

      // Naive block comment tracking
      if (!inBlock && /--\[\[/.test(line)) inBlock = true;
      if (inBlock) {
        if (/\]\]-?/.test(line)) inBlock = false;
        continue;
      }

      if (isCommentLine(line)) continue;

      for (const re of patterns) {
        if (re.test(line)) {
          return i + 1; // 1-based
        }
      }
    }
    return 0;
  }

  // Try each container candidate in order
  for (const cont of containers) {
    const pats = makePats(cont);
    const ln = scanForLineWithPatterns(pats);
    if (ln) return ln;
  }

  // Fallback generic patterns
  return scanForLineWithPatterns(genericPats);
}

/**
 * Rewrite a single Markdown line by processing any links found.
 * If any link on the line refers to a method that is not found, delete the entire line.
 */
async function rewriteMarkdownLine(line, info, devCache) {
  // Match standard Markdown links [text](href), skipping images ![alt](src)
  const linkRe = /(^|[^!])\[((?:\\\]|[^\]])+)\]\(([^)\s]+)\)/g;

  let deleted = false;
  let changed = false;
  let out = line;

  // Collect matches first to avoid interfering with indices while replacing
  const matches = [];
  let m;
  while ((m = linkRe.exec(line)) != null) {
    const prefix = m[1] || '';
    const text = m[2];
    const href = m[3];
    matches.push({ match: m[0], prefix, text, href });
  }

  for (const item of matches) {
    const { match, prefix, text, href } = item;

    // Quick eligibility filter: must reference dev/ and end with .lua (absolute or relative)
    const hasDev = href.includes('dev/');
    const looksLua = /\.lua(?::\d|#L\d|$)/i.test(href) || /\.lua[?#)]/i.test(href) || /\.lua$/i.test(href);
    const isGitHubAbs = /https?:\/\/github\.com\//i.test(href);

    if (!hasDev && !isGitHubAbs) continue;
    if (!looksLua) continue;

    const devPath = extractDevPathFromHref(href);
    if (!devPath || !/\.lua$/i.test(devPath)) continue;

    const { container, method } = parseMethodFromText(text);

    // Read and cache dev file content
    const absDev = path.resolve(process.cwd(), devPath);
    let devContent = devCache.get(absDev);
    if (devContent === undefined) {
      try {
        devContent = await fs.readFile(absDev, 'utf8');
      } catch {
        devContent = null; // missing file
      }
      devCache.set(absDev, devContent);
    }

    if (!devContent) {
      // Missing file: delete entire line
      deleted = true;
      break;
    }

    let targetLine = 0;

    // Determine target line per policy: if a method is referenced, it must resolve;
    // otherwise, fall back to an explicit numeric line if present.
    if (method) {
      targetLine = findMethodLineInLua(devContent, devPath, method, container);
      if (!targetLine) {
        // Method appears to be gone: delete the entire line/list item per policy
        deleted = true;
        break;
      }
    } else {
      // No method context in link text; fall back to explicit numeric line if present
      const spec = extractLineSpecFromHref(href);
      const first = spec ? parseInt(String(spec).split('-')[0], 10) : 0;
      targetLine = Number.isFinite(first) ? first : 0;
      if (!targetLine) {
        // Nothing to do; cannot infer a new target without a method or explicit line
        continue;
      }
    }

    const newURL = toBlobURL(info, devPath, targetLine);

    // Replace the original link href with newURL
    // Safest is to reconstruct the link with same text
    const newLink = `${prefix}[${text}](${newURL})`;
    if (newLink !== match) {
      out = out.replace(match, newLink);
      changed = true;
    }
  }

  return { out: deleted ? '' : out, deleted, changed };
}

/**
 * Process a Markdown file. Deletes lines when necessary and rewrites links.
 */
async function processMarkdownFile(filePath, info) {
  const original = await fs.readFile(filePath, 'utf8');
  const lines = original.split(/\r?\n/);

  const devCache = new Map(); // absDevPath -> content or null

  let changed = false;
  let deletedCount = 0;
  let updatedLinks = 0;

  const outLines = [];
  for (let i = 0; i < lines.length; i++) {
    const before = lines[i];
    const { out, deleted, changed: lineChanged } = await rewriteMarkdownLine(before, info, devCache);

    if (deleted) {
      deletedCount++;
      changed = true;
      // skip pushing line
    } else {
      outLines.push(out);
      if (lineChanged) {
        changed = true;
        // Approximate updated-links count by diffing occurrences of 'blob/<branch>/dev/' in this line
        const bc = (before.match(/\/blob\/[^/]+\/dev\//g) || []).length;
        const ac = (out.match(/\/blob\/[^/]+\/dev\//g) || []).length;
        updatedLinks += Math.max(0, ac - bc);
      }
    }
  }

  const out = outLines.join('\n');
  return { out, changed, deletedCount, updatedLinks, filePath, original };
}

async function main() {
  const args = parseArgs(process.argv);
  const root = path.resolve(process.cwd(), args.src);
  const info = { owner: args.owner, repo: args.repo, branch: args.branch };

  const targets = [];

  // README.md at repo root if present
  const readmePath = path.resolve(process.cwd(), args.readme);
  try {
    const st = await fs.stat(readmePath);
    if (st.isFile() && isMarkdownFile(readmePath)) {
      targets.push(readmePath);
    }
  } catch {
    // ignore
  }

  // docs/ recursive
  for await (const fp of walk(root)) {
    if (isMarkdownFile(fp)) targets.push(fp);
  }

  let filesSeen = 0;
  let filesChanged = 0;
  let linesDeletedTotal = 0;
  let linksUpdatedTotal = 0;

  for (const file of targets) {
    const { out, changed, deletedCount, updatedLinks, original } = await processMarkdownFile(file, info);
    filesSeen++;

    if (changed) {
      await fs.writeFile(file, out, 'utf8');
      filesChanged++;
      linesDeletedTotal += deletedCount;
      linksUpdatedTotal += updatedLinks;

      // eslint-disable-next-line no-console
      console.log(`updated: ${path.relative(process.cwd(), file)} (deleted ${deletedCount} lines, updated≈${updatedLinks} links)`);
    }
  }

  // eslint-disable-next-line no-console
  console.log(
    `update-code-links: scanned=${filesSeen} changed=${filesChanged} deleted_lines=${linesDeletedTotal} updated_links≈${linksUpdatedTotal} owner=${info.owner} repo=${info.repo} branch=${info.branch}`
  );
}

main().catch((err) => {
  // eslint-disable-next-line no-console
  console.error('update-code-links failed:', err);
  process.exit(1);
});