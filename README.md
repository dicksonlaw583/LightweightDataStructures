# Lightweight Data Structures v1.1.0

## Overview

This library implements struct-based, GC-friendly equivalents of GameMaker Studio's built-in data structures. It also adds the ability to save even nested structures without manual marking, in plaintext and RC4 ciphertext.

## Requirements

- GameMaker Studio 2.3.2 or higher

For GameMaker Studio 2.3.0 or 2.3.1, you can only use v1.0.x versions of this library, which would also require [JSON Struct](https://github.com/dicksonlaw583/JsonStruct) v1.0.0 or higher.

## Installation

Get the current asset package and associated documentation from [the releases page](https://github.com/dicksonlaw583/LightweightDataStructures/releases). Once you download the package, simply extract everything to your project, including the extension and the companion scripts.

Alternatively, you can also download a ready-to-go version from [the YoYo Marketplace](https://marketplace.yoyogames.com/assets/9442/lightweight-data-structures). Extract everything as usual.

## Example

### Simple List Example
```
var list = new List(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
list.shuffle();
show_message("Your draws are: " + string(list.get(0)) + "," + string(list.get(1)) + "," + string(list.get(2)));
```

### Simple Nested Map Example
```
var characters = new List(
	new Map("name", "Alice", "hp", 4),
	new Map("name", "Bob", "hp", 5),
	new Map("name", "Caitlyn", "hp", 6)
);
lds_save_encrypted(characters, working_directory + "characters.dat", "secretChars");
```
```
var loadedCharacters = lds_load_encrypted(working_directory + "characters.dat", "secretChars");
show_message(
	"Stats:" +
	"\n- Alice: " + string(loadedCharacters.get(0).get("hp")) +
	"\n- Bob: " + string(loadedCharacters.get(1).get("hp")) +
	"\n- Caitlyn: " + string(loadedCharacters.get(2).get("hp"))
);
```

## Contributing to Lightweight Data Structures

- Clone this repository.
- Open the project in GameMaker Studio 2.3 and make your additions/changes to the `LightweightDataStructures` extension and/or group. Also add the corresponding tests to the `LightweightDataStructures_test` group.
- Open a pull request here.

