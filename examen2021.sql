-- 1
CREATE TABLE editorials (
    codi CHAR(12) NOT NULL CONSTRAINT codi_pk PRIMARY KEY,
    nom VARCHAR(50) NOT NULL CONSTRAINT nom_uk UNIQUE,
    adress VARCHAR(50),
    postcode VARCHAR(5),
    pobl VARCHAR(50),
    telf VARCHAR(12) CONSTRAINT telf_uk UNIQUE
);


-- 2
