# WORLD ownership propagation, colors, and arrows

Primary anchors
- Airbase/zone ownership updates:
  - [AETHR.WORLD:updateAirbaseOwnership()](../../dev/WORLD.lua:501)
  - [AETHR.WORLD:updateZoneOwnership()](../../dev/WORLD.lua:633)
- Visual updates:
  - [AETHR.WORLD:updateZoneColors()](../../dev/WORLD.lua:683)
  - [AETHR.WORLD:updateZoneArrows()](../../dev/WORLD.lua:730)
- Notifications:
  - [AETHR.WORLD.airbaseOwnershipChanged()](../../dev/WORLD.lua:970)
  - [AETHR.WORLD.zoneOwnershipChanged()](../../dev/WORLD.lua:1006)

Related modules and config
- Colors and alphas: [dev/CONFIG_.lua](../../dev/CONFIG_.lua)
- Text strings and enums: [dev/ENUMS.lua](../../dev/ENUMS.lua)
- Marker color updates: [AETHR.UTILS:updateMarkupColors()](../../dev/UTILS.lua:188)

## Airbase ownership refresh

updateAirbaseOwnership iterates all MIZ zones and their airbases, querying the engine for current coalition and updating each airbase object. It optionally yields via configured coroutine thresholds.

```mermaid
flowchart TD
  UAO[[updateAirbaseOwnership]] --> ZL[for each zone in ZONE_MANAGER.DATA.MIZ_ZONES]
  ZL --> ABL[for each airbase in zone Airbases]
  ABL --> GET[Airbase getByName and getCoalition via pcall]
  GET --> CHK{coalition changed}
  CHK -->|yes| UPD[update previousCoalition and coalition fields]
  CHK -->|no| NEXT
  UPD --> YLD{yield threshold}
  NEXT --> YLD
  YLD -->|hit| CY[debug yield]
  YLD -->|not hit| CONT
  CY --> CONT
  CONT --> DONE[return self]
```

## Zone ownership recompute

updateZoneOwnership tallies airbases per coalition within each zone, determines the winner (or neutral on tie), and records changes.

```mermaid
flowchart TD
  UZO[[updateZoneOwnership]] --> ZL[for each zone]
  ZL --> CNT[reset red and blue counters]
  CNT --> ABL[for each airbase in zone Airbases]
  ABL --> INC[count red and blue by coalition]
  INC --> YLD{yield threshold}
  YLD -->|hit| CY[debug yield]
  YLD -->|not hit| CNCL{compare counts}
  CY --> CNCL
  CNCL -->|red gt blue| OWN[owner is RED]
  CNCL -->|blue gt red| OWN2[owner is BLUE]
  CNCL -->|tie| OWN3[owner is NEUTRAL]
  OWN --> SET[update zone ownership fields]
  OWN2 --> SET
  OWN3 --> SET
  SET --> RET[return self]
```

## Zone color updates

updateZoneColors changes the painted colors of zone polygons when ownership changes, using coalition-keyed paint colors.

```mermaid
flowchart TD
  UZC[[updateZoneColors]] --> ZL[for each zone]
  ZL --> COMP{ownedBy differs from lastMarkColorOwner}
  COMP -->|no| NXT
  COMP -->|yes| CLR[select line and fill from paintColors]
  CLR --> MRK{zone markerObject has markID}
  MRK -->|yes| CALL[UTILS updateMarkupColors with markID lineColor fillColor]
  MRK -->|no| SKIP
  CALL --> SAVE[set lastMarkColorOwner to ownedBy]
  SKIP --> SAVE
  SAVE --> YLD{yield threshold}
  YLD -->|hit| CY[debug yield]
  YLD -->|not hit| NXT
  CY --> NXT
  NXT --> DONE[return self]
```

## Border arrows visibility

updateZoneArrows toggles visibility of directional border arrows between neighboring zones depending on ownership differences. For each border segment, it hides the previously shown coalition arrow (if any) and shows the newly desired coalition arrow.

```mermaid
flowchart TD
  UZA[[updateZoneArrows]] --> ZL[for each zone]
  ZL --> BZL[for each bordering zone and borderDetail]
  BZL --> DES[desiredShown equals ownedBy if ownedBy differs from neighbor]
  DES --> CHG{desiredShown differs from lastShownCoalition}
  CHG -->|no| NEXT
  CHG -->|yes| HIDE[if lastShown arrow exists then set alpha zero via updateMarkupColors]
  HIDE --> SHOW[if desiredShown arrow exists then set alpha using ArrowColors value]
  SHOW --> SAVE[set lastShownCoalition to desiredShown]
  SAVE --> YLD{yield threshold}
  YLD -->|hit| CY[debug yield]
  YLD -->|not hit| NEXT
  CY --> NEXT
  NEXT --> DONE[return self]
```

Arrow colors source
- [AETHR.CONFIG.MAIN.Zone.paintColors.ArrowColors](../../dev/CONFIG_.lua)
- Line style typically solid (see [dev/ENUMS.lua](../../dev/ENUMS.lua))

## Notifications

These callbacks are used by watchers or event systems to broadcast ownership changes.

Airbase

```mermaid
flowchart LR
  AOC[[airbaseOwnershipChanged]] --> GET[lookup old owner from zones]
  GET --> DIFF{new differs from old}
  DIFF -->|yes| TEXT[compose outText using ENUMS text strings and teams]
  TEXT --> OUT[trigger outText with displayTime and clearView]
  OUT --> RET[return self]
  DIFF -->|no| RET
```

Zone

```mermaid
flowchart LR
  ZOC[[zoneOwnershipChanged]] --> GET[get oldOwner from zone]
  GET --> DIFF{new differs from old}
  DIFF -->|yes| TEXT[compose contested or captured message]
  TEXT --> OUT[trigger outText]
  OUT --> RET[return self]
  DIFF -->|no| RET
```

## Sequence overview (ownership to visuals)

```mermaid
sequenceDiagram
  participant W as WORLD
  participant U as UTILS
  participant C as CONFIG
  W->>W: updateAirbaseOwnership
  W->>W: updateZoneOwnership
  W->>C: read Zone.paintColors
  W->>U: updateMarkupColors for zone polygons
  W->>W: updateZoneArrows toggle visibility
```

## Anchor index

- Ownership updates
  - [AETHR.WORLD:updateAirbaseOwnership()](../../dev/WORLD.lua:501)
  - [AETHR.WORLD:updateZoneOwnership()](../../dev/WORLD.lua:633)
- Visual updates
  - [AETHR.WORLD:updateZoneColors()](../../dev/WORLD.lua:683)
  - [AETHR.WORLD:updateZoneArrows()](../../dev/WORLD.lua:730)
- Notifications
  - [AETHR.WORLD.airbaseOwnershipChanged()](../../dev/WORLD.lua:970)
  - [AETHR.WORLD.zoneOwnershipChanged()](../../dev/WORLD.lua:1006)