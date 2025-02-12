# Check if both parameters (player name & token) are provided
if [ "$#" -ne 2 ]; then
    echo "Error: Missing arguments!"
    exit 1
fi

# Run SQLite command and check for errors

PLAYER_NAME=$1
TOKEN_NAME=$2

sqlite3 university_tycoon.db <<EOF
INSERT INTO Players (ID, Name, Token)
VALUES (
    (SELECT COALESCE(MAX(id), 0) + 1 FROM Players),
    '$PLAYER_NAME',
    '$TOKEN_NAME'
);
EOF

# Check if SQLite returned an error
if [ $? -ne 0 ]; then
    exit 2
fi

echo "Player '$PLAYER_NAME' with token '$TOKEN_NAME' added successfully!"
exit 0 