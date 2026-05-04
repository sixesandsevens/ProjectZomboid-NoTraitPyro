NoTraitPyro
===========

A Project Zomboid mod that lets the player set fire to paper-like items from the world context menu.

This is meant as a small, expandable utility mod: the flammability rules are intentionally easy to tweak.

Installation
------------
Install this folder into your Project Zomboid "mods" directory so the mod root contains:
- mod.info
- readme.txt
- media/
- common/ (optional)
- 42/ (optional B42 compatibility files)

Usage
-----
1. Open the context menu on a world object.
2. Choose "NoTraitPyro Set Fire".
3. Pick an igniter and a flammable item from your inventory.

Compatibility
-------------
- Includes compatibility for Build 42 timed action initialization.
- Uses a flexible flammability filter rather than hard-coding only books.

Flammable items
---------------
The mod currently considers the following items flammable:
- Category: Literature
- Exact known item: Base.Money
- Name heuristics: IDs, cards, paper, notes, photos, maps

Notes
-----
- Expand the flammability rules by updating `NoTraitPyro.isFlammable()`.
- The timed action class is initialized using `ISBaseTimedAction.new(...)` for B42 safety.
