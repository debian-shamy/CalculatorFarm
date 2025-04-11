# CalculatorFarm

Addon for calculating farming materials required for TBC 2.4.3 consumables (Flasks, Elixirs, Potions, Food, Oils, etc.) with database support.

## Features

- **Chat Commands**:    Calculate materials via simple slash commands
- **Multi-Item Lists**: Create and manage custom farming lists
- **Account-Wide**:     Shares lists across all characters on your account
- **Persistent Lists**: All farming lists are saved to your account-wide SavedVariables
- **No UI Dependency**: Works entirely through chat commands

## Appendix

Developed for private servers running World of Warcraft - The Burning Crusade 2.4.3, with special attention to:
- Classic farming routes
- TBC material requirements
- Guild bank organization

## Authors & Credits
- [@Debian](https://github.com/debian-shamy) - Ideator and Lead Tester
- [DeepSeek Chat](https://deepseek.com) - Lua scripting and database architecture

## Installation

1. Download the latest version from [Releases](https://github.com/debian-shamy/CalculatorFarm.git).
2. Unzip `CalculatorFarm-main.zip`.
3. Rename the extracted folder from `CalculatorFarm-main` to `CalculatorFarm`.
4. Place it in: `WoW/classic/Interface/AddOns/`
5. Launch the game and type `/calcfarm` to verify it's working.

## Usage

![CalculatorFarm Commands](print_tbc.png)  

```lua
/calcfarm or /cfarm  - Main command
/new <listname>      - Create a farming list
/add <list> <itemID> [qty] - Add items to list
/mats <list>         - Calculate total materials
/reset               - Clear all lists
```

Example:

* /cfarm new bt_prep
* /cfarm add bt_prep FLASKATKPOWER 5
* /cfarm add bt_prep POTIONHASTE 10
* /cfarm mats bt_prep

## License

GNU General Public License v3.0

CalculatorFarm is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation

## References

- [WoW API Documentation](https://warcraft.wiki.gg/wiki/World_of_Warcraft_API)
- [Programming in Lua (Official Book)](https://www.amazon.com.br/Programando-em-Lua-Roberto-Ierusalimschy/dp/8521626991)
- [TBC 2.4.3 Consumables Guide](https://www.wowhead.com/tbc/items/consumables)
