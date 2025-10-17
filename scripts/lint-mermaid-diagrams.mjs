#!/usr/bin/env node
/**
 * Mermaid source linter for shared theme policy
 *
 * Scope:
 * - Scan all Markdown under docs/
 * - Exclude docs/_mermaid/_syntax/**
 * - Only analyze ```mermaid fences (skip ```mermaid-example)
 *
 * Violations:
 * - INIT_IN_SOURCE: Any line in source beginning with %%{init: (globally, not only inside fences)
 * - INLINE_COLOR: Hex colors (#RGB/#RRGGBB) inside mermaid fences
 * - INLINE_RGB: rgb( / rgba( inside mermaid fences
 * - INLINE_STYLE_CLASSDEF: classDef ... fill:/stroke: inside mermaid fences
 * - INLINE_STYLE_STYLE: style ... fill:/stroke: inside mermaid fences
 * - RECT_INLINE: rect rgba(...) or rect #... inside mermaid fences
 * - MISSING_MARKER: First non-empty line under a ```mermaid fence is not exactly the shared theme marker
 *
 * Marker required in source:
 *   %% shared theme: docs/_mermaid/theme.json %%
 *
 * Exit code:
 * - 0 when no violations
 * - 1 when any violations found
 *
 * Usage:
 *   node scripts/lint-mermaid-diagrams.mjs [--in docs] [--verbose]
 */

import { promises as fs } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

function parseArgs(argv) {
  const args = { inDir: 'docs', verbose: false };
  for (let i = 2; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--in') args.inDir = argv[++i];
    else if (a === '--verbose') args.verbose = true;
  }
  return args;
}

const MARKER_LINE = '%% shared theme: docs/_mermaid/theme.json %%';

const OPEN_MERMAID_RE = /^```mermaid[ \t]*$/;
const OPEN_MERMAID_EXAMPLE_RE = /^```mermaid-example[ \t]*$/;
const CLOSE_FENCE_RE = /^```[ \t]*$/;

const RE_INIT_LINE = /^\s*%%\s*\{\s*init\s*:/i;
const RE_HEX = /\B#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})\b/;
const RE_RGB = /\brgba?\s*\(/i;
const RE_CLASSDEF_FILL_STROKE = /\bclassDef\b.*\b(?:fill|stroke)\s*:/i;
const RE_STYLE_FILL_STROKE = /\bstyle\b.*\b(?:fill|stroke)\s*:/i;
const RE_RECT_INLINE = /^\s*rect\s+(?:rgba\s*\(|#[0-9a-fA-F]{3,6}\b)/i;

function isExcludedSyntax(relFromDocs) {
  const segs = relFromDocs.split(path.sep);
  return segs.length >= 2 && segs[0] === '_mermaid' && segs[1] === '_syntax';
}

async function walkFiles(root, cbFile) {
  const entries = await fs.readdir(root, { withFileTypes: true });
  for (const ent of entries) {
    const full = path.join(root, ent.name);
    if (ent.isDirectory()) {
      const relFromDocs = path.relative(rootDocs, full);
      // If relFromDocs starts with _mermaid/_syntax, skip entire subtree
      const relFromDocsFromRoot = path.relative(rootDocs, full);
      if (isExcludedSyntax(relFromDocsFromRoot)) continue;
      await walkFiles(full, cbFile);
    } else if (ent.isFile()) {
      await cbFile(full);
    }
  }
}

function lintFileContent(rel, content) {
  const lines = content.split(/\r?\n/);
  const violations = [];

  // Global INIT_IN_SOURCE scan (anywhere in the file)
  for (let i = 0; i < lines.length; i++) {
    if (RE_INIT_LINE.test(lines[i])) {
      violations.push({
        code: 'INIT_IN_SOURCE',
        rel,
        line: i + 1,
        msg: 'Per-diagram %%{init: ...}%% found in source; use shared theme marker instead',
      });
    }
  }

  // Per-fence scans for mermaid only (skip mermaid-example)
  let i = 0;
  while (i < lines.length) {
    const ln = lines[i];
    if (OPEN_MERMAID_EXAMPLE_RE.test(ln)) {
      // Skip until closing fence
      i++;
      while (i < lines.length && !CLOSE_FENCE_RE.test(lines[i])) i++;
      i++;
      continue;
    }
    if (OPEN_MERMAID_RE.test(ln)) {
      // Find fence body
      const start = i + 1;
      let j = start;
      while (j < lines.length && !CLOSE_FENCE_RE.test(lines[j])) j++;
      const block = lines.slice(start, j);

      // First non-empty line must be the shared marker
      let firstIdx = -1;
      for (let k = 0; k < block.length; k++) {
        if (block[k].trim().length > 0) { firstIdx = k; break; }
      }
      if (firstIdx !== -1) {
        if (block[firstIdx].trim() !== MARKER_LINE) {
          violations.push({
            code: 'MISSING_MARKER',
            rel,
            line: start + firstIdx,
            msg: `First non-empty line under \`\`\`mermaid must be exactly: ${MARKER_LINE}`,
          });
        }
      } else {
        // Empty fence: also missing marker
        violations.push({
          code: 'MISSING_MARKER',
          rel,
          line: i + 1,
          msg: `Missing shared theme marker line immediately after \`\`\`mermaid`,
        });
      }

      // Content inline style/color checks (entire block)
      for (let k = 0; k < block.length; k++) {
        const L = block[k];
        const n = start + k;
        if (RE_HEX.test(L)) {
          violations.push({ code: 'INLINE_COLOR', rel, line: n + 0, msg: 'Hex color not allowed in source diagram' });
        }
        if (RE_RGB.test(L)) {
          violations.push({ code: 'INLINE_RGB', rel, line: n + 0, msg: 'rgb()/rgba() not allowed in source diagram' });
        }
        if (RE_CLASSDEF_FILL_STROKE.test(L)) {
          violations.push({ code: 'INLINE_STYLE_CLASSDEF', rel, line: n + 0, msg: 'classDef with fill/stroke not allowed in source diagram' });
        }
        if (RE_STYLE_FILL_STROKE.test(L)) {
          violations.push({ code: 'INLINE_STYLE_STYLE', rel, line: n + 0, msg: 'style with fill/stroke not allowed in source diagram' });
        }
        if (RE_RECT_INLINE.test(L)) {
          violations.push({ code: 'RECT_INLINE', rel, line: n + 0, msg: 'rect with rgba() or #color not allowed in source diagram' });
        }
      }

      // Advance to line after closing fence
      i = j < lines.length ? j + 1 : j;
      continue;
    }
    i++;
  }

  return violations;
}

let rootDocs = '';

async function main() {
  try {
    const args = parseArgs(process.argv);
    rootDocs = path.resolve(args.inDir);
    const violations = [];

    await walkFiles(rootDocs, async (full) => {
      if (path.extname(full).toLowerCase() !== '.md') return;
      const relFromDocs = path.relative(rootDocs, full);
      if (isExcludedSyntax(relFromDocs)) return;
      const content = await fs.readFile(full, 'utf8');
      const fileViolations = lintFileContent(path.join('docs', relFromDocs), content);
      if (fileViolations.length > 0 && args.verbose) {
        console.log(`Scanned: ${path.join('docs', relFromDocs)} - violations: ${fileViolations.length}`);
      }
      violations.push(...fileViolations);
    });

    if (violations.length > 0) {
      for (const v of violations) {
        console.error(`${v.rel}:${v.line}: ${v.code} - ${v.msg}`);
      }
      console.error(`\nLinter failed with ${violations.length} violation(s) across ${new Set(violations.map(v => v.rel)).size} file(s).`);
      process.exit(1);
    } else {
      console.log('Mermaid linter passed. No violations found.');
      process.exit(0);
    }
  } catch (err) {
    console.error('Linter error:', err?.message || err);
    process.exit(1);
  }
}

if (import.meta.url === `file://${__filename}`) {
  main();
}