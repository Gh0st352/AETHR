#!/usr/bin/env node
/**
 * Rewrite relative code links in Markdown under docs/ from ../../dev/*.lua:LINE
 * to absolute GitHub blob anchors:
 *   https://github.com/<owner>/<repo>/blob/<branch>/dev/file.lua#L<line>[-L<end>]
 *
 * Run in CI before Jekyll build so the published site has CSP-safe, static links.
 *
 * Usage:
 *   node scripts/rewrite-code-links.mjs [--src docs] [--owner Gh0st352] [--repo AETHR] [--branch main]
 *
 * Defaults:
 *   owner/repo from GITHUB_REPOSITORY env, branch from GITHUB_REF_NAME; fallback owner=Gh0st352 repo=AETHR branch=main
 */

import fs from 'node:fs/promises';
import path from 'node:path';

function parseArgs(argv) {
  const args = {
    src: 'docs',
    owner: '',
    repo: '',
    branch: '',
  };
  for (let i = 2; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--src') args.src = argv[++i];
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

function toBlobURL({ owner, repo, branch }, devPath, lineSpec) {
  let suffix = '';
  if (lineSpec) {
    const m = String(lineSpec).match(/^(\d+)(?:-(\d+))?$/);
    if (m) suffix = `#L${m[1]}${m[2] ? `-L${m[2]}` : ''}`;
  }
  return `https://github.com/${owner}/${repo}/blob/${branch}/${devPath}${suffix}`;
}

function normalizeDevPath(href) {
  const raw = href.split('#')[0].split('?')[0];
  const idx = raw.indexOf('dev/');
  if (idx === -1) return null;

  const tail = raw.slice(idx); // "dev/FSM.lua:366" or "dev/_AI.lua:319"
  const colonIdx = tail.lastIndexOf(':');
  let p = tail;
  let lineSpec = '';

  if (colonIdx !== -1) {
    const after = tail.slice(colonIdx + 1);
    if (/^\d+(?:-\d+)?$/.test(after)) {
      p = tail.slice(0, colonIdx);
      lineSpec = after;
    } else {
      return null;
    }
  } else {
    return null;
  }

  if (!/\.lua$/i.test(p)) return null;
  return { path: p.replace(/^\.\/+/, ''), lineSpec };
}

function rewriteMarkdownContent(content, info) {
  // Match standard Markdown links [text](href) but skip absolute urls/mailto/# fragments via runtime checks
  const linkRe = /\[([^\]]+)\]\(([^)\s]+)\)/g;

  let changed = false;
  const out = content.replace(linkRe, (full, text, href) => {
    // Ignore absolute links and non-Lua targets quickly
    if (/^(?:https?:|mailto:|#)/i.test(href)) return full;
    if (!href.includes('dev/') || !/\.lua:\d/.test(href)) return full;

    const norm = normalizeDevPath(href);
    if (!norm) return full;

    const url = toBlobURL(info, norm.path, norm.lineSpec);
    changed = true;
    return `[${text}](${url})`;
  });

  return { out, changed };
}

async function* walk(dir) {
  const entries = await fs.readdir(dir, { withFileTypes: true });
  for (const e of entries) {
    const p = path.join(dir, e.name);
    if (e.isDirectory()) {
      // Skip common Jekyll output or hidden dirs within docs just in case
      if (e.name === '_site' || e.name === '.jekyll-cache' || e.name === '.git') continue;
      yield* walk(p);
    } else if (e.isFile()) {
      yield p;
    }
  }
}

async function main() {
  const args = parseArgs(process.argv);
  const root = path.resolve(process.cwd(), args.src);

  const info = { owner: args.owner, repo: args.repo, branch: args.branch };

  let filesSeen = 0;
  let filesChanged = 0;
  let linksRewritten = 0;

  for await (const file of walk(root)) {
    // Only process Markdown files
    if (!/\.md$/i.test(file)) continue;

    const original = await fs.readFile(file, 'utf8');
    const { out, changed } = rewriteMarkdownContent(original, info);

    if (changed) {
      // Count approximate rewrites by diffing occurrences of 'blob/<branch>/dev/' after vs before
      const beforeCount = (original.match(/\/blob\/[^/]+\/dev\//g) || []).length;
      const afterCount = (out.match(/\/blob\/[^/]+\/dev\//g) || []).length;
      linksRewritten += Math.max(0, afterCount - beforeCount);

      await fs.writeFile(file, out, 'utf8');
      filesChanged++;
    }
    filesSeen++;
  }

  // eslint-disable-next-line no-console
  console.log(
    `rewrite-code-links: scanned=${filesSeen} changed=${filesChanged} rewritten≈${linksRewritten} owner=${info.owner} repo=${info.repo} branch=${info.branch}`
  );
}

main().catch((err) => {
  // eslint-disable-next-line no-console
  console.error('rewrite-code-links failed:', err);
  process.exit(1);
});