# Check if both arguments (player_id & die_roll) are provided
if [ "$#" -ne 2 ]; then
    echo "Error: Missing arguments!"
    exit 1
fi

PLAYER_ID=$1
DIE_ROLL=$2

# Run SQLite command and capture errors
sqlite3 university_tycoon.db <<EOF
UPDATE Players
SET DieRoll = '$DIE_ROLL'
WHERE ID = '$PLAYER_ID';
EOF

# Check if SQLite returned an error
if [ $? -ne 0 ]; then
    exit 2
fi

echo "Player '$PLAYER_ID' has rolled a '$DIE_ROLL'!"
exit 0  