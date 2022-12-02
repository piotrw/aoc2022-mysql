CREATE DEFINER=`root`@`localhost` PROCEDURE `day01`()
    LANGUAGE SQL
    NOT DETERMINISTIC
    READS SQL DATA
    SQL SECURITY DEFINER
    COMMENT ''
BEGIN

    DECLARE curr_cal INT DEFAULT 0;
    DECLARE curr_dude INT DEFAULT 0;
    DECLARE done INT DEFAULT FALSE;
    DECLARE calories CURSOR FOR SELECT * FROM day01;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    DROP TABLE IF EXISTS results;
    CREATE TEMPORARY TABLE results (dude INT, calories INT, UNIQUE INDEX unique_dude (dude));

    OPEN calories;

    caloriesLoop: LOOP

        FETCH calories INTO curr_cal;

        IF done THEN
            LEAVE caloriesLoop;
        END IF;

        IF curr_cal IS NULL OR curr_cal = 0 OR curr_dude = 0 THEN
            SET curr_dude = curr_dude + 1;
            INSERT INTO results VALUES (curr_dude, 0);
        END IF;

        IF curr_cal > 0 THEN
            UPDATE results SET calories = calories + curr_cal WHERE dude = curr_dude;
        END IF;

    END LOOP;

    CLOSE calories;

    SELECT MAX(calories) AS result_1 FROM results;

    SELECT SUM(sub.top3) AS result_2 FROM
        ( SELECT MAX(calories) AS top3 FROM results GROUP BY dude ORDER BY top3 DESC LIMIT 3 ) AS sub;

END