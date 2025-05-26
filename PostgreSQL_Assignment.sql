CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    region VARCHAR(50)
);

CREATE TABLE species (
  species_id SERIAL PRIMARY KEY,
  common_name VARCHAR(100),
  scientific_name VARCHAR(150),
  discovery_date DATE,
  conservation_status VARCHAR(50)
);

CREATE TABLE sightings (
  sighting_id SERIAL PRIMARY KEY,
  species_id INT REFERENCES species(species_id),
  ranger_id INT REFERENCES rangers(ranger_id),
  location VARCHAR(100),
  sighting_time TIMESTAMP,
  notes TEXT
);


INSERT INTO rangers (name, region) VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range');

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');



INSERT INTO sightings (species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


-- Problem 1

INSERT INTO rangers (name, region) VALUES
('Derek Fox', 'Coastal Plains')

-- Problem 2

SELECT count(DISTINCT species_id)FROM sightings as unique_species_count;

-- Problem 3

SELECT * FROM sightings
WHERE location LIKE '%Pass%';

-- Problem 4

SELECT  r.name,COUNT(*) as total_sightings  FROM sightings as s
JOIN rangers as r
ON r.ranger_id = s.ranger_id
GROUP BY r.name

-- Problem 5

SELECT sp.common_name FROM sightings as s 
JOIN species as sp
ON s.sighting_id=sp.species_id
WHERE s.species_id <> sp.species_id
GROUP BY sp.common_name

-- Problem 6

SELECT s.sighting_time,sp.common_name,r.name FROM sightings as s
JOIN species as sp ON sp.species_id=s.sighting_id
JOIN rangers as r ON r.ranger_id=s.sighting_id
ORDER BY sighting_time DESC
LIMIT 2

-- Problem 7
UPDATE species SET conservation_status='Historic' WHERE discovery_date<'1800-01-1'

-- Problem 8
SELECT sighting_id,
    CASE 
        WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 16 THEN 'Afternoon' 
        WHEN EXTRACT(HOUR FROM sighting_time) = 17 AND EXTRACT(MINUTE FROM sighting_time) = 0 THEN 'Afternoon'
        ELSE 'Evening' 
    END AS time_of_day
FROM
    sightings;

-- Problem 9

DELETE FROM rangers r WHERE NOT EXISTS (SELECT 1 FROM sightings s WHERE s.ranger_id = r.ranger_id);
