# University Monopoly
**University Monopoly** is a board game similar to Monopoly, designed for the academic community. Players move across the board, buy university buildings, collect tuition fees, and manage their credits. This project models the game using SQLite, implementing core game mechanics through a relational database.  

## Features  
- **Dice Rolling System** – Moves players across the board based on dice rolls.  
- **Building Ownership & Transactions** – Players can buy university buildings and collect tuition fees.  
- **Credit System** – Players earn and lose credits based on game rules.  
- **Audit Trail** – Tracks each turn with player actions and credit balances.  
- **Game Rules Implemented** – Includes special conditions like suspension, RAG spaces, and Welcome Week bonuses.  

## Rules of the game
- Players roll a 6-sided die and move accordingly.
- Landing on an unowned building requires purchasing it.
- Landing on an owned building forces the player to pay tuition fees.
- If a player owns all the buildings in a category, the tuition fee for those buildings is doubled when other players land on them.
- Rolling a 6 grants an additional turn immediately after, while nullifying the current turn’s effect (i.e., the player skips the action for that turn).
- Special spaces (RAG, Hearings) trigger unique events.
- Players can be suspended and need to roll a 6 to resume playing.

## Database Structure  

The database consists of the following key tables:

1. **Players** – Stores information about each player, including their unique ID, chosen unique token, credit balance, current location, suspension status, and the last dice roll.  
2. **Locations** – Defines the 20 spaces on the board, categorized as either Buildings or Special locations.  
3. **Tokens** – Contains the 6 possible tokens that players can choose from.  
4. **Specials** – Describes special locations with unique rules, each having a location ID and a description.  
5. **Buildings** – Represents university buildings that players can purchase, storing location ID, tuition fee, owner, and whether the owner has both the buildings of the same color.  
6. **Audit Trail** – Tracks gameplay actions by storing player ID, the location they landed on, their current credit balance, and the game round number.

These tables model the core mechanics of the game, including player actions, building ownership, and the flow of credits throughout the game.

## Install environment

This project requires **SQLite3** to run.  
Check if you already have it installed by running:

```sh
sqlite3 --version
```
If not installed, follow these instructions:<br>
Linux (Ubuntu/Debian)
```sh
sudo apt update && sudo apt install -y sqlite3
```
Mac (Homebrew)
```sh
brew install sqlite3
```
Windows (Chocolatey)
```sh
choco install sqlite
```
## Setup the Database
Run the setup script to create the database and necessary tables:
```
./scripts/setup.sh
```
If university_monopoly.db does not already exist, this script will generate it.
The SQL files for creating tables, populating data, and defining views and triggers are located in the database/ folder. <br>
Run this to grant permission:
```
chmod +x scripts/setup.sh 
```

## Run the Game Simulation
Add a new player:
```
./scripts/add_player.sh "PlayerName" "TokenName"
```
Roll the dice for a player:
```
./scripts/roll_die.sh "PlayerID" "DieRoll"
```
Reset the game (delete all player and audit data):
```
./scripts/reset_game
```
