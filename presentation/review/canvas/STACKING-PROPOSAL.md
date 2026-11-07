# Proposal: stack Mochi accessories by head, face and neck

**What would you like Mochi to do?**

Wear one accessory on the head, one on the face and one around the neck together, instead of adding a new outfit ID for each combination.

**Why would it be useful?**

Beanie + glasses + scarf should be three choices, not another outfit to maintain. I'd like to agree on the design before implementing it.

**Wardrobe**

Keep the existing tile style and live preview, with three labelled rows:

| Head | Face | Neck |
| --- | --- | --- |
| None, beanie, crown, hats/ears… | None, round glasses, sunglasses | None, scarf |

Hover previews that slot against the current look. Clicking replaces only that slot; None clears it. Keep seasonal Auto and Android's Follow computer option.

**What is stored**

Proposed logical preference, with names to agree after #1025:

```json
{
  "version": 1,
  "mode": "manual",
  "head": "beanie",
  "face": "roundGlasses",
  "neck": "scarf"
}
```

Absent preferences keep today's behaviour. On migration, put an existing accessory in its slot and leave the others empty, without deleting the old `mochiOutfit` value or changing a body/skin ID. Auto keeps the existing seasonal rules; saved manual choices are inactive while Auto is selected. Keep the base/skin choice separate and use #1025's final representation and registry, rather than a second catalog.

**Platforms and compatibility**

Mac, Windows/Linux and Android should share the slot rules and stable accessory IDs, using their existing Canvas drawing code, with no new dependencies. For older phone clients, keep sending a supported legacy outfit value (or `none` if needed); send stacked state only when the receiver advertises support. No composite IDs in the old field.

Include migration, slot replacement, drawing/transition and Android parity tests, and update `docs/SPEC.md`.

**Before starting**

I'll wait until #1025 is settled and the design is agreed, then open a focused PR from a Coucou fork. The room stays separate.

Does this picker and storage model fit? How should skins declare which accessory slots they support?
