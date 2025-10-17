#!/usr/bin/env node
/**
 * Mermaid shared theme injector
 *
 * - Reads docs/_mermaid/theme.json
 * - Mirrors docs/ to site/docs/
 * - For each Markdown file, injects a single-line %%{init: ...}%% directive
 *   immediately under ```mermaid fences, following these rules:
 *   - Skip docs/_mermaid/_syntax/**
 *   - Skip ```mermaid-example fences (we only match exactly ```mermaid)
 *   - If the next non-empty line after the opening fence is the marker:
 *       %% shared theme: docs/_mermaid/theme.json %%
 *     replace it with the directive.
 *   - Else if the next non-empty line is any %%{init: ...}%%, replace it.
 *   - Else insert the directive as the first line under the opening fence.
 *   - Deduplicate any additional %%{init: ...}%% lines within the same fence.
 * - Preserve file-level EOL style (CRLF or LF)
 * - Create site/.nojekyll
 *
 * Usage:
 *   node scripts/inject-mermaid-theme.mjs --in docs --out site [--theme docs/_mermaid/theme.json] [--verbose]
 */

import { promises as fs } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

function parseArgs(argv) {
  const args = { inDir: null, outDir: null, themePath: null, verbose: false };
  for (let i = 2; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--in') {
      args.inDir = argv[++i];
    } else if (a === '--out') {
      args.outDir = argv[++i];
    } else if (a === '--theme') {
      args.themePath = argv[++i];
    } else if (a === '--verbose') {
      args.verbose = true;
    } else {
      // ignore unknowns
    }
  }
  if (!args.inDir) args.inDir = 'docs';
  if (!args.outDir) args.outDir = 'site';
  if (!args.themePath) args.themePath = path.join('docs', '_mermaid', 'theme.json');
  return args;
}

async function ensureDir(p) {
  await fs.mkdir(p, { recursive: true });
}

async function copyFile(src, dest) {
  await ensureDir(path.dirname(dest));
  await fs.copyFile(src, dest);
}

function detectEOL(text) {
  return text.includes('\r\n') ? '\r\n' : '\n';
}

function splitLinesPreserve(text) {
  // standardize to \n split; keep original EOL for join
  return text.split(/\r?\n/);
}

function buildInitDirective(themeObj) {
  const json = JSON.stringify(themeObj);
  return `%%{init: ${json}}%%`;
}

async function loadTheme(themePath) {
  const raw = await fs.readFile(themePath, 'utf8');
  // Parse to validate JSON and to allow re-stringify to one line
  const obj = JSON.parse(raw);
  return obj;
}

const MARKER_LINE = '%% shared theme: docs/_mermaid/theme.json %%';
const OPEN_FENCE_RE = /^```mermaid[ \t]*$/;
const CLOSE_FENCE_RE = /^```[ \t]*$/;
const INIT_LINE_RE = /^%%\s*\{\s*init\s*:/i;

function isExcludedSyntax(relPathFromDocs) {
  // exclude docs/_mermaid/_syntax/**
  const p = relPathFromDocs.split(path.sep);
  return p.length >= 2 && p[0] === '_mermaid' && p[1] === '_syntax';
}

function processMarkdownContent(content, initDirective) {
  const eol = detectEOL(content);
  const lines = splitLinesPreserve(content);
  let i = 0;
  let modified = false;

  while (i < lines.length) {
    const line = lines[i];
    if (OPEN_FENCE_RE.test(line.trim())) {
      // find closing fence
      let j = i + 1;
      while (j < lines.length && !CLOSE_FENCE_RE.test(lines[j].trim())) {
        j++;
      }
      // handle case no closing fence: treat rest of file as fence
      if (j >= lines.length) j = lines.length - 1;

      // Determine first non-empty line under the opening fence within (i+1..j-1)
      const blockStart = i + 1;
      const block = lines.slice(blockStart, j); // up to but not including closing fence
      let firstNonEmptyIdx = -1;
      for (let k = 0; k < block.length; k++) {
        if (block[k].trim().length > 0) {
          firstNonEmptyIdx = k;
          break;
        }
      }

      // Decide replace vs insert
      if (firstNonEmptyIdx >= 0 && block[firstNonEmptyIdx].trim() === MARKER_LINE) {
        block[firstNonEmptyIdx] = initDirective;
        modified = true;
      } else if (firstNonEmptyIdx >= 0 && INIT_LINE_RE.test(block[firstNonEmptyIdx].trim())) {
        block[firstNonEmptyIdx] = initDirective;
        modified = true;
      } else {
        // insert at top of block (immediately under opening fence)
        block.unshift(initDirective);
        modified = true;
      }

      // Deduplicate other init lines further down, keeping only the first occurrence we just placed
      for (let k = 0, seenFirst = false; k < block.length; ) {
        const isInit = INIT_LINE_RE.test(block[k].trim());
        if (isInit) {
          if (!seenFirst) {
            seenFirst = true;
            k++;
          } else {
            block.splice(k, 1);
            modified = true;
          }
        } else {
          k++;
        }
      }

      // Splice block back
      lines.splice(blockStart, j - blockStart, ...block);
      // Move i to closing fence line (which may have shifted)
      i = blockStart + block.length;
      // i currently points to closing fence line
    }
    i++;
  }

  return { text: lines.join(eol), modified };
}

async function mirrorAndInject(inDir, outDir, initDirective, verbose) {
  let filesTouched = 0;
  let fencesTouched = 0;

  async function walk(currentSrc) {
    const entries = await fs.readdir(currentSrc, { withFileTypes: true });
    for (const ent of entries) {
      const srcPath = path.join(currentSrc, ent.name);
      const relFromIn = path.relative(inDir, srcPath);
      // Map to out under site/docs
      const outPath = path.join(outDir, 'docs', relFromIn);

      if (ent.isDirectory()) {
        // Exclude docs/_mermaid/_syntax/*
        if (isExcludedSyntax(relFromIn)) {
          if (verbose) console.log(`Skip syntax dir: ${relFromIn}`);
          continue;
        }
        await walk(srcPath);
      } else if (ent.isFile()) {
        // Always ensure destination dir exists
        await ensureDir(path.dirname(outPath));
        const ext = path.extname(ent.name).toLowerCase();
        if (ext === '.md') {
          // load markdown and inject
          const content = await fs.readFile(srcPath, 'utf8');
          const before = content;
          const { text, modified } = processMarkdownContent(before, initDirective);
          await fs.writeFile(outPath, text, 'utf8');
          if (modified) {
            filesTouched++;
            // Rough estimate: count occurrences of init directive
            const count = (text.match(/^%%\s*\{\s*init\s*:/gmi) || []).length;
            fencesTouched += count;
            if (verbose) console.log(`Injected: ${relFromIn}`);
          } else {
            if (verbose) console.log(`No changes: ${relFromIn}`);
          }
        } else {
          await copyFile(srcPath, outPath);
          if (verbose) console.log(`Copied: ${relFromIn}`);
        }
      }
    }
  }

  await walk(inDir);

  // Create .nojekyll at out root
  await ensureDir(outDir);
  await fs.writeFile(path.join(outDir, '.nojekyll'), '', 'utf8');

  return { filesTouched, fencesTouched };
}

async function main() {
  try {
    const args = parseArgs(process.argv);
    const inDir = path.resolve(args.inDir);
    const outDir = path.resolve(args.outDir);
    const themePath = path.resolve(args.themePath);

    const themeObj = await loadTheme(themePath);
    const initDirective = buildInitDirective(themeObj);

    if (args.verbose) {
      console.log(`Theme: ${themePath}`);
      console.log(`In: ${inDir}`);
      console.log(`Out: ${outDir}`);
      console.log(`Directive: ${initDirective.slice(0, 80)}...`);
    }

    const stats = await mirrorAndInject(inDir, outDir, initDirective, args.verbose);
    console.log(`Injection complete. Files modified: ${stats.filesTouched}. Fences injected: ${stats.fencesTouched}.`);
    process.exit(0);
  } catch (err) {
    console.error('Injector error:', err?.message || err);
    process.exit(1);
  }
}

if (import.meta.url === `file://${__filename}`) {
  main();
}