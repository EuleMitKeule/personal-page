---
title: streetview-bingo
summary: Web application assisting with playing games of Streetview Bingo.
tags:
date: "2021-03-06T00:00:00Z"

image:
  caption:
  focal_point: Smart

links:
- icon: web
  icon_pack: fas
  name: Play
  url: https://bingo.blobnet.de
- icon: github
  icon_pack: fab
  name: Github
  url: https://github.com/EuleMitKeule/streetview-bingo
---

Streetview Bingo is a web application that can assist with remotely playing the Google Streetview bingo game.<br>

Google Streetview bingo works by choosing a list of terms that might be found in Google's Streetview service.<br>
The players then need to search for each term in Google Streetview without typing anything in the search bar.<br>
When a player finds something, a designated game moderator will then take a look at the player's finding
and decide whether the finding satisfies the term.
This usually happens with sharing one's screen over something like Discord.

The streetview-bingo application's purpose is to assist with taking notes about the chosen terms and the current state of the game.<br>
After a lobby is created and players are invited, the lobby owner can designate the next games moderator. When the game is initiated,
the moderator can choose the game's terms and after starting the game can then check or uncheck each term for the individual players.

The application is open-source and consists of a python flask REST-API backend and a frontend made with Angular by my friend [Niklas Held](https://github.com/niklasheld).<br>
It can be self-hosted by deploying the shipped docker image or accessed via its official [website](https://bingo.blobnet.de/).

