-- 1
DROP TABLE gamersteams;
DROP TABLE plays;
DROP TABLE games;
DROP TABLE gamers;
DROP TABLE teams;

CREATE TABLE games (
    gamecode CHAR(12) NOT NULL CONSTRAINT gamecode_pk PRIMARY KEY,
    gamename VARCHAR(100) NOT NULL CONSTRAINT gamecode_uk UNIQUE,
    firstrelease date
);

CREATE TABLE gamers (
    username VARCHAR2(12) NOT NULL CONSTRAINT username_pk PRIMARY KEY,
    nickname VARCHAR2(12) NOT NULL CONSTRAINT nickname_uk UNIQUE,
    email VARCHAR2(50) NOT NULL CONSTRAINT email_uk UNIQUE,
    password VARCHAR2(20) NOT NULL,
    birthdate date NOT NULL,
    parentemail VARCHAR2(50)
);

CREATE TABLE teams (
    teamname VARCHAR2(12) NOT NULL CONSTRAINT teamname_pk PRIMARY KEY
);

CREATE TABLE gamersteams (
    username VARCHAR2(12) NOT NULL CONSTRAINT user_fk REFERENCES gamers(username),
    teamname VARCHAR2(12) NOT NULL CONSTRAINT team_fk REFERENCES teams(teamname),
    CONSTRAINT gamer_team_pk PRIMARY KEY(username, teamname)
);

CREATE TABLE plays (
    play_id VARCHAR2(12) NOT NULL CONSTRAINT play_id_pk PRIMARY KEY,
    gamerank NUMBER(9),
    gamecode CHAR(12) NOT NULL CONSTRAINT gamecode_fk REFERENCES games(gamecode),
    username VARCHAR2(12) CONSTRAINT username_fk REFERENCES gamers(username),
    teamname VARCHAR2(12) CONSTRAINT teamname_fk REFERENCES teams(teamname),
    constraint userorteam CHECK(username IS NOT NULL AND teamname IS NULL OR username IS NULL AND teamname IS NOT NULL)
);


-- 2
INSERT INTO teams (
    teamname
) VALUES (
    'Imperial'
);

INSERT INTO gamers (
    username,
    nickname,
    email,
    password,
    birthdate
) VALUES (
    'FalleN',
    'FalleN',
    'fallen@imperials.com',
    '1234',
    to_date('30/05/1991', 'DD/MM/YY')
);

INSERT INTO gamers (
    username,
    nickname,
    email,
    password,
    birthdate
) VALUES (
    'Coldzera',
    'Coldzera',
    'coldzera@csgo.com',
    '1234',
    to_date('30/05/1994', 'DD/MM/YY')
);

INSERT INTO gamersteams(
    username,
    teamname
) VALUES (
    'FalleN',
    'Imperial'
);

INSERT INTO games (
    gamecode,
    gamename
) VALUES (
    'CSGO',
    'Counter Strike: Global Offensive'
);

INSERT INTO plays (
    play_id,
    gamerank,
    gamecode,
    teamname
) VALUES (
    '123',
    5,
    'CSGO',
    'Imperial'
);

INSERT INTO plays (
    play_id,
    gamerank,
    gamecode,
    username
) VALUES (
    '1234',
    5,
    'CSGO',
    'Coldzera'
);

COMMIT;

-- 3
UPDATE gamers
SET
    gamers.parentemail = 'monmare@gmail.com'
WHERE
    gamers.nickname = 'FalleN';

COMMIT;


-- 4
DELETE FROM teams
WHERE
    teams.teamname = 'Imperial';
-- no deixa eliminar pq aquest team te jugadors assosaits per la taula 'gamersteams',
-- per tant s'haura d'eliminar primer la assosiacio per poder eliminar, pero esta be.

ROLLBACK;

-- 5
SELECT
    *
FROM
    gamers
WHERE
    NOT EXISTS(
        SELECT
            *
        FROM
            gamersteams
        WHERE
            gamersteams.username = gamers.username
    );


-- 6
SELECT
    gamers.username,
    games.gamename,
    plays.gamerank
FROM
    plays
    JOIN gamers
    ON plays.username = gamers.username JOIN games
    ON plays.gamecode = games.gamecode
ORDER BY
    username,
    gamename;


-- 7
SELECT
    *
FROM
    (
        SELECT
            teams.teamname,
            games.gamename,
            plays.gamerank
        FROM
            plays
            JOIN teams
            ON plays.teamname = teams.teamname JOIN games
            ON plays.gamecode = games.gamecode
        ORDER BY
            plays.gamerank DESC
    )
WHERE
    ROWNUM <= 3;


-- 8
ALTER TABLE games DROP PRIMARY KEY CASCADE;

ALTER TABLE games ADD CONSTRAINT games_pk PRIMARY KEY (gamecode) DEFERRABLE INITIALLY IMMEDIATE;


-- 9
DROP VIEW full_department;
CREATE VIEW full_department AS
    SELECT
        departments.department_id,
        departments.department_name,
        locations.city,
        countries.country_name,
        locations.state_province
    FROM
        departments
        INNER JOIN locations
        ON departments.location_id = locations.location_id
        INNER JOIN countries
        ON locations.country_id = countries.country_id
WITH READ ONLY;

select * from full_department;


-- 10
SELECT
    e.first_name,
    e.last_name,
    e.salary
FROM
    employees e
WHERE
    e.last_name NOT LIKE '%h%'
    AND e.last_name NOT LIKE '%H%'
    AND e.bonus IS NULL
    AND e.salary BETWEEN 10000 AND 20000;



-- 11
SELECT
    max(e.salary),
    min(e.salary),
    sum(e.salary),
    avg(e.salary)
FROM
    employees e;


-- 12
SELECT
    e.job_id,
    e.department_id,
    AVG(e.salary),
FROM
    employees e
GROUP BY
    CUBE (e.job_id,
    e.department_id);


-- 13
SELECT
    e.department_id,
    e.last_name
FROM
    employees e
WHERE
    e.salary > (
        SELECT
            AVG(e2.salary)
        FROM
            employees e2
        WHERE
            e2.department_id = e.department_id
    )
    AND e.department_id IN (
        SELECT
            employees.department_id
        FROM
            employees
        GROUP BY
            employees.department_id
        HAVING
            COUNT(*) > 1
    );
    