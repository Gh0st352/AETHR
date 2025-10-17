# Markers and arrows rendering

This document covers how mission zones, game bounds, and border-direction arrows are rendered.

### Primary anchors:
- [AETHR.ZONE_MANAGER:drawGameBounds()](../../dev/ZONE_MANAGER.lua:931)
- [AETHR.ZONE_MANAGER:drawMissionZones()](../../dev/ZONE_MANAGER.lua:980)
- [AETHR.ZONE_MANAGER:initZoneArrows()](../../dev/ZONE_MANAGER.lua:1075)
- [AETHR.ZONE_MANAGER:drawZoneArrows()](../../dev/ZONE_MANAGER.lua:1025)
- [AETHR.ZONE_MANAGER:drawZone()](../../dev/ZONE_MANAGER.lua:329)

### Related modules:
- Marker helpers: [dev/MARKERS.lua](../../dev/MARKERS.lua)
- Config colors and line styles: [dev/CONFIG_.lua](../../dev/CONFIG_.lua)
- Enum types: [dev/ENUMS.lua](../../dev/ENUMS.lua)


# Rendering game bounds polygons

### Entry: [AETHR.ZONE_MANAGER:drawGameBounds()](../../dev/ZONE_MANAGER.lua:931)

### Behavior:
- Builds a marker descriptor for each polygon in either HullPolysWithSample or HullPolysNoSample.
- Increments global marker counter per marker.
- Uses MARKERS to render as freeform.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  GB1[drawGameBounds] --> GB2[markerGen creates _Marker with gameBounds colors]
  subgraph "Out of bounds"
    GB2 --> GB3[loop HullPolysWithSample or NoSample]
    GB3 --> GB4[MARKERS markFreeform for OutOfBounds]
  end
  subgraph "Gaps"
    GB4 --> GB5[loop inOutBoundsGaps convex]
    GB5 --> GB6[MARKERS markFreeform for InOutBoundsGaps]
  end
  GB6 --> GB7[return self]
  class GB2 class_compute;
  class GB7 class_result;
```

### Configuration fields:
- Colors and line style: 
  - [AETHR.CONFIG.MAIN.Zone.gameBounds.LineColors](../../dev/CONFIG_.lua:322)
  - [AETHR.CONFIG.MAIN.Zone.gameBounds.FillColors](../../dev/CONFIG_.lua:323)
  - [AETHR.CONFIG.MAIN.Zone.gameBounds.FillAlpha](../../dev/CONFIG_.lua:324)
  - [AETHR.CONFIG.MAIN.Zone.gameBounds.LineAlpha](../../dev/CONFIG_.lua:325)
  - [AETHR.CONFIG.MAIN.Zone.gameBounds.lineType](../../dev/CONFIG_.lua:326)


# Rendering mission zones

### Entry: [AETHR.ZONE_MANAGER:drawMissionZones()](../../dev/ZONE_MANAGER.lua:980)

### Behavior:
- Creates a _Marker per zone using coalition keyed paint colors.
- Stores markerObject on the zone for potential updates elsewhere.
- Renders via MARKERS markFreeform.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  MZ1[drawMissionZones] --> MZ2[for each zone build _Marker with shapeID and vertices]
  subgraph "Colors and counters"
    MZ2 --> MZ3[choose colors from paintColors using zone ownedBy]
    MZ3 --> MZ4[increment CONFIG counters markers]
  end
  MZ4 --> MZ5[assign zone markerObject]
  MZ5 --> MZ6[MARKERS markFreeform to MizZones bucket]
  MZ6 --> MZ7[return self]
  class MZ2 class_compute;
  class MZ6 class_io;
  class MZ7 class_result;
```

### Configuration fields:
- [AETHR.CONFIG.MAIN.Zone.paintColors.LineColors](../../dev/CONFIG_.lua:297)
- [AETHR.CONFIG.MAIN.Zone.paintColors.FillColors](../../dev/CONFIG_.lua:302)
- [AETHR.CONFIG.MAIN.Zone.paintColors.ArrowColors](../../dev/CONFIG_.lua:307)
- [AETHR.CONFIG.MAIN.Zone.paintColors.FillAlpha](../../dev/CONFIG_.lua:317)
- [AETHR.CONFIG.MAIN.Zone.paintColors.LineAlpha](../../dev/CONFIG_.lua:318)
- [AETHR.CONFIG.MAIN.Zone.paintColors.lineType](../../dev/CONFIG_.lua:319)


# Initializing arrow markers

