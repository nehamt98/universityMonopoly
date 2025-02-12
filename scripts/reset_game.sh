#  Reset the players, audit_trail and buildings tables
sqlite3 university_tycoon.db <<EOF

DELETE FROM Players;
DELETE FROM Audit_Trails;

UPDATE Buildings
SET Owner = NULL, IsSameOwner = 0;
EOF

# Check if SQLite returned an error
if [ $? -ne 0 ]; then
    exit 2
fi

echo "Game reset successfully!"
exit 0 