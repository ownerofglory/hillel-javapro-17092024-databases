import json

# Load GeoJSON data
geojson_file = '../data/Stuttgart.json'  # Replace with your GeoJSON file name
output_sql_file = '../sql/insert_data.sql'

# Define the table name and schema
table_name = "places"

# Initialize an empty list to store SQL statements
sql_statements = []

# Open and read the GeoJSON file
with open(geojson_file, 'r') as file:
    data = json.load(file)

# Process each feature in the GeoJSON
for feature in data['features']:
    properties = feature['properties']
    geometry = feature['geometry']

    # Filter for amenities 'restaurant' and 'cafe'
    other_tags = properties.get('other_tags', '')
    if '"amenity"=>"restaurant"' in other_tags or '"amenity"=>"cafe"' in other_tags:
        # Extract required fields
        osm_id = properties.get('osm_id')
        name = properties.get('name', 'NULL').replace("'", "''")  # Escape single quotes
        amenity_type = 'restaurant' if '"amenity"=>"restaurant"' in other_tags else 'cafe'
        lon, lat = geometry['coordinates']

        # Create the SQL INSERT statement
        sql = f"INSERT INTO {table_name} (id, name, type, geometry) VALUES " \
              f"({osm_id}, '{name}', '{amenity_type}', ST_SetSRID(ST_MakePoint({lon}, {lat}), 4326));"

        # Append the statement to the list
        sql_statements.append(sql)

# Write all SQL statements to a file
with open(output_sql_file, 'w') as output_file:
    output_file.write('\n'.join(sql_statements))

print(f"SQL insert statements written to {output_sql_file}")