### Entry: [AETHR.ZONE_MANAGER:initZoneArrows()](../../dev/ZONE_MANAGER.lua:1075)

### Behavior:
- For every border segment on every zone, assigns MarkID for all coalitions if missing.
- Derives ArrowTip and ArrowEnd from border perpendicular endpoints computed during bordering detection.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  IA1[initZoneArrows] --> IA2[for each zone and neighbor borders]
  IA2 --> IA3[for each borderDetail if MarkID zero allocate from counters]
  subgraph "Endpoints"
    IA3 --> IA4[set ArrowTip from NLPP]
    IA4 --> IA5[set ArrowEnd from ZLPP]
  end
  IA5 --> IA6[return self]
  class IA3,IA4,IA5 class_compute;
  class IA6 class_result;
```

### Notes:
- NLPP equals NeighborLinePerpendicularPoint
- ZLPP equals ZoneLinePerpendicularPoint
- These endpoints are computed in bordering detection and adjusted to lie inside the zone; see [docs/zone_manager/borders_and_master.md](docs/zone_manager/borders_and_master.md)


# Drawing arrow markers

### Entry: [AETHR.ZONE_MANAGER:drawZoneArrows()](../../dev/ZONE_MANAGER.lua:1025)

### Behavior:
- For each border segment, for each coalition from 0 to 2, builds an arrow _Marker using ArrowColors.
- Calls MARKERS markArrow to render.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart TD
  DA1[drawZoneArrows] --> DA2[for each zone and neighbor borders]
  DA2 --> DA3[for each borderDetail iterate coalitions 0..2]
  DA3 --> DA4[build arrow _Marker with MarkID and ArrowTip ArrowEnd]
  DA4 --> DA5[MARKERS markArrow into ZoneArrows bucket]
  DA5 --> DA6[return self]
  class DA4 class_compute;
  class DA5 class_io;
  class DA6 class_result;
```

### Configuration fields:
- Arrow colors by coalition: [AETHR.CONFIG.MAIN.Zone.paintColors.ArrowColors](../../dev/CONFIG_.lua:307)
- Line style used here: [AETHR.ENUMS.LineTypes.Solid](../../dev/ENUMS.lua)


# Drawing a raw polygon shape on F10

### Entry: [AETHR.ZONE_MANAGER:drawZone()](../../dev/ZONE_MANAGER.lua:329)

### Behavior:
- Sends a polygon draw command via trigger.action.markupToAll using four Vec3 points.
- Parameters include coalition, fill and border colors, and line type.

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
flowchart LR
  DZ1[drawZone] --> DZ2[prepare 4 Vec3 points from Vec2 list]
  DZ2 --> DZ3[call trigger action markupToAll with colors and lineType]
  DZ3 --> DZ4[return self]
  class DZ3 class_io;
  class DZ4 class_result;
```

### Use cases:
- Ad hoc debug polygons or legacy flows outside the freeform marker system.


# Runtime sequence overview

```mermaid
%% shared theme: docs/_mermaid/theme.json %%
sequenceDiagram
  participant ZM as ZONE_MANAGER
  participant CFG as CONFIG
  participant MK as MARKERS

  ZM->>CFG: read paintColors and gameBounds styles
  ZM->>MK: markFreeform for outOfBounds polygons
  ZM->>MK: markFreeform for inOutBoundsGaps
  ZM->>MK: markFreeform for mission zones
  ZM->>ZM: initZoneArrows assign MarkID and endpoints
  ZM->>MK: markArrow for each coalition per border
```

### Downstream updates:
- Zone color updates and arrow visibility changes can be applied by WORLD reactions to ownership changes; see watchers documentation.


# Anchor index

- [AETHR.ZONE_MANAGER:drawGameBounds()](../../dev/ZONE_MANAGER.lua:931)
- [AETHR.ZONE_MANAGER:drawMissionZones()](../../dev/ZONE_MANAGER.lua:980)
- [AETHR.ZONE_MANAGER:initZoneArrows()](../../dev/ZONE_MANAGER.lua:1075)
- [AETHR.ZONE_MANAGER:drawZoneArrows()](../../dev/ZONE_MANAGER.lua:1025)
- [AETHR.ZONE_MANAGER:drawZone()](../../dev/ZONE_MANAGER.lua:329)
- [dev/MARKERS.lua](../../dev/MARKERS.lua)
- [dev/CONFIG_.lua](../../dev/CONFIG_.lua)
- [dev/ENUMS.lua](../../dev/ENUMS.lua)