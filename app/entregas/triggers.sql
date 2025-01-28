-- Trigger: Atualizar Total de Pontos do Piloto

CREATE OR REPLACE FUNCTION update_driver_points()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE driver_standings
    SET points = (
        SELECT SUM(points)
        FROM results
        WHERE driverId = NEW.driverId
    )
    WHERE driverId = NEW.driverId;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_driver_points
AFTER INSERT OR UPDATE ON results
FOR EACH ROW
EXECUTE FUNCTION update_driver_points();

-- Trigger: Atualizar Número de Corridas no Circuito

CREATE OR REPLACE FUNCTION update_circuit_race_count()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        -- Incrementa o total de corridas no circuito
        UPDATE circuits
        SET total_races = COALESCE(total_races, 0) + 1
        WHERE circuitId = NEW.circuitId;
    ELSIF TG_OP = 'DELETE' THEN
        -- Decrementa o total de corridas no circuito
        UPDATE circuits
        SET total_races = COALESCE(total_races, 0) - 1
        WHERE circuitId = OLD.circuitId;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_circuit_race_count
AFTER INSERT OR DELETE ON races
FOR EACH ROW
EXECUTE FUNCTION update_circuit_race_count();

-- Trigger: Atualizar o Número de Vitórias do Construtor

CREATE OR REPLACE FUNCTION update_constructor_wins()
RETURNS TRIGGER AS $$
BEGIN

    UPDATE constructor_standings
    SET wins = wins + 1
    WHERE constructorId = NEW.constructorId
      AND raceId = NEW.raceId;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_delete_team_goals_in_match
AFTER DELETE ON match_goals
FOR EACH ROW
EXECUTE FUNCTION delete_team_goals_in_match();

