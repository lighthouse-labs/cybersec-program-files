#!/bin/bash

# MySQL root user information
ROOT_DB_USER="root"         # Change this to your MySQL root username
ROOT_DB_PASS="Test123" # Change this to your MySQL root password

# MySQL test user information
TEST_USER="prtg_test_user"     # Change this to the desired username for your test user
TEST_USER_PASS="test_password" # Change this to the desired password for your test user

# MySQL database information
DB_HOST="localhost"        # Change this to your MySQL host
DB_USER="student"  # Change this to your MySQL username
DB_PASS="Lighthouse123@"  # Change this to your MySQL password

# Test database information
TEST_DB_NAME="prtg_test_db"   # Change this to the desired name for your test database

# MySQL commands to create the test database and user
CREATE_USER_SQL="CREATE USER IF NOT EXISTS '$TEST_USER'@'localhost' IDENTIFIED WITH mysql_native_password BY '$TEST_USER_PASS';"
GRANT_PRIVILEGES_SQL="GRANT ALL PRIVILEGES ON $TEST_DB_NAME.* TO '$TEST_USER'@'localhost';"
FLUSH_PRIVILEGES_SQL="FLUSH PRIVILEGES;"
CREATE_DB_SQL="CREATE DATABASE IF NOT EXISTS $TEST_DB_NAME;"
CREATE_TABLE_SQL="CREATE TABLE IF NOT EXISTS $TEST_DB_NAME.sensor_data (id INT AUTO_INCREMENT PRIMARY KEY, value FLOAT NOT NULL, timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP);"

# Execute the SQL commands
mysql -h $DB_HOST -u $ROOT_DB_USER -p$ROOT_DB_PASS -e "$CREATE_USER_SQL"
mysql -h $DB_HOST -u $ROOT_DB_USER -p$ROOT_DB_PASS -e "$GRANT_PRIVILEGES_SQL"
mysql -h $DB_HOST -u $ROOT_DB_USER -p$ROOT_DB_PASS -e "$FLUSH_PRIVILEGES_SQL"
mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -e "$CREATE_DB_SQL"
mysql -h $DB_HOST -u $DB_USER -p$DB_PASS -e "$CREATE_TABLE_SQL"

# Verify if the database and user were created successfully
if [ $? -eq 0 ]; then
  echo "Test user '$TEST_USER' with password '$TEST_USER_PASS' created successfully."
  echo "Test database '$TEST_DB_NAME' and table 'sensor_data' created successfully."
else
  echo "Failed to create the test user or database. Please check your MySQL root credentials and try again."
fi