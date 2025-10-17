# Borders detection and master polygon construction

### This document covers:
- Bordering zone detection and border detail computation
- Master in-bounds polygon construction from non-border edges

### Primary anchors:
- [AETHR.ZONE_MANAGER:determineBorderingZones()](../../dev/ZONE_MANAGER.lua:232)
- [AETHR.ZONE_MANAGER:getMasterZonePolygon()](../../dev/ZONE_MANAGER.lua:520)

### Related configuration and geometry:
- Offset threshold and arrow length: [dev/CONFIG_.lua](../../dev/CONFIG_.lua)
  - BorderOffsetThreshold at [AETHR.CONFIG.MAIN.Zone.BorderOffsetThreshold](../../dev/CONFIG_.lua:333)
  - ArrowLength at [AETHR.CONFIG.MAIN.Zone.ArrowLength](../../dev/CONFIG_.lua:335)
- Geometry helpers used implicitly: [dev/POLY.lua](../../dev/POLY.lua)

### Notes:
- Mermaid nodes avoid double quotes and parentheses per renderer constraints.
- The border data structure is created per neighbor zone and per bordering segment.


# Bordering zone detection flow

### Entry point: [AETHR.ZONE_MANAGER:determineBorderingZones()](../../dev/ZONE_MANAGER.lua:232)

### Behavior summary:
- For each ordered pair of distinct zones, compare every line of zone1 against every line of zone2.
- Two lines are considered bordering when their distance is within zone1.BorderOffsetThreshold.
- For each border segment detected, compute zone and neighbor metrics and store an entry in MIZ_ZONES[zone1].BorderingZones[zone2].

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  A[determineBorderingZones] --> B[for each zone1]
  subgraph "Zone pair iteration"
    B --> C[for each zone2 not equal zone1]
    C --> D[ensure BorderingZones table for zone1]
    D --> E[for each line of zone1]
    E --> F[for each line of zone2]
  end
  F --> G{within offset threshold}
  G -->|no| H[next pair]
  G -->|yes| I[create BorderInfo]
  subgraph "Metrics and endpoints"
    I --> J[set zone and neighbor lines]
    J --> K[compute lengths slopes midpoints]
    K --> L[choose arrow midpoint based on shorter]
    L --> M[compute perpendicular endpoints]
    M --> N[flip endpoints if outside zone]
  end
  N --> O[save BorderInfo in BorderingZones]
  H --> P[next]
  O --> P
  class A,B,C,D,E,F,H,I,J,L,N,O,P class_step;
  class K,M class_compute;
  class G class_decision;
```

### Key data fields set on each border detail:
- Ownership
  - OwnedByCoalition
- Zone segment metrics
  - ZoneLine
  - ZoneLineLen
  - ZoneLineMidP
  - ZoneLineSlope
  - ZoneLinePerpendicularPoint
- Neighbor segment metrics
  - NeighborLine
  - NeighborLineLen
  - NeighborLineMidP
  - NeighborLineSlope
  - NeighborLinePerpendicularPoint
- Markers
  - MarkID table for coalitions
- Arrow endpoints
  - ArrowTip
  - ArrowEnd

Clickable anchor:
- [AETHR.ZONE_MANAGER:determineBorderingZones()](../../dev/ZONE_MANAGER.lua:232)


## Arrow endpoint resolution

Within [AETHR.ZONE_MANAGER:determineBorderingZones()](../../dev/ZONE_MANAGER.lua:232), arrow endpoints are chosen by comparing segment lengths and projecting perpendicular endpoints from the midpoint of the shorter line:
- When the zone line is shorter or equal, use its midpoint as ArrowMP and set lengths based on [AETHR.CONFIG.MAIN.Zone.ArrowLength](../../dev/CONFIG_.lua:335), with neighbor perpendicular length negated.
- If the neighbor line is shorter, the logic mirrors with neighbor values.

### Safety check:
- If the computed zone perpendicular endpoint lies outside the zone polygon, the endpoints are swapped to ensure arrows point inward relative to the zone.

This ensures a consistent visual indication for border direction per coalition later used by the arrow drawing routines.


# Master polygon construction flow

### Entry point: [AETHR.ZONE_MANAGER:getMasterZonePolygon()](../../dev/ZONE_MANAGER.lua:520)

### Behavior summary:
- Aggregates all zone edges excluding edges that belong to shared borders.
- Converts the remaining set of edges into a polygon representing the master in bounds shape.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  M1[getMasterZonePolygon] --> M2[collect all zone lines]
  subgraph "Exclude shared borders"
    M2 --> M3[exclude lines that match any BorderingZones ZoneLine]
    M3 --> M4[masterPolyLines equals non border lines]
  end
  M4 --> M5[convert lines to polygon using POLY]
  M5 --> M6[store in DATA inBounds polyVerts and polyLines]
  M6 --> M7[return self]
  class M1,M2,M3,M4,M5,M6 class_step;
  class M5 class_compute;
  class M7 class_result;
```

### Important details:
- The exclusion step compares by reference equality with stored border ZoneLine objects.
- Polygon conversion applies an offset parameter read from configuration:
  - [AETHR.CONFIG.MAIN.Zone.BorderOffsetThreshold](../../dev/CONFIG_.lua:333)
- Outputs are stored at:
  - DATA.GAME_BOUNDS.inBounds.polyLines
  - DATA.GAME_BOUNDS.inBounds.polyVerts

### Clickable anchor:
- [AETHR.ZONE_MANAGER:getMasterZonePolygon()](../../dev/ZONE_MANAGER.lua:520)


# Runtime sequence overview

This sequence shows how bordering detection typically precedes master polygon construction within a generation loop.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant ZM as ZONE_MANAGER
  participant CFG as CONFIG
  participant POLY as POLY
  ZM->>ZM: determineBorderingZones
  ZM->>POLY: check proximity and compute metrics
  POLY-->>ZM: results and endpoints
  ZM->>CFG: read BorderOffsetThreshold and ArrowLength
  ZM->>ZM: getMasterZonePolygon
  ZM->>POLY: convert lines to polygon with offset
  POLY-->>ZM: master polygon verts
  ZM-->>ZM: store in inBounds polyLines and polyVerts
```

### Note:
- The exact conversion algorithm is encapsulated in POLY and not expanded here; see [dev/POLY.lua](../../dev/POLY.lua).


# Data structure overview

Per zone, BorderingZones is a map keyed by neighbor name to a list of border segments. Each segment stores both zone and neighbor line descriptors, perpendicular endpoints for arrow placement, and preallocated MarkIDs per coalition. This is populated in [AETHR.ZONE_MANAGER:determineBorderingZones()](../../dev/ZONE_MANAGER.lua:232) and later consumed by arrow initialization and drawing routines documented in markers and arrows.

Downstream consumers:
- Arrow init and draw: see [docs/zone_manager/markers_and_arrows.md](docs/zone_manager/markers_and_arrows.md)


# Anchor index

- [AETHR.ZONE_MANAGER:determineBorderingZones()](../../dev/ZONE_MANAGER.lua:232)
- [AETHR.ZONE_MANAGER:getMasterZonePolygon()](../../dev/ZONE_MANAGER.lua:520)
- [AETHR.CONFIG.MAIN.Zone.BorderOffsetThreshold](../../dev/CONFIG_.lua:333)
- [AETHR.CONFIG.MAIN.Zone.ArrowLength](../../dev/CONFIG_.lua:335)
- [dev/POLY.lua](../../dev/POLY.lua)