--Creating the Triggers to control the Game

CREATE TRIGGER On_DieRoll_Update
AFTER UPDATE OF DieRoll ON Players
BEGIN

	--Update location of the player when a die is rolled and the player is not suspended. If location + die roll is greater than 20, we start back from position 1 again.
	UPDATE Players
	SET Location = IIF((NEW.DieRoll + OLD.Location) > 20, NEW.DieRoll + OLD.Location - 20, NEW.DieRoll + OLD.Location)
	WHERE ID = NEW.ID AND IsSuspended = 0;
	--Update suspension status of player, if the player is suspended and die roll is 6.
	UPDATE Players
	SET IsSuspended = 0
	WHERE ID = NEW.ID AND NEW.DieRoll = 6 AND IsSuspended = 1;
 
END;


CREATE TRIGGER On_Location_Update
AFTER UPDATE OF Location ON Players
BEGIN

	-- Add 100 to the players balance when they pass welcome week. Make sure player is not going to suspension
	UPDATE Players
	SET Balance = IIF(NEW.Location < OLD.Location, Balance + 100, Balance)
	WHERE ID = new.ID AND IsSuspended = 0;

	--Update balance of the current player depending on the current location when die roll is not 6
	UPDATE Players
	SET
		Balance = CASE (SELECT Type FROM Locations WHERE Locations.ID = NEW.Location)
			--When at building locations
			WHEN 'Buildings' THEN
				CASE
					-- If the building has no owner, buy the building
					WHEN (SELECT Owner FROM Buildings WHERE Buildings.ID = NEW.Location) IS NULL
						THEN Balance - (2 * (SELECT TuitionFee FROM Buildings WHERE Buildings.ID = NEW.Location))
					--If the building is owned by the player, do nothing
					WHEN (SELECT Owner FROM Buildings WHERE Buildings.ID = NEW.Location) = NEW.Token
						THEN Balance
					--If the building is owned by another player, pay the tuition fee or double depending on whether they own both the buildings in the category
					ELSE
						CASE (SELECT IsSameOwner FROM Buildings WHERE Buildings.ID = NEW.Location)
							WHEN 1
								THEN Balance - (2 * (SELECT TuitionFee FROM Buildings WHERE Buildings.ID = NEW.Location))
							WHEN 0
								THEN Balance - (SELECT TuitionFee FROM Buildings WHERE Buildings.ID = NEW.Location)
						END
				END
			ELSE 
				--When at RAG or Hearing locations
				CASE (NEW.Location)
					WHEN 4 THEN Balance - 20
					WHEN 7 THEN Balance + 15
					WHEN 14 THEN Balance - 10 * ((SELECT COUNT(*) FROM Players) - 1)
					WHEN 17 THEN Balance - 25
					ELSE Balance
				END
		END		
	WHERE ID = NEW.ID AND NEW.DieRoll <> 6;


	--Update balance of the building owner when die roll is not 6
	UPDATE Players
	SET
		Balance = CASE (SELECT Type FROM Locations WHERE Locations.ID = NEW.Location)
			WHEN 'Buildings' THEN
				CASE
					-- If the building has no owner, do nothing
					WHEN (SELECT Owner FROM Buildings WHERE Buildings.ID = NEW.Location) IS NULL
						THEN Balance
					--If the building is owned by the current player, do nothing
					WHEN (SELECT Owner FROM Buildings WHERE Buildings.ID = NEW.Location) = NEW.Token
						THEN Balance
					--If the building is owned by another player, pay the tuition fee or double depending on whether they own both the buildings in the category
					ELSE
						CASE (SELECT IsSameOwner FROM Buildings WHERE Buildings.ID = NEW.Location)
							WHEN 1
								THEN Balance + (2 * (SELECT TuitionFee FROM Buildings WHERE Buildings.ID = NEW.Location))
							WHEN 0
								THEN Balance + (SELECT TuitionFee FROM Buildings WHERE Buildings.ID = NEW.Location)
						END
				END
			ELSE
				Balance
		END
	WHERE Token = (SELECT Owner FROM Buildings WHERE Buildings.ID = NEW.Location) AND NEW.DieRoll <> 6;

	--Update balance of all other players when location is at 14 and when die roll is not 6
	UPDATE Players
	SET Balance = Balance + 10
	WHERE ID <> NEW.ID AND NEW.DieRoll <> 6 AND NEW.Location = 14;

	--Update suspension status of current player when location is at 18 and when die roll is not 6
	UPDATE Players
	SET IsSuspended = 1
	WHERE ID = NEW.ID AND NEW.DieRoll <> 6 AND NEW.Location = 18;

	--Update building owner status if player is at a building owned by no one and die roll is not 6
	UPDATE Buildings
	SET Owner = NEW.Token
	WHERE ID = NEW.Location AND NEW.DieRoll <> 6 AND Owner IS NULL;

	--Update Audit trails
	INSERT INTO Audit_Trails
	SELECT
		ID, Location, Balance,
		(SELECT IIF(COUNT(*) >= (SELECT COUNT(*) FROM Players), MAX(GameRound) + 1, MAX(GameRound)) FROM Audit_Trails GROUP BY GameRound ORDER BY GameRound DESC LIMIT 1)
	FROM Players
	WHERE ID = NEW.ID AND NEW.DieRoll <> 6 AND Location <> 18;

END;


CREATE TRIGGER On_BuildingOwner_Update
AFTER UPDATE OF Owner ON Buildings
BEGIN

	--Update isSameOwner status if player just bought a building and they own both in the same category
	UPDATE Buildings
	SET
		IsSameOwner = CASE 
			WHEN (SELECT COUNT(DISTINCT Owner) FROM Buildings WHERE TuitionFee = new.TuitionFee) = 1
				AND (SELECT COUNT(*) FROM Buildings WHERE TuitionFee = NEW.TuitionFee AND Owner IS NOT NULL) = 2
				THEN 1
			ELSE 0
		END
	WHERE TuitionFee = new.TuitionFee;

END;


CREATE TRIGGER On_IsSuspended_Update
AFTER UPDATE OF IsSuspended ON Players
BEGIN

	--Update location of player when they are suspended
	UPDATE Players
	SET Location = 8
	WHERE ID = NEW.ID AND IsSuspended = 1;

END;

CREATE TRIGGER On_Player_Insert
AFTER INSERT ON Players
BEGIN
    -- Add the initial position to audit trails when a player is added
    INSERT INTO Audit_Trails
    SELECT
		ID, Location, Balance, 0
	FROM Players
	WHERE ID = NEW.ID;
END;