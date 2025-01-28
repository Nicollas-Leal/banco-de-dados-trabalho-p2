-- Procedure: Transferir Pontos Entre Pilotos

CREATE OR REPLACE PROCEDURE transfer_driver_points(
    from_driver_id INT,
    to_driver_id INT,
    race_id INT,
    points_to_transfer NUMERIC
)
AS $$
BEGIN
    IF (SELECT points FROM driver_standings
        WHERE driverId = from_driver_id AND raceId = race_id) < points_to_transfer THEN
        RAISE EXCEPTION 'O piloto de origem não possui pontos suficientes para transferir.';
    END IF;
    UPDATE driver_standings
    SET points = points - points_to_transfer
    WHERE driverId = from_driver_id AND raceId = race_id;
    UPDATE driver_standings
    SET points = points + points_to_transfer
    WHERE driverId = to_driver_id AND raceId = race_id;

    RAISE NOTICE 'Transferência concluída: % pontos transferidos do piloto % para o piloto % na corrida %.',
                 points_to_transfer, from_driver_id, to_driver_id, race_id;
END;
$$ LANGUAGE plpgsql;

CALL add_new_race(
    'Brazilian Grand Prix', '2023-11-12', 2023, 20, 5
);

-- Procedure: Atualizar o Nome de um Circuito e Ajustar Corridas Relacionadas

CREATE OR REPLACE PROCEDURE update_circuit_and_races(
    circuit_id INT,
    new_name TEXT,
    prefix TEXT
)
AS $$
BEGIN
    UPDATE circuits
    SET name = new_name
    WHERE circuitId = circuit_id;
    UPDATE races
    SET name = prefix || ' ' || name
    WHERE circuitId = circuit_id;
END;
$$ LANGUAGE plpgsql;

CALL update_circuit_and_races(10, 'New Circuit Name', 'Updated');

-- Procedure: Excluir uma Temporada e Todas as Corridas Associadas

CREATE OR REPLACE PROCEDURE delete_season_and_races(
    season_year INT
)
AS $$
BEGIN
    DELETE FROM races
    WHERE year = season_year;
    DELETE FROM seasons
    WHERE year = season_year;
END;
$$ LANGUAGE plpgsql;

CALL delete_season_and_races(2021);
