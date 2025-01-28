-- View: Top 10 Pilotos de Todas as Temporadas

CREATE OR REPLACE VIEW top_10_pilotos AS
SELECT 
    d.forename || ' ' || d.surname AS driver_name,
    SUM(ds.points) AS total_points,
    COUNT(ds.wins) AS total_wins
FROM driver_standings ds
JOIN drivers d ON ds.driverId = d.driverId
GROUP BY d.driverId, driver_name
ORDER BY total_points DESC
LIMIT 10;

-- View: Histórico de Corridas por Circuito

CREATE OR REPLACE VIEW circuito_historico AS
SELECT 
    c.name AS circuit_name,
    c.country,
    COUNT(r.raceId) AS total_races
FROM races r
JOIN circuits c ON r.circuitId = c.circuitId
GROUP BY c.circuitId, c.name, c.country
ORDER BY total_races DESC;

-- View: Desempenho por Construtor

CREATE OR REPLACE VIEW construtor_performance AS
SELECT 
    c.name AS constructor_name,
    SUM(cs.points) AS total_points,
    SUM(cs.wins) AS total_wins,
    COUNT(CASE WHEN cs.position <= 3 THEN 1 END) AS total_podiums
FROM constructor_standings cs
JOIN constructors c ON cs.constructorId = c.constructorId
GROUP BY c.constructorId, c.name
ORDER BY total_points DESC;