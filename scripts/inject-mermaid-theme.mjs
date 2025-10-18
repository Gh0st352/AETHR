#!/usr/bin/env node
/**
 * Mermaid shared theme injector + simple SPA docs shell
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
 * - Emit site/docs/_manifest.json with all docs/*.md paths (excluding _mermaid/_syntax/)
 * - Emit site/index.html: an SPA that renders Markdown and Mermaid and provides a sidebar
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
  return text.split(/\r?\n/);
}

function buildInitDirective(themeObj) {
  const json = JSON.stringify(themeObj);
  return `%%{init: ${json}}%%`;
}

async function loadTheme(themePath) {
  const raw = await fs.readFile(themePath, 'utf8');
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
  const manifestPaths = []; // docs-relative POSIX paths to .md

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
          const { text, modified } = processMarkdownContent(content, initDirective);
          await fs.writeFile(outPath, text, 'utf8');
          // add to manifest (normalize to POSIX)
          manifestPaths.push(relFromIn.split(path.sep).join('/'));
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

  // Write manifest (sorted)
  manifestPaths.sort((a, b) => a.localeCompare(b, undefined, { sensitivity: 'base' }));
  const manifest = { paths: manifestPaths };
  const manifestDir = path.join(outDir, 'docs');
  await ensureDir(manifestDir);
  await fs.writeFile(path.join(manifestDir, '_manifest.json'), JSON.stringify(manifest, null, 2), 'utf8');

  // Create .nojekyll at out root
  await ensureDir(outDir);
  await fs.writeFile(path.join(outDir, '.nojekyll'), '', 'utf8');

  return { filesTouched, fencesTouched, manifestCount: manifestPaths.length };
}

async function writeIndexHtml(outDir) {
  const html = `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <title>AETHR Docs</title>
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <style>
    :root { color-scheme: light dark; }
    html, body { height: 100%; }
    body { margin: 0; font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; line-height: 1.5; }
    header { padding: 0.75rem 1rem; border-bottom: 1px solid #ddd; position: sticky; top: 0; background: var(--bg, #fff); z-index: 10; }
    header a { color: inherit; text-decoration: none; }
    .layout { display: grid; grid-template-columns: 280px 1fr; min-height: calc(100% - 48px); }
    aside { border-right: 1px solid #ddd; padding: 1rem; overflow: auto; }
    main { padding: 1rem 1.5rem; overflow: auto; }
    pre { overflow: auto; background: rgba(0,0,0,0.05); padding: 0.75rem; border-radius: 6px; }
    details { margin: 0.25rem 0; }
    summary { cursor: pointer; font-weight: 600; }
    ul { list-style: none; padding-left: 0.75rem; margin: 0.25rem 0 0.5rem 0; }
    li { margin: 0.15rem 0; }
    a.nav { text-decoration: none; color: inherit; }
    a.nav.active { font-weight: 600; text-decoration: underline; }
    .sr-only { position: absolute; left: -10000px; }
  /* Mermaid zoom/pan UI */
    .mz-container { position: relative; margin: 0.5rem 0 1rem; border: 1px solid #e5e5e5; border-radius: 6px; background: rgba(0,0,0,0.02); }
    .mz-toolbar { position: absolute; top: 8px; right: 8px; display: flex; gap: 4px; z-index: 2; }
    .mz-toolbar button { font: inherit; font-size: 12px; padding: 4px 6px; border: 1px solid #ccc; border-radius: 4px; background: #fff; cursor: pointer; }
    .mz-hint { position: absolute; top: 8px; left: 8px; font-size: 12px; color: #555; background: rgba(255,255,255,0.85); padding: 2px 6px; border-radius: 4px; border: 1px solid #ddd; z-index: 2; pointer-events: none; }
    @media (prefers-color-scheme: dark) {
      .mz-toolbar button { background: #1e1e1e; color: #eee; border-color: #444; }
      .mz-container { border-color: #333; background: rgba(255,255,255,0.03); }
      .mz-hint { color: #ccc; background: rgba(30,30,30,0.85); border-color: #444; }
    }
    .mz-viewport { position: relative; overflow: hidden; width: 100%; height: min(70vh, 800px); }
    .mz-content { transform-origin: 0 0; will-change: transform; }
  </style>
  <script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js" defer></script>
  <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js" defer></script>
</head>
<body>
  <header>
    <a href="./"><strong>AETHR</strong> Docs</a>
    &nbsp;·&nbsp;<a href="#docs/README.md">Browse docs/</a>
  </header>
  <div class="layout">
    <aside id="sidebar" aria-label="Documentation navigation">
      <div id="sidebar-loading">Loading index…</div>
    </aside>
    <main>
      <h1>Documentation</h1>
      <div id="app">Loading docs/README.md…</div>
      <noscript>
        <p>JavaScript is required to render Markdown and Mermaid diagrams on this static site.</p>
        <p>You can browse raw Markdown at <a href="./docs/">docs/</a>.</p>
      </noscript>
    </main>
  </div>
  <script>
    (function () {
      let currentPath = '';
      let manifest = null;
      const app = document.getElementById('app');
      const sidebar = document.getElementById('sidebar');
      const sidebarLoading = document.getElementById('sidebar-loading');

      function isMdLink(href) {
        return /\\.md($|#)/i.test(href);
      }
      function titleCase(s) {
        return s.replace(/[-_]/g, ' ')
                .replace(/\\b\\w/g, c => c.toUpperCase());
      }
      function pageTitleFromPath(p) {
        const name = p.split('/').pop().replace(/\\.md$/i, '');
        return titleCase(name);
      }
      function resolveMd(href, base) {
        // Base is the current docs path, e.g. "docs/a/b/README.md"
        const baseUrl = new URL('./' + base, window.location.origin + '/');
        const url = new URL(href, baseUrl);
        const path = url.pathname.replace(new RegExp('^/+'), '');
        const hash = url.hash ? url.hash : '';
        return { path, hash };
      }
      function parseHash() {
        const raw = (window.location.hash || '').slice(1).trim();
        if (!raw) return { path: 'docs/README.md', anchor: '' };
        const idx = raw.indexOf('#');
        const path = idx === -1 ? raw : raw.slice(0, idx);
        const anchor = idx === -1 ? '' : raw.slice(idx + 1);
        return { path: path, anchor: anchor };
      }

      // Rewrite code links like ".../path/file.ext:123" to GitHub blob URLs with "#L123"
      function rewriteCodeLinks() {
        const REPO_NAME = 'AETHR';
        const GITHUB_REPO = 'https://github.com/Gh0st352/AETHR';
        const GITHUB_BRANCH = 'main';
        app.querySelectorAll('a[href]').forEach(function(a){
          const rawHref = a.getAttribute('href');
          if (!rawHref) return;
          if (rawHref.startsWith('#')) return;
          let url;
          try {
            url = new URL(rawHref, window.location.origin + window.location.pathname);
          } catch (e) { return; }
          const pathWithMaybeLine = url.pathname; // e.g. /AETHR/dev/SPAWNER.lua:321
          const m = pathWithMaybeLine.match(/^(.*\.[A-Za-z0-9_]+):(\d+)$/);
          if (!m) return;
          let filePath = m[1].replace(new RegExp('^/+'), '');
          if (filePath.startsWith(REPO_NAME + '/')) {
            filePath = filePath.slice(REPO_NAME.length + 1);
          }
          const ext = filePath.split('.').pop().toLowerCase();
          if (ext === 'md') return; // do not rewrite markdown links
          const gh = GITHUB_REPO + '/blob/' + GITHUB_BRANCH + '/' + filePath + '#L' + m[2];
          a.setAttribute('href', gh);
          a.setAttribute('target', '_blank');
          a.setAttribute('rel', 'noopener noreferrer');
        });
      }

      function attachZoomPan() {
        document.querySelectorAll('.mermaid').forEach(function(mer){
          var svg = mer.querySelector('svg');
          if (!svg) return;

          var container = document.createElement('div'); container.className = 'mz-container';
          var toolbar = document.createElement('div'); toolbar.className = 'mz-toolbar';
          var viewport = document.createElement('div'); viewport.className = 'mz-viewport';
          var content = document.createElement('div'); content.className = 'mz-content';
          var hint = document.createElement('div'); hint.className = 'mz-hint'; hint.textContent = 'Hold CTRL and scroll to zoom. Drag to pan.';

          var btnMinus = document.createElement('button'); btnMinus.title = 'Zoom out'; btnMinus.textContent = '−';
          var btnPlus = document.createElement('button'); btnPlus.title = 'Zoom in'; btnPlus.textContent = '+';
          var btnFit = document.createElement('button'); btnFit.title = 'Fit'; btnFit.textContent = 'Fit';
          var btnReset = document.createElement('button'); btnReset.title = 'Reset'; btnReset.textContent = 'Reset';
          toolbar.appendChild(btnMinus); toolbar.appendChild(btnPlus); toolbar.appendChild(btnFit); toolbar.appendChild(btnReset);

          var parent = mer.parentNode;
          parent.replaceChild(container, mer);
          container.appendChild(toolbar);
          container.appendChild(hint);
          container.appendChild(viewport);
          content.appendChild(mer);
          viewport.appendChild(content);

          var scale = 1, tx = 0, ty = 0;
          var minScale = 0.5, maxScale = 4, step = 0.2;
          function apply() { content.style.transform = 'translate(' + tx + 'px, ' + ty + 'px) scale(' + scale + ')'; }

          function fit() {
            var svgEl = mer.querySelector('svg');
            if (!svgEl) return;
            var vb = svgEl.viewBox && svgEl.viewBox.baseVal;
            var w = (svgEl.width && svgEl.width.baseVal && svgEl.width.baseVal.value) || (svgEl.getBBox ? svgEl.getBBox().width : 0);
            var h = (svgEl.height && svgEl.height.baseVal && svgEl.height.baseVal.value) || (svgEl.getBBox ? svgEl.getBBox().height : 0);
            if ((!w || !h) && vb) { w = vb.width; h = vb.height; }
            var rect = viewport.getBoundingClientRect();
            if (w && h) {
              var s = Math.min(rect.width / w, rect.height / h);
              scale = Math.max(minScale, Math.min(maxScale, s));
            } else {
              scale = 1;
            }
            tx = 0; ty = 0; apply();
          }

          btnMinus.onclick = function(){ scale = Math.max(minScale, scale - step); apply(); };
          btnPlus.onclick = function(){ scale = Math.min(maxScale, scale + step); apply(); };
          btnReset.onclick = function(){ scale = 1; tx = 0; ty = 0; apply(); };
          btnFit.onclick = fit;

          var dragging = false, lastX = 0, lastY = 0;
          viewport.addEventListener('mousedown', function(e){ dragging = true; lastX = e.clientX; lastY = e.clientY; e.preventDefault(); });
          window.addEventListener('mousemove', function(e){
            if (!dragging) return;
            var dx = e.clientX - lastX, dy = e.clientY - lastY;
            lastX = e.clientX; lastY = e.clientY; tx += dx; ty += dy; apply();
          });
          window.addEventListener('mouseup', function(){ dragging = false; });

          viewport.addEventListener('wheel', function(e){
            if (e.ctrlKey) {
              e.preventDefault();
              var newScale = e.deltaY > 0 ? Math.max(minScale, scale - step) : Math.min(maxScale, scale + step);
              scale = newScale; apply();
            } // else allow default page scroll
          }, { passive: false });

          fit();
        });
      }

      function renderSidebar(activePath) {
        if (!manifest || !Array.isArray(manifest.paths)) return;

        // Group by first segment as bin; root-level goes to 'docs'
        const groups = {};
        for (const p of manifest.paths) {
          // Exclude entire _mermaid folder from navigation
          if (p.startsWith('_mermaid/')) continue;
          const segs = p.split('/');
          const binKey = segs.length > 1 ? segs[0] : 'docs';
          if (!groups[binKey]) groups[binKey] = [];
          groups[binKey].push(p);
        }

        // Order bins with 'docs' first, then alpha
        const binKeys = Object.keys(groups).sort((a, b) => {
          if (a === 'docs' && b !== 'docs') return -1;
          if (b === 'docs' && a !== 'docs') return 1;
          return a.localeCompare(b, undefined, { sensitivity: 'base' });
        });

        const frag = document.createDocumentFragment();

        function isReadme(p) {
          const lc = p.toLowerCase();
          return lc === 'readme.md' || lc.endsWith('/readme.md');
        }

        for (const key of binKeys) {
          const details = document.createElement('details');
          details.open = (key === 'docs'); // open only Docs by default; others collapsed

          const summary = document.createElement('summary');
          summary.textContent = titleCase(key);
          details.appendChild(summary);

          const ul = document.createElement('ul');
          const pages = groups[key].slice().sort((a, b) => {
            const ra = isReadme(a), rb = isReadme(b);
            if (ra && !rb) return -1;
            if (!ra && rb) return 1;
            return pageTitleFromPath(a).localeCompare(pageTitleFromPath(b), undefined, { sensitivity: 'base' });
          });
          for (const p of pages) {
            const li = document.createElement('li');
            const a = document.createElement('a');
            a.className = 'nav';
            a.textContent = pageTitleFromPath(p);
            a.href = '#docs/' + p;
            if (('docs/' + p) === activePath) {
              a.classList.add('active');
            }
            li.appendChild(a);
            ul.appendChild(li);
          }
          details.appendChild(ul);
          frag.appendChild(details);
        }

        sidebar.innerHTML = '';
        sidebar.appendChild(frag);
      }

      async function loadManifest() {
        try {
          const resp = await fetch('./docs/_manifest.json', { cache: 'no-store' });
          if (!resp.ok) throw new Error('HTTP ' + resp.status);
          manifest = await resp.json();
          if (sidebarLoading) sidebarLoading.remove();
          renderSidebar(currentPath);
        } catch (e) {
          if (sidebarLoading) sidebarLoading.textContent = 'Failed to load index.';
        }
      }

      async function render(mdPath, anchor) {
        try {
          const resp = await fetch('./' + mdPath, { cache: 'no-store' });
          if (!resp.ok) throw new Error('HTTP ' + resp.status);
          const md = await resp.text();
          const html = marked.parse(md);
          app.innerHTML = html;
          rewriteCodeLinks();

          // Intercept in-content links to other Markdown pages
          app.querySelectorAll('a[href]').forEach(function (a) {
            const href = a.getAttribute('href');
            if (!href) return;
            // Only intercept .md links (relative or under docs/)
            if (isMdLink(href) || href.startsWith('docs/')) {
              a.addEventListener('click', function (e) {
                if (e.metaKey || e.ctrlKey || e.shiftKey || e.altKey) return;
                e.preventDefault();
                const next = resolveMd(href, currentPath);
                // Route via hash to keep SPA navigation
                window.location.hash = '#' + next.path + (next.hash || '');
              });
            }
          });

          // Convert fenced code blocks marked as mermaid into live containers
          document.querySelectorAll('pre code.language-mermaid').forEach(function (code) {
            const pre = code.closest('pre');
            const div = document.createElement('div');
            div.className = 'mermaid';
            div.textContent = code.textContent;
            pre.replaceWith(div);
          });

          if (window.mermaid) {
            window.mermaid.initialize({ startOnLoad: false });
            try {
              await window.mermaid.run({ querySelector: '.mermaid' });
              // Enable zoom/pan controls after diagrams rendered
              attachZoomPan();
            } catch (e) {
              console.error('Mermaid render error:', e);
            }
          }

          // Highlight active in sidebar and ensure its bin is open
          if (manifest && sidebar) {
            sidebar.querySelectorAll('a.nav').forEach(a => {
              a.classList.toggle('active', a.getAttribute('href') === '#' + mdPath);
              if (a.classList.contains('active')) {
                const det = a.closest('details');
                if (det) det.open = true;
              }
            });
          }

          // Scroll to in-document anchor if provided
          if (anchor) {
            const el = document.getElementById(anchor);
            if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
          }
        } catch (err) {
          app.innerHTML = '<p>Could not load ' + mdPath + '. Browse <a href="#docs/README.md">docs/</a>.</p>';
        }
      }

      async function route() {
        const next = parseHash();
        if (next.path !== currentPath) {
          currentPath = next.path;
        }
        if (manifest) {
          renderSidebar(currentPath);
        }
        await render(next.path, next.anchor);
      }

      window.addEventListener('hashchange', route);
      window.addEventListener('load', function () {
        loadManifest().then(route);
      });
    })();
  </script>
</body>
</html>`;
  await ensureDir(outDir);
  await fs.writeFile(path.join(outDir, 'index.html'), html, 'utf8');
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
    await writeIndexHtml(outDir);
    console.log(`Injection complete. Files modified: ${stats.filesTouched}. Fences injected: ${stats.fencesTouched}. Docs indexed: ${stats.manifestCount}. Index written: ${path.join(outDir, 'index.html')}`);
    process.exit(0);
  } catch (err) {
    console.error('Injector error:', err?.message || err);
    process.exit(1);
  }
}

if (import.meta.url === `file://${__filename}`) {
  main();
}