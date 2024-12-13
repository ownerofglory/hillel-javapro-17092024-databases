import json

# Load JSON data
with open('embedding.json', 'r') as file:
    data = json.load(file)

# Open an output file for SQL insert statements
with open('insert_embeddings.sql', 'w') as output:
    for entry in data:
        text = entry['text'].replace("'", "''")  # Escape single quotes
        embedding = entry['embedding']

        # Convert embedding to SQL-friendly format
        embedding_str = f"ARRAY{embedding}::vector"

        # Create the INSERT statement (excluding the id column)
        sql = f"INSERT INTO demo_embeddings (text, embedding) VALUES ('{text}', {embedding_str});\n"

        # Write to the output file
        output.write(sql)

print("SQL insert statements generated in 'insert_embeddings.sql'")
