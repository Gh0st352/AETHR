# Shared Mermaid Theme for diagrams

Purpose and audience
- Centralize visual styling for all FILEOPS Mermaid diagrams so colors and styles are defined once and applied everywhere during doc generation.
- Audience: maintainers who generate or publish the documentation.

Theme source
- Shared theme definition: [docs/_mermaid/theme.json](./theme.json)

How diagrams reference the shared theme
- Each diagram in docs contains a placeholder comment:
  - %% shared theme: docs/_mermaid/theme.json %%
- This is a build-time marker. GitHub does not automatically include the external JSON. Your doc build step must replace this line with a full Mermaid init block.

Required build step (injection)
- Replace the theme marker line with the contents of the JSON file inside a Mermaid init fence.
- Example injection target (before):
  - ```mermaid
    %% shared theme: docs/_mermaid/theme.json %%
    flowchart
    ...
    ```

- Example injection result (after):
  - ```mermaid
    %%{init: {"theme":"base","themeVariables": { ... }, "themeCSS": "..." }}%%
    flowchart
    ...
    ```

Class buckets used in diagrams
- Node/style classes referenced across documents:
  - class_io
  - class_compute
  - class_data
  - class_tracker
  - class_decision
  - class_result
  - class_step
- These classes are mapped to colors and strokes by themeVariables and themeCSS in [docs/_mermaid/theme.json](./theme.json).

Customization policy
- Edit colors in [docs/_mermaid/theme.json](./theme.json) only.
- Do not add inline hex colors, rgba(), classDef fill/stroke, or style fill/stroke in individual diagrams.
- To globally restyle:
  - Change palette keys in themeVariables
  - Optionally adjust themeCSS selectors for fine-grained tweaks

Validation checklist
- No inline hex or rgba in FILEOPS diagrams
  - Patterns to scan (use your preferred search):
    - “#RGB” / “#RRGGBB”
    - “rgba(” or “rgb(”
    - “classDef ... fill:” or “style ... fill:”
    - “rect #...”
- All diagrams include the shared theme marker line
- Diagrams use class assignments only, e.g.:
  - class NODE_A,NODE_B class_io;
  - class NODE_C class_compute;
- Wrap the subgraph labels in double quotes in the Mermaid diagram: `["xxxx (xx)"]`
- Ensure all documentation headers and titles have a header notation at the start of the line, example: `# Title header`
- Ensure all documentation subheaders and subtitles have a subheader notation at the start of the line, example: `## sub-Title header`

Notes
- This repository does not run the injection itself. Ensure your docs pipeline (e.g., pre-publish script) performs the replacement of the marker comment with the JSON contents wrapped as a Mermaid init block.
- If adding new diagram classes, update both:
  - themeVariables and themeCSS in [docs/_mermaid/theme.json](./theme.json)
  - Class usage guidelines in this README
  - Example Syntax for different Mermaid diagram types found in [docs/_mermaid/_syntax/](./_syntax)