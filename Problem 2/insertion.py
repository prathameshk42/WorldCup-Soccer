import mysql.connector
import csv


# Replace with your MySQL connection details
db_config = {
    "host": "acadmysqldb001p.uta.edu",
    "user": "phk7955",
    "password": "TexsLAZ7Vsn@",
    "database": "phk7955"
}

# Establish a connection to the MySQL database
connection = mysql.connector.connect(**db_config)
cursor = connection.cursor()
print("Connected to the database.")



def load_data_from_csv(file_path, table_name):
    with open(file_path, "rb") as csv_file:  # Use "rb" for binary mode
        csv_reader = csv.reader(csv_file)
        csv_reader.next()  # Skip the header row if it exists

        for row in csv_reader:
            # Adjust the column order based on your CSV file
            # Ensure the number of columns matches the table's structure
            placeholders = ', '.join(['%s'] * len(row))
            query = "INSERT INTO IGNORE {} VALUES ({})".format(table_name, placeholders)
            cursor.execute(query, tuple(row))

    connection.commit()

# Load data into the WorldCups table from "worldcups.csv" CSV file
load_data_from_csv("/home/phk7955/WorldCups.csv", "worldcups")

# Load data into the WorldCupMatches table from "worldcupmatches.csv" CSV file
load_data_from_csv("/home/phk7955/WorldCupMatches.csv", "worldcupmatches")

# Load data into the WorldCupPlayers table from "worldcupplayers.csv" CSV file
load_data_from_csv("/home/phk7955/WorldCupPlayers.csv", "worldcupplayers")

# Close the database connection
cursor.close()
connection.close()
