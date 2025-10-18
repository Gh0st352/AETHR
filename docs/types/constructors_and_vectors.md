# TYPES constructors and vectors

Anchors
- [AETHR._vec2:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L522)
- [AETHR._vec2xz:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L542)
- [AETHR._vec3:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L114)
- [AETHR._BBox:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L136)

Aliases
- [_LineVec2](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L38) two point array representing a segment
- [_PolygonVec2](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L39) 3 or more vertices forming a polygon

Overview
- These are foundational constructors used across POLY, WORLD, SPAWNER, and MARKERS.
- Defaults are defensive: unset numeric fields default to 0 to ensure arithmetic safety.
- _vec2 is the canonical 2D point for POLY and MATH. Many APIs also accept _vec2xz for world XZ.

# Mermaid flow overview
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  CALLER[Caller]

  subgraph VEC2 ["_vec2 fields"]
    V2[vec2 New]
    V2x[x default 0]
    V2y[y default 0]
    V2 --> V2x
    V2 --> V2y
  end

  subgraph VEC2XZ ["_vec2xz fields"]
    V2XZ[vec2xz New]
    V2xZ[x default 0]
    V2zZ[z default 0]
    V2XZ --> V2xZ
    V2XZ --> V2zZ
  end

  subgraph VEC3 ["_vec3 fields"]
    V3[vec3 New]
    V3x[x default 0]
    V3y[y default 0]
    V3z[z default 0]
    V3 --> V3x
    V3 --> V3y
    V3 --> V3z
  end

  subgraph BBOX ["_BBox fields"]
    BB[BBox New]
    BBminx[minx default 0]
    BBmaxx[maxx default 0]
    BBminy[miny default 0]
    BBmaxy[maxy default 0]
    BB --> BBminx
    BB --> BBmaxx
    BB --> BBminy
    BB --> BBmaxy
  end

  CALLER --> V2
  CALLER --> V2XZ
  CALLER --> V3
  CALLER --> BB

  NB[Bounding box used for coarse filtering in zone grids]
  BBminx -.-> NB
  NB -.-> BBmaxy

  class V2,V2x,V2y,V2XZ,V2xZ,V2zZ,V3,V3x,V3y,V3z,BB,BBminx,BBmaxx,BBminy,BBmaxy,CALLER,NB,VEC2,VEC2XZ,VEC3,BBOX class_data;
```

# Key creation paths
- _vec2: [AETHR._vec2:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L522) sets x and y, defaulting to 0.
- _vec2xz: [AETHR._vec2xz:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L542) sets x and z for world plane calculations.
- _vec3: [AETHR._vec3:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L114) sets x y z for world coordinates.
- _BBox: [AETHR._BBox:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L136) sets minx maxx miny maxy for spatial indexing.

## Typical usage sequences
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant C as Caller
  participant T as Types
  participant P as POLY
  C->>T: create vec2
  C->>T: create vec2xz
  C->>T: create BBox
  C->>T: create vec3
  C->>P: convert polygon to lines
  Note over P: uses PolygonVec2 and LineVec2 internally
```

## Cross module references
- POLY polygon conversion: [AETHR.POLY:convertPolygonToLines()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L737)
- POLY bounds to polygon: [AETHR.POLY:convertBoundsToPolygon()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L1039)

## Notes
- Prefer _vec2 for planar math; pass _vec2xz when consuming world XZ data and normalize at module edges.
- Maintain consistent winding for polygon vertices when interoperating with POLY utilities.

## Source anchors
- [_LineVec2](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L38), [_PolygonVec2](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L39)
- [AETHR._vec2:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L522), [AETHR._vec2xz:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L542), [AETHR._vec3:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L114), [AETHR._BBox:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L136)