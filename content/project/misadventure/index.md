---

title: misadventure
summary: A 2D survival shooter set in a fantastic forest made with the Unity Engine.
tags:
date: "2021-04-01T00:00:00Z"

image:
  caption:
  focal_point: Smart

links:
- icon: github
  icon_pack: fab
  name: Github
  url: https://github.com/EuleMitKeule/misadventure
- icon: itch-io
  icon_pack: fab
  name: itch.io
  url: https://eulemitkeule.itch.io/misadventure
- icon: gamepad
  icon_pack: fas
  name: Play
  url: https://misadventure.eulenet.eu

---

# Misadventure

You are the hero of the forest.<br>
Explore different areas and find secrets, but most importantly survive!

### Controls

| Action        | Control       |
| ------------- |:-------------:|
| Move          | WASD          |
| Aim           | Mouse         |
| Shoot         | Mouse Left    |
| Change Weapon | Mouse Wheel   |
| Pickup Weapon | E             |

## Project

Misadventure is an open-source game written in C# and made with the Unity Engine.<br>
It was developed as a study project at the [Ruhr-Universität Bochum](https://ruhr-uni-bochum.de)
by myself, [Ben Korinth](https://github.com/mifiamigahna) and [Gerrit Fresen](https://github.com/GerritF).<br>
It took about six months for the project to be completed.

The game is inspired by the amazing games [Hotline Miami](https://store.steampowered.com/app/219150/Hotline_Miami) and [Super Amazing Wagon Adventure](https://store.steampowered.com/app/250500/Super_Amazing_Wagon_Adventure).

## Development

We orientated the architecture along Unity's component system.<br>
We started by implementing the basic components used by the player and all hostile entities that manage health and selected weapons.<br>

The next step was to add behaviour to enemies. This was done by implementing the A* algorithm for pathfinding and building a finite state machine containing AI logic. To keep the code clean I developed an [encapsulated implementation of the state pattern](https://github.com/EuleMitKeule/better-fsm).

After that the weapons and items system was implemented. The main goal hereby was to ensure that creating new weapons and items was as easy and generalized as possible. All items and weapons are defined and configured using Unity's scriptable object data containers which are then processed by a unified weapon and item component. Differences in attack delays for the different weapons are handled by adding animation events to the weapons generalized animation clips, for instance in order to define when exactly a projectile should be spawned.<br>

Another noteworthy accomplishment was the development of editor tools using the paid asset [Odin Inspector](https://odininspector.com). This allowed us to create
a unified control panel where variables of items, weapons and levels could be adjusted. Having all of this in one place helped with balancing and validating the game's resources.

## Graphics

We used a topdown pixel-artstyle that mimics the optic of Hotline Miami.
Most of the sprites and spritesheets were created using the [Aseprite](https://aseprite.org) editor.<br>
Levels were built using the 2d-tilemap and 2d-tilemap-extras packages provided by Unity.