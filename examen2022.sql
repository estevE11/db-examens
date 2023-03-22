-- 1
DROP TABLE prerequisits;
DROP TABLE imparticions;
DROP TABLE assignatures;
CREATE TABLE assignatures (
    acronim_assig VARCHAR(12) NOT NULL CONSTRAINT acronim_pk PRIMARY KEY,
    nom varchar(50) not null,
    credits number(9)
);

CREATE TABLE imparticions (
    TRIMESTRE VARCHAR(15) NOT NULL,
    COURSE NUMBER(4),
    GRUP VARCHAR(12),
    ESTUDIANTS NUMBER(4),
    ACRONIM_ASSIG VARCHAR(12) NOT NULL CONSTRAINT ASSIG_FK REFERENCES ASSIGNATURES(ACRONIM_ASSIG),
    CONSTRAINT IMPARTICIONS_PK PRIMARY KEY (TRIMESTRE, COURSE)
);

CREATE TABLE prerequisits (
    assig_anterior varchar(12) not null CONSTRAINT assig_ant_fk REFERENCES assignatures(acronim_assig),
    assig_posterior varchar(12) not null CONSTRAINT assig_post_fk REFERENCES assignatures(acronim_assig),
    constraint prerequisits_pk primary key (assig_anterior, assig_posterior)
);


-- 2
ALTER TABLE assignatures ADD CONSTRAINT cred_ck CHECK(credits >= 2
AND credits <= 6);

ALTER TABLE imparticions ADD CONSTRAINT trim_ck CHECK(trimestre IN ('Fall', 'Winter', 'Summer', 'Spring'));

ALTER TABLE imparticions ADD CONSTRAINT estudiants_ck CHECK(estudiants > -1);


-- 3
INSERT INTO assignatures (
    acronim_assig,
    nom,
    credits
) VALUES (
    'IDB',
    'Intro Base de dades',
    '4'
);

INSERT INTO assignatures (
    acronim_assig,
    nom,
    credits
) VALUES (
    'DBD',
    'Disseny Base de dades',
    '4'
);

INSERT INTO assignatures (
    acronim_assig,
    nom,
    credits
) VALUES (
    'SGDB',
    'Sistemes Gestors de Base de dades',
    '4'
);

INSERT INTO prerequisits (
    assig_anterior,
    assig_posterior
) VALUES (
    'IDB',
    'DBD'
);

INSERT INTO prerequisits (
    assig_anterior,
    assig_posterior
) VALUES (
    'DBD',
    'SGDB'
);
COMMIT;

-- 4
INSERT INTO imparticions (
    trimestre,
    course,
    grup,
    estudiants,
    acronim_assig
) VALUES (
    'Winter',
    2016,
    '10',
    3,
    'DBD'
);
INSERT INTO imparticions (
    trimestre,
    course,
    grup,
    estudiants,
    acronim_assig
) VALUES (
    'Fall',
    2016,
    '10',
    7,
    'DBD'
);
INSERT INTO imparticions (
    trimestre,
    course,
    grup,
    estudiants,
    acronim_assig
) VALUES (
    'Fall',
    2015,
    '10',
    6,
    'DBD'
);
INSERT INTO imparticions (
    trimestre,
    course,
    grup,
    estudiants,
    acronim_assig
) VALUES (
    'Summer',
    2015,
    '10',
    2,
    'SGDB'
);

-- 5



-- 6
SELECT
    concat(aa.nom, concat(' es prerequisit de ', ap.nom))
FROM
    prerequisits
    JOIN assignatures aa
    ON prerequisits.assig_anterior = aa.acronim_assig
    JOIN assignatures ap
    ON prerequisits.assig_posterior = ap.acronim_assig;


-- 7
CREATE USER gestorplaestudis IDENTIFIED BY "password";
GRANT SELECT, UPDATE OF ESTUDIANTS ON IMPARTICIONS TO GESTORPLAESTUDIS WITH GRANT OPTION;


-- 8
SELECT
    concat(sum(ESTUDIANTS), concat(' matriculats a ', concat(grup, concat(acronim_assig, concat(' en ', concat(trimestre, concat('/', course)))))))
FROM
    imparticions
group by rollup(acronim_assig, course, trimestre, grup);


-- 9
SELECT
    *
FROM
    assignatures MINUS
    SELECT
        ass.*
    FROM
        prerequisits
        JOIN assignatures ass
        ON prerequisits.assig_anterior = ass.acronim_assig;


-- 10
SELECT
    *
FROM
    assignatures ass
WHERE
    NOT EXISTS (
        SELECT
            ass.*
        FROM
            prerequisits
        WHERE
            prerequisits.assig_anterior = ass.acronim_assig
    );
