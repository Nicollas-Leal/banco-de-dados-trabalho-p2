-- Função: Total de Pontos por Piloto

CREATE OR REPLACE FUNCTION get_driver_total_points(driver_name TEXT)
RETURNS TABLE(driver_full_name TEXT, total_points NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        d.forename || ' ' || d.surname AS driver_full_name,
        SUM(ds.points) AS total_points
    FROM drivers d
    JOIN driver_standings ds ON d.driverId = ds.driverId
    WHERE d.forename || ' ' || d.surname ILIKE '%' || driver_name || '%'
    GROUP BY d.driverId, driver_full_name
    ORDER BY total_points DESC;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_driver_total_points('Lewis');

-- Função: Histórico de Vitórias de um Piloto

CREATE OR REPLACE FUNCTION get_driver_win_history(driver_id INT)
RETURNS TABLE(
    race_name TEXT,
    circuit_name TEXT,
    race_year BIGINT, -- Altera o tipo para BIGINT para alinhar com a tabela
    driver_name TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.name AS race_name,
        c.name AS circuit_name,
        r.year AS race_year, -- Mantém o tipo BIGINT
        d.forename || ' ' || d.surname AS driver_name
    FROM results res
    JOIN races r ON res.raceId = r.raceId
    JOIN circuits c ON r.circuitId = c.circuitId
    JOIN drivers d ON res.driverId = d.driverId
    WHERE res.driverId = driver_id
      AND res.position::INTEGER = 1 -- Conversão explícita para INTEGER
    ORDER BY r.year, r.name;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_driver_win_history(1);


-- Função: Corridas por Circuito

CREATE OR REPLACE FUNCTION get_races_by_circuit(circuit_name TEXT)
RETURNS TABLE(race_name TEXT, year BIGINT, round BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        r.name AS race_name,
        r.year::BIGINT AS year,
        r.round::BIGINT AS round
    FROM races r
    JOIN circuits c ON r.circuitId = c.circuitId
    WHERE c.name ILIKE '%' || circuit_name || '%'
    ORDER BY r.year, r.round;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM get_races_by_circuit('Silverstone');
