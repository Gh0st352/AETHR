# TYPES borders and zones

Anchors
- [AETHR._BorderInfo:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L232)
- [AETHR._ZoneBorder:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L97) (deprecated wrapper to BorderInfo)
- [AETHR._MIZ_ZONE:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L283)
- [AETHR.POLY:convertPolygonToLines()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L737)

Overview
- _BorderInfo captures geometric and ownership metadata for a shared border segment between two zones.
- _ZoneBorder is deprecated and forwards to _BorderInfo for backward compatibility.
- _MIZ_ZONE normalizes env.mission trigger zone data and precomputes LinesVec2 for downstream processing.

# Structure relationships
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  subgraph ZONE ["_MIZ_ZONE and relations"]
    Z[_MIZ_ZONE]
    L[LinesVec2]
    BZ[BorderingZones map]
    Z --> L
    Z --> BZ
  end

  BZ --> BI[_BorderInfo]

  subgraph BORDER_INFO ["_BorderInfo fields"]
    subgraph GEOM ["Geometry metrics"]
      ZL[ZoneLine]
      NL[NeighborLine]
      LEN[ZoneLineLen NeighborLineLen]
      MID[ZoneLineMidP NeighborLineMidP]
      SLP[ZoneLineSlope NeighborLineSlope]
      PERP[Perpendicular points]
    end
    subgraph OWN_MARK ["Ownership and markers"]
      OWN[OwnedByCoalition]
      ARW[ArrowTip ArrowEnd]
      MK[MarkID ArrowObjects]
    end
  end

  BI --> ZL
  BI --> NL
  BI --> LEN
  BI --> MID
  BI --> SLP
  BI --> PERP
  BI --> OWN
  BI --> ARW
  BI --> MK

  class Z,L,BZ,BI,ZL,NL,LEN,MID,SLP,PERP,OWN,ARW,MK,ZONE,BORDER_INFO,GEOM,OWN_MARK class_data;
```

# Zone initialization path
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant M as _MIZ_ZONE
  participant P as POLY
  Note over M: env.mission provides vertices
  M->>P: convertPolygonToLines(vertices)
  P-->>M: LinesVec2 segments
  M-->>M: store LinesVec2 for border detection and drawing
```

# Border detection and storage concept
```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  subgraph LINES_A ["Zone A edges"]
    ZA[Zone A Lines]
    PA[Edge Ai]
    ZA -- "iterate edges" --> PA
  end

  subgraph LINES_B ["Zone B edges"]
    ZB[Zone B Lines]
    PB[Edge Bj]
    ZB -- "iterate edges" --> PB
  end

  PA -- "compare with" --> PB
  PA --- BI1[_BorderInfo created]

  subgraph BI_FIELDS ["_BorderInfo fields"]
    OWN2[OwnedByCoalition]
    GEO[Midpoints Slopes Lengths]
    AR[ArrowTip ArrowEnd]
    MK2[MarkID ArrowObjects]
  end

  BI1 --> OWN2
  BI1 --> GEO
  BI1 --> AR
  BI1 --> MK2

  class ZA,PA,ZB,PB,BI1,OWN2,GEO,AR,MK2,LINES_A,LINES_B,BI_FIELDS class_data;
```

# Deprecated wrapper
- [AETHR._ZoneBorder:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L97) calls [AETHR._BorderInfo:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L232) and sets OwnedByCoalition; prefer constructing _BorderInfo directly.

# Usage notes
- Ownership toggles and marker updates consume _BorderInfo to compute arrow placement and color decisions.
- LinesVec2 must reflect current zone vertex ordering; if vertices are mutated, recompute LinesVec2.

# Source anchors
- _BorderInfo constructor: [AETHR._BorderInfo:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L232)
- Deprecated alias: [AETHR._ZoneBorder:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L97)
- Zone constructor: [AETHR._MIZ_ZONE:New()](https://github.com/Gh0st352/AETHR/blob/main/dev/customTypes.lua#L283)
- Segment conversion: [AETHR.POLY:convertPolygonToLines()](https://github.com/Gh0st352/AETHR/blob/main/dev/POLY.lua#L737)