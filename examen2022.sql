-- 1
DROP TABLE prerequisits;
DROP TABLE imparticions;
DROP TABLE assignatures;
CREATE TABLE assignatures (
    acronim_assig VARCHAR(12) NOT NULL CONSTRAINT acronim_pk PRIMARY KEY,
    nom varchar(30) not null,
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