/*!
 * AETHR Docs - Code Link Rewriter
 * Rewrites relative Markdown code links like "../../dev/FSM.lua:366"
 * into GitHub blob anchors "https://github.com/<owner>/<repo>/blob/<branch>/dev/FSM.lua#L366"
 * Supports single-line and ranges (e.g., :12-34 -> #L12-L34)
 */
(function () {
  'use strict';

  function getRepoInfo() {
    var html = document.documentElement || document.body || document;
    var ds = (html && html.dataset) || {};
    var owner = ds.repoOwner || '';
    var repo = ds.repoName || '';
    var nwo = ds.repoNwo || '';
    var branch = ds.repoBranch || '';

    if ((!owner || !repo) && nwo && nwo.indexOf('/') > -1) {
      var parts = nwo.split('/');
      owner = owner || parts[0];
      repo = repo || parts[1];
    }

    // Fallback heuristics for GitHub Pages project sites, e.g. gh0st352.github.io/AETHR/
    if (!owner || !repo) {
      try {
        var host = window.location.hostname || '';
        var hostParts = host.split('.');
        if (!owner && hostParts.length >= 1) {
          owner = hostParts[0]; // "gh0st352"
        }
        var pathParts = (window.location.pathname || '').split('/').filter(Boolean);
        if (!repo && pathParts.length >= 1) {
          repo = pathParts[0]; // "AETHR"
        }
      } catch (e) {
        // no-op
      }
    }

    if (!branch) {
      // Default branch commonly "main" (fallback if metadata unavailable)
      branch = 'main';
    }

    return { owner: owner, repo: repo, branch: branch };
  }

  function normalizeDevPath(href) {
    // Strip any hash or query
    var raw = (href || '').split('#')[0].split('?')[0];

    // Find the "dev/" segment inside the URL to anchor path from there
    var idx = raw.indexOf('dev/');
    if (idx === -1) return null;

    var tail = raw.slice(idx); // e.g., "dev/FSM.lua:366" or "dev/_AI.lua:319"
    // Separate line spec by right-most colon if followed by digits
    var colonIdx = tail.lastIndexOf(':');
    var path = tail;
    var lineSpec = '';

    if (colonIdx !== -1) {
      var after = tail.slice(colonIdx + 1);
      if (/^\d/.test(after)) {
        path = tail.slice(0, colonIdx);
        lineSpec = after; // "366" or "12-34"
      }
    }

    if (!/\.lua$/i.test(path)) return null;
    return { path: path.replace(/^\.\/+/, ''), lineSpec: lineSpec };
  }

  function toGitHubBlobURL(info, devPath, lineSpec) {
    var suffix = '';
    if (lineSpec) {
      var m = String(lineSpec).match(/^(\d+)(?:-(\d+))?$/);
      if (m) {
        suffix = '#L' + m[1] + (m[2] ? '-L' + m[2] : '');
      }
    }
    return 'https://github.com/' + info.owner + '/' + info.repo + '/blob/' + info.branch + '/' + devPath + suffix;
  }

  function isEligibleHref(href) {
    if (!href) return false;
    var s = href.trim();
    // Skip external, mailto, and page fragment links
    if (/^(?:https?:|mailto:|#)/i.test(s)) return false;
    // Only process Lua code links with a numeric suffix like ":123" or ":12-34"
    if (!/\.lua:\d/.test(s)) return false;
    // Must reference the "dev/" source tree somewhere in the path
    if (s.indexOf('dev/') === -1) return false;
    return true;
  }

  function rewriteAnchors(root) {
    var info = getRepoInfo();
    if (!info.owner || !info.repo) return;

    var scope = root || document;
    var anchors = scope.querySelectorAll('a[href]');
    for (var i = 0; i < anchors.length; i++) {
      var a = anchors[i];
      if (!a || a.dataset.codeLinkRewritten === '1') continue;

      var href = a.getAttribute('href');
      if (!isEligibleHref(href)) continue;

      var norm = normalizeDevPath(href);
      if (!norm) continue;

      var url = toGitHubBlobURL(info, norm.path, norm.lineSpec);
      a.setAttribute('href', url);
      a.setAttribute('target', '_blank');
      a.setAttribute('rel', 'noopener');
      a.dataset.codeLinkRewritten = '1';
    }
  }

  function observeForLateContent() {
    if (!('MutationObserver' in window)) return;
    try {
      var mo = new MutationObserver(function (mutations) {
        for (var i = 0; i < mutations.length; i++) {
          var m = mutations[i];
          if (!m.addedNodes || !m.addedNodes.length) continue;
          for (var j = 0; j < m.addedNodes.length; j++) {
            var node = m.addedNodes[j];
            if (node && node.nodeType === 1) {
              // Re-process only the subtree that changed for efficiency
              rewriteAnchors(node);
            }
          }
        }
      });
      mo.observe(document.body || document.documentElement, { childList: true, subtree: true });
    } catch (e) {
      // no-op
    }
  }

  function init() {
    try { rewriteAnchors(document); } catch (e) { /* no-op */ }
    observeForLateContent();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init, { once: true });
  } else {
    init();
  }
})();