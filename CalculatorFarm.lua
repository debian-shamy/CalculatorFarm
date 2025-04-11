-- CalculatorFarm - Addon for managing and calculating farming materials for consumables in WoW TBC 2.4.3.
--
-- Authors & Credits: Debian (Shaman) (Code optimization by DeepSeek Chat AI)
--
-- Description:
-- This addon provides a simple chat-based interface for players to manage custom farming lists.
-- It supports consumables such as flasks, potions, food, and oils, and calculates the total reagents
-- required based on user-defined lists.
--
-- Features:
-- - Organize and save multiple farming lists
-- - Add or remove recipes by category
-- - Calculate total reagents needed for a list
-- - View individual list contents
-- - Slash command driven interface (/calcfarm)
--
-- This addon is built for use with the TBC 2.4.3 client and does not use a graphical interface.

CalculatorFarmDB = {}
local CalculatorFarm = {
-- Database structure:
-- Key: Category (e.g., "Flask", "Elixir")
-- Value: Table of recipes, where each recipe has:
--   - name: Display name
--   - description: Short effect description
--   - reagents: Table of { [reagent_name] = quantity }

    database = {
        -- Flask Database
        ["Flask"] = {
            ["FLASKDEF"] = {
                name = "Flask of Fortification",
                description = "(500 hp 10 def)",
                reagents = {
                    ["Fel Lotus"] = 1,
                    ["Mana Thistle"] = 3,
                    ["Ancient Lichen"] = 7,
                    ["Imbued Vial"] = 1,
                },
            },
            ["FLASKRESI"] = {
                name = "Flask of Chromatic Wonder",
                description = "(35 all resi 18 all stats)",
                reagents = {
                    ["Fel Lotus"] = 1,
                    ["Netherbloom"] = 3,
                    ["Dreaming Glory"] = 7,
                    ["Imbued Vial"] = 1,
                },
            },
            ["FLASKMP5"] = {
                name = "Flask of Mighty Restoration",
                description = "(25 mp5)",
                reagents = {
                    ["Fel Lotus"] = 1,
                    ["Mana Thistle"] = 3,
                    ["Dreaming Glory"] = 7,
                    ["Imbued Vial"] = 1,
                },
            },
            ["FLASKINT"] = {
                name = "Flask of Distilled Wisdom",
                description = "(65 int)",
                reagents = {
                    ["Black Lotus"] = 1,
                    ["Icecap"] = 3,
                    ["Dreamfoil"] = 7,
                    ["Crystal Vial"] = 1,
                },
            },
            ["FLASKATKPOWER"] = {
                name = "Flask of Relentless Assault",
                description = "(120 atk power)",
                reagents = {
                    ["Fel Lotus"] = 1,
                    ["Mana Thistle"] = 3,
                    ["Terocone"] = 7,
                    ["Imbued Vial"] = 1,
                },
            },
            ["FLASKHOLY"] = {
                name = "Flask of Blinding Light",
                description = "(80 arcane holy nature dmg)",
                reagents = {
                    ["Fel Lotus"] = 1,
                    ["Mana Thistle"] = 3,
                    ["Netherbloom"] = 7,
                    ["Imbued Vial"] = 1,
                },
            },
            ["FLASKSHADOWANDFIRE"] = {
                name = "Flask of Pure Death",
                description = "(80 shadow fire frost dmg)",
                reagents = {
                    ["Fel Lotus"] = 1,
                    ["Mana Thistle"] = 3,
                    ["Nightmare Vine"] = 7,
                    ["Imbued Vial"] = 1,
                },
            },
            ["FLASKSPELLDMG"] = {
                name = "Flask of Supreme Power",
                description = "(70 spell dmg)",
                reagents = {
                    ["Black Lotus"] = 1,
                    ["Mountain Silversage"] = 3,
                    ["Dreamfoil"] = 7,
                    ["Crystal Vial"] = 1,
                },
            },
        },
        -- Elixirs Database
        ["Elixir"] = {
            ["ELIXIRARMOR"] = {
                name = "Elixir of Major Defense",
                description = "(550 armor)",
                reagents = {
                    ["Ancient Lichen"] = 3,
                    ["Terocone"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
            ["ELIXIRHP"] = {
                name = "Elixir of Major Fortitude",
                description = "(250 hp 10 hp5)",
                reagents = {
                    ["Ragveil"] = 2,
                    ["Felweed"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
            ["ELIXIRALLSTATS"] = {
                name = "Elixir of Mastery",
                description = "(15 all stats)",
                reagents = {
                    ["Terocone"] = 3,
                    ["Felweed"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
            ["ELIXIRRESI"] = {
                name = "Elixir of Ironskin",
                description = "(30 resi)",
                reagents = {
                    ["Ancient Lichen"] = 1,
                    ["Ragveil"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
            ["ELIXIRHEAL"] = {
                name = "Elixir of Healing Power",
                description = "(50 healing)",
                reagents = {
                    ["Golden Sansam"] = 1,
                    ["Dreaming Glory"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
            ["ELIXIRMP5"] = {
                name = "Elixir of Major Mageblood",
                description = "(16 mp5)",
                reagents = {
                    ["Ancient Lichen"] = 1,
                    ["Netherbloom"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
            ["ELIXIRINT"] = {
                name = "Elixir of Draenic Wisdom",
                description = "(30 int 30 spirit)",
                reagents = {
                    ["Felweed"] = 1,
                    ["Terocone"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
            ["ELIXIRAGY"] = {
                name = "Elixir of Major Agility",
                description = "(35 agi 20 crit)",
                reagents = {
                    ["Terocone"] = 1,
                    ["Felweed"] = 2,
                    ["Imbued Vial"] = 1,
                },
            },
            ["ELIXIRSTG"] = {
                name = "Elixir of Major Strength",
                description = "(35 stg)",
                reagents = {
                    ["Mountain Silversage"] = 1,
                    ["Felweed"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
            ["ELIXIRATKPOWER"] = {
                name = "Fel Strength Elixir",
                description = "(90 atk power -10 stm)",
                reagents = {
                    ["Terocone"] = 1,
                    ["Nightmare Vine"] = 2,
                    ["Imbued Vial"] = 1,
                },
            },
            ["ELIXIRATKPOWERDEMON"] = {
                name = "Elixir of Demonslaying",
                description = "(265 atk power vs demons)",
                reagents = {
                    ["Gromsblood"] = 1,
                    ["Ghost Mushroom"] = 1,
                    ["Crystal Vial"] = 1,
                },
            },
            ["ELIXIRSPELLDMG"] = {
                name = "Adept's Elixir",
                description = "(24 spell dmg 24 spell crit)",
                reagents = {
                    ["Dreamfoil"] = 1,
                    ["Felweed"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
            ["ELIXIRFIREDMG"] = {
                name = "Elixir of Major Firepower",
                description = "(55 fire dmg)",
                reagents = {
                    ["Mote of Fire"] = 2,
                    ["Ancient Lichen"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
            ["ELIXIRFROSTDMG"] = {
                name = "Elixir of Major Frost Power",
                description = "(55 frost dmg)",
                reagents = {
                    ["Mote of Water"] = 2,
                    ["Ancient Lichen"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
            ["ELIXIRSHADOWDMG"] = {
                name = "Elixir of Major Shadow Power",
                description = "(55 shadow dmg)",
                reagents = {
                    ["Ancient Lichen"] = 1,
                    ["Nightmare Vine"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
        },
        -- Potion Database
        ["Potion"] = {
            ["POTIONARMOR"] = {
                name = "Ironshield Potion",
                description = "(2500 armor 2min)",
                reagents = {
                    ["Ancient Lichen"] = 2,
                    ["Mote of Earth"] = 3,
                    ["Imbued Vial"] = 1,
                },
            },
            ["POTIONHASTE"] = {
                name = "Haste Potion",
                description = "(400 haste rating for 15 sec)",
                reagents = {
                    ["Terocone"] = 2,
                    ["Netherbloom"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
            ["POTIONINSANESTG"] = {
                name = "Insane Strength Potion",
                description = "(120 stg -75 def 15 sec)",
                reagents = {
                    ["Terocone"] = 3,
                    ["Imbued Vial"] = 1,
                },
            },
            ["POTIONSTG"] = {
                name = "Heroic Potion",
                description = "(70 stg 700 hp for 15 sec)",
                reagents = {
                    ["Terocone"] = 2,
                    ["Ancient Lichen"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
            ["POTIONCRIT"] = {
                name = "Destruction Potion",
                description = "(120 spell dmg 2% crit rating for 15 sec)",
                reagents = {
                    ["Nightmare Vine"] = 2,
                    ["Netherbloom"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
            ["POTIONMANA"] = {
                name = "Super Mana Potion",
                description = "(1800 to 3000 mana)",
                reagents = {
                    ["Dreaming Glory"] = 2,
                    ["Felweed"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
            ["POTIONHEALTH"] = {
                name = "Super Healing Potion",
                description = "(1500 to 2500 hp)",
                reagents = {
                    ["Netherbloom"] = 2,
                    ["Felweed"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
        },
        -- Food Database
        ["Food"] = {
            ["FOODSTM"] = {
                name = "Fisherman's Feast",
                description = "(30 stm 20 spi)",
                reagents = {
                    ["Huge Spotted Feltail"] = 1,
                    ["Goldenbark Apple"] = 5,
                    ["Soothing Spices"] = 5,
                },
            },
            ["FOODSTMFISH"] = {
                name = "Spicy Crawdad",
                description = "(30 stm 20 spi)",
                reagents = {
                    ["Furious Crawdad"] = 1,
                },
            },
            ["FOODHEAL"] = {
                name = "Golden Fish Sticks",
                description = "(44 healing 20 spi)",
                reagents = {
                    ["Golden Darter"] = 1,
                },
            },
            ["FOODMP5"] = {
                name = "Blackened Sporefish",
                description = "(8 mp5 20 stm)",
                reagents = {
                    ["Zangarian Sporefish"] = 1,
                },
            },
            ["FOODSTG"] = {
                name = "Roasted Clefthoof",
                description = "(20 stg 20 spi)",
                reagents = {
                    ["Clefthoof Meat"] = 1,
                },
            },
            ["FOODSTGFISH"] = {
                name = "Smoked Desert Dumplings",
                description = "(20 stg)",
                reagents = {
                    ["Sandworm Meat"] = 1,
                    ["Soothing Spices"] = 1,
                },
            },
            ["FOODATKPOWER"] = {
                name = "Ravager Dog",
                description = "(40 atk power 20 spi)",
                reagents = {
                    ["Ravager Flesh"] = 1,
                },
            },
            ["FOODAGYFISH"] = {
                name = "Grilled Mudfish",
                description = "(20 agi 20 spi)",
                reagents = {
                    ["Figluster's Mudfish"] = 1,
                },
            },
            ["FOODAGY"] = {
                name = "Warp Burger",
                description = "(20 agi 20 spi)",
                reagents = {
                    ["Warped Flesh"] = 1,
                },
            },
            ["FOODHIT"] = {
                name = "Spicy Hot Talbuk",
                description = "(20 hit rating 20 spi)",
                reagents = {
                    ["Talbuk Venison"] = 1,
                    ["Hot Spices"] = 1,
                },
            },
            ["FOODSPELLDMG"] = {
                name = "Blackened Basilisk",
                description = "(23 spell dmg 20 spi)",
                reagents = {
                    ["Chunk o' Basilisk"] = 1,
                },
            },
            ["FOODSPELLDMGFISH"] = {
                name = "Poached Bluefish",
                description = "(23 spell dmg 20 spi)",
                reagents = {
                    ["Icefin Bluefish"] = 1,
                },
            },
            ["FOODSPELLDMGMEAT"] = {
                name = "Crunchy Serpent",
                description = "(23 spell dmg 20 spi)",
                reagents = {
                    ["Serpent Flesh"] = 1,
                },
            },
            ["FOODCRIT"] = {
                name = "Skullfish Soup",
                description = "(20 spell crit 20 spi)",
                reagents = {
                    ["Crescent-Tail Skullfish"] = 1,
                },
            },
            ["FOODRESI"] = {
                name = "Broiled Bloodfin",
                description = "(8 all resi)",
                reagents = {
                    ["Bloodfin Catfish"] = 1,
                },
            },
            ["FOODSTGPET"] = {
                name = "Kibler's Bits",
                description = "(20 stg 20 spi) [pet]",
                reagents = {
                    ["Buzzard Meat"] = 1,
                },
            },
            ["FOODSTMPET"] = {
                name = "Sporeling Snack",
                description = "(20 stm 20 spi) [pet]",
                reagents = {
                    ["Strange Spores"] = 1,
                },
            },
        },
        -- Oil Database
        ["Oil"] = {
            ["OILHEAL"] = {
                name = "Brilliant Mana Oil",
                description = "(25 healing 12mp5)",
                reagents = {
                    ["Large Brilliant Shard"] = 2,
                    ["Purple Lotus"] = 3,
                    ["Imbued Vial"] = 1,
                },
            },
            ["OILMP5"] = {
                name = "Superior Mana Oil",
                description = "(14 mp5)",
                reagents = {
                    ["Arcane Dust"] = 3,
                    ["Netherbloom"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
            ["OILCRIT"] = {
                name = "Brilliant Wizard Oil",
                description = "(36 spell dmg 14 spell crit)",
                reagents = {
                    ["Large Brilliant Shard"] = 2,
                    ["Firebloom"] = 3,
                    ["Imbued Vial"] = 1,
                },
            },
            ["OILSPELLDMG"] = {
                name = "Superior Wizard Oil",
                description = "(42 spell dmg)",
                reagents = {
                    ["Arcane Dust"] = 3,
                    ["Nightmare Vine"] = 1,
                    ["Imbued Vial"] = 1,
                },
            },
        },
        -- Herbs Database
        ["Herb"] = {
            ["SEED"] = {
                name = "Nightmare Seed",
                description = "(2000 hp 30 sec)",
                reagents = {
                    ["Nightmare Seed"] = 1,
                },
            },
            ["FIRECAP"] = {
                name = "Flame Cap",
                description = "(80 fire spell dmg 40 fire dmg/hit)",
                reagents = {
                    ["Flame Cap"] = 1,
                },
            },
        },
        -- Stones Database
        ["Stones"] = {
            ["STONESHIELD"] = {
                name = "Greater Ward of Shielding",
                description = "(absorbs 4000 dmg)",
                reagents = {
                    ["Eternium Bar"] = 1,
                },
            },
            ["STONECHEST"] = {
                name = "Greater Rune of Warding",
                description = "(25% absorbs 400 dmg)",
                reagents = {
                    ["Khorium Bar"] = 1,
                },
            },
            ["STONESHARP"] = {
                name = "Adamantite Sharpening Stone",
                description = "(12 melee dmg 14 melee crit)",
                reagents = {
                    ["Adamantite Bar"] = 1,
                    ["Mote of Earth"] = 2,
                },
            },
            ["STONEWEIGHT"] = {
                name = "Adamantite Weightstone",
                description = "(12 melee dmg 14 melee crit)",
                reagents = {
                    ["Adamantite Bar"] = 1,
                    ["Netherweave Cloth"] = 2,
                },
            },
        },
        -- Drums Database
        ["Drums"] = {
            ["DRUMHASTE"] = {
                name = "Drums of Battle",
                description = "(80 spell haste 30 sec)",
                reagents = {
                    ["Heavy Knothide Leather"] = 6,
                    ["Thick Clefthoof Leather"] = 4,
                },
            },
            ["DRUMMANA"] = {
                name = "Drums of Restoration",
                description = "(600 hp and mana 15 sec)",
                reagents = {
                    ["Heavy Knothide Leather"] = 6,
                    ["Nether Dragonscales"] = 4,
                },
            },
            ["DRUMATKPOWERSPELLDMG"] = {
                name = "Drums of War",
                description = "(60 atk power 30 spell dmg 30 sec)",
                reagents = {
                    ["Heavy Knothide Leather"] = 3,
                    ["Fel Scales"] = 3,
                },
            },
        },
    },
    lists = {}, -- Stores user lists
}

-- Function to load data at startup
local function OnAddonLoaded(event, addonName)
    if addonName == "CalculatorFarm" then
        CalculatorFarmDB = CalculatorFarmDB or {}
        CalculatorFarmDB.lists = CalculatorFarmDB.lists or {}
        CalculatorFarm.lists = CalculatorFarmDB.lists
    end
end

-- Saves the current state of user lists to SavedVariables
local function SaveLists()
    CalculatorFarmDB.lists = CalculatorFarm.lists
end

-- Log events
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", OnAddonLoaded)

-- =============================================
-- Chat Commands (/calcfarm or /cfarm)
-- =============================================
-- Handles all slash commands (/calcfarm or /cfarm).
-- Supported commands:
--   - new <listname>: Creates a new list.
--   - add <listname> <itemID> [quantity]: Adds an item to a list.
--   - view <listname>: Displays items in a list.
--   - mats <listname>: Calculates total reagents needed.
--   - list: Shows all available recipes.
--   - lists: Lists all saved user lists.
--   - reset: Clears all saved lists.

SLASH_CALCFARM1 = "/calcfarm"
SLASH_CALCFARM2 = "/cfarm"

function SlashCmdList.CALCFARM(msg, editbox)
    -- Parse and execute slash commands
    local command, arg1, arg2, arg3 = strsplit(" ", msg, 4)
    CalculatorFarmDB = CalculatorFarmDB or {}
    CalculatorFarmDB.lists = CalculatorFarmDB.lists or {}
    CalculatorFarm.lists = CalculatorFarmDB.lists
    
    -- Command: NEW Create a new named list if it doesn't exist
    if command == "new" and arg1 then
        if not CalculatorFarmDB.lists[arg1] then
            CalculatorFarmDB.lists[arg1] = {}
            SaveLists()
            print("|cFF00FF00[CalculatorFarm] List '" .. arg1 .. "' created!|r")
        else
            print("|cFFFF0000[CalculatorFarm] List '" .. arg1 .. "' already exists.|r")
        end

    -- Command: ADD Search database for the item ID to validate input and add to the list
    elseif command == "add" and arg1 and arg2 then
        if CalculatorFarmDB.lists[arg1] then
            local itemID = arg2
            local quantity = tonumber(arg3) or 1
            local found = false

            -- Check if item exists in database
            for category, items in pairs(CalculatorFarm.database) do
                if items[itemID] then
                    found = true
                    table.insert(CalculatorFarmDB.lists[arg1], {id = itemID, quantity = quantity})
                    SaveLists()
                    print("|cFF00FF00[CalculatorFarm] Added " .. quantity .. "x " .. items[itemID].name .. " to '" .. arg1 .. "'.|r")
                    break
                end
            end

            if not found then
                print("|cFFFF0000[CalculatorFarm] Item ID '" .. itemID .. "' not found.|r")
            end
        else
            print("|cFFFF0000[CalculatorFarm] List '" .. arg1 .. "' doesn't exist. Use '/calcfarm new " .. arg1 .. "' to create it.|r")
        end

    -- Command: VIEW Display all items in the selected list with quantities
    elseif command == "view" and arg1 then
        if CalculatorFarmDB.lists[arg1] then
            print("|cFF00FF00[CalculatorFarm] Items in list '" .. arg1 .. "':|r")
            for i, entry in ipairs(CalculatorFarmDB.lists[arg1]) do
                for category, items in pairs(CalculatorFarm.database) do
                    if items[entry.id] then
                        print("  " .. entry.id .. " - " .. items[entry.id].name .. " x" .. entry.quantity)
                        break
                    end
                end
            end
        else
            print("|cFFFF0000[CalculatorFarm] List '" .. arg1 .. "' doesn't exist.|r")
        end

    -- Command: MATS Calculate and display total required reagents for a given list
    elseif command == "mats" and arg1 then
        if CalculatorFarmDB.lists[arg1] then
            local totalReagents = {}
            print("|cFF00FF00[CalculatorFarm] Materials needed for '" .. arg1 .. "':|r")

            -- Sum reagents from all items in the list
            for i, entry in ipairs(CalculatorFarmDB.lists[arg1]) do
                for category, items in pairs(CalculatorFarm.database) do
                    if items[entry.id] then
                        for reagent, count in pairs(items[entry.id].reagents) do
                            totalReagents[reagent] = (totalReagents[reagent] or 0) + (count * entry.quantity)
                        end
                        break
                    end
                end
            end

            -- Display totals
            for reagent, total in pairs(totalReagents) do
                print("  |cFFFFA500" .. reagent .. ":|r " .. total)
            end
        else
            print("|cFFFF0000[CalculatorFarm] List '" .. arg1 .. "' doesn't exist.|r")
        end

    -- Command: LIST Show all available recipes by category and sorted by name
    elseif command == "list" then
        print("|cFF00FF00[CalculatorFarm] Available recipes by category:|r")
        
        -- Define category order (customize as needed)
        local categoryOrder = {"Flask", "Elixir", "Potion", "Food", "Oil", "Herb", "Stone", "Drums"}
        
        for _, category in ipairs(categoryOrder) do
            if CalculatorFarm.database[category] and next(CalculatorFarm.database[category]) then
                print("|cFFFFA500" .. category .. "|r")
                
                -- Sort items alphabetically by name
                local sortedItems = {}
                for id, data in pairs(CalculatorFarm.database[category]) do
                    table.insert(sortedItems, {id = id, name = data.name})
                end
                table.sort(sortedItems, function(a, b) return a.name < b.name end)
                
                -- Print sorted items
                for _, item in ipairs(sortedItems) do
                    local data = CalculatorFarm.database[category][item.id]
                    print("  " .. item.id .. " - " .. data.name .. " " .. data.description)
                end
            end
        end

    -- Command: LISTS List all saved user lists and their sizes
    elseif command == "lists" then
        print("|cFF00FF00[CalculatorFarm] Available lists:|r")
        if next(CalculatorFarmDB.lists) then
            for listName, items in pairs(CalculatorFarmDB.lists) do
                local count = #items
                print(string.format("  |cFFFFA500%s|r (%d items)", listName, count))
            end
        else
            print("  No lists created yet.")
        end

    -- Command: RESET Clear all saved user lists from memory
    elseif command == "reset" then
        CalculatorFarm.lists = {}
        CalculatorFarmDB.lists = {}
        SaveLists()
        print("|cFF00FF00[CalculatorFarm] All lists have been cleared.|r")

    -- Help (invalid command)
    else
        print("|cFF00FF00[CalculatorFarm] Commands:|r")      
        print("|cFFFFA500/calcfarm new <listname>|r - Create a new list")
        print("|cFFFFA500/calcfarm add <listname> <itemID> [quantity]|r - Add items to list")
        print("|cFFFFA500/calcfarm view <listname>|r - Show list items")
        print("|cFFFFA500/calcfarm mats <listname>|r - Calculate total materials")
        print("|cFFFFA500/calcfarm list|r - List all available recipes")  
        print("|cFFFFA500/calcfarm lists|r - Show all saved lists")
        print("|cFFFFA500/calcfarm reset|r - Clear ALL lists")
        print("Example: |cFFADD8E6/cfarm add my_list FLASKFF 3|r")
    end
end

print("|cFF00FF00[CalculatorFarm] Loaded! Type /calcfarm for help.|r")
