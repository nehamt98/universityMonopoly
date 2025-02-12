DB_NAME="university_monopoly.db"

echo "Checking for SQLite3..."
if ! command -v sqlite3 &> /dev/null; then
    echo "SQLite3 is not installed! Please install it and try again."
    exit 1
fi
echo "SQLite3 is installed!"

# Check if database exists, if not, create it
if [ ! -f "$DB_NAME" ]; then
    echo "Creating database: $DB_NAME..."
    sqlite3 $DB_NAME < database/create_tables.sql
    sqlite3 $DB_NAME < database/populate.sql
    sqlite3 $DB_NAME < database/triggers.sql
    sqlite3 $DB_NAME < database/view.sql
    echo "Database initialized!"
else
    echo "Database already exists. Skipping creation."
fi

echo "Setup complete! You can now run game scripts."
exit 0