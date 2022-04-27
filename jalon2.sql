CREATE TABLE Encadrant (nomEncadrant VARCHAR (80),
                prenomEncadrant VARCHAR (80),
		    PRIMARY KEY (nomEncadrant,prenomEncadrant)
               );
               

CREATE TABLE Responsable (nomResponsable VARCHAR (80),
               prenomResponsable VARCHAR (80),
		    PRIMARY KEY (nomResponsable,prenomResponsable)
               );

CREATE TABLE UE (code_apoge VARCHAR (10),
                libelle VARCHAR (150),
                semestre VARCHAR (10),
		        annee SMALLINT,
                nomResponsable VARCHAR (80),
                prenomResponsable VARCHAR (80),
                idp BIGINT (20),
		    PRIMARY KEY (code_apoge),
            FOREIGN KEY (nomResponsable,prenomResponsable) REFERENCES Responsable(nomResponsable,prenomResponsable),
            FOREIGN KEY (idp) REFERENCES Projet(idp)
                );

CREATE TABLE Equipe (equipe VARCHAR(80),
                    nomEncadrant VARCHAR(80),
                    prenomEncadrant VARCHAR(80),
                    idp BIGINT (20),
		    PRIMARY KEY (equipe),
            FOREIGN KEY (nomEncadrant,prenomEncadrant) REFERENCES Encadrant(nomEncadrant,prenomEncadrant),
            FOREIGN KEY (idp) REFERENCES Projet(idp)
               ); 

CREATE TABLE Projet (idp BIGINT (20),
		       titre VARCHAR (80),
		    PRIMARY KEY (idp)
               );

CREATE TABLE Rendu (idr INTEGER AUTO_INCREMENT,
               idp BIGINT (20),
               dateRendu Date,
               noteRendu SMALLINT(6),
               equipe VARCHAR(80),
               nomEncadrant VARCHAR (80),
               prenomEncadrant VARCHAR (80),
		    PRIMARY KEY (idr),
            FOREIGN KEY (idp) REFERENCES Projet(idp),
            FOREIGN KEY (equipe) REFERENCES Equipe(equipe),
            FOREIGN KEY (nomEncadrant,prenomEncadrant) REFERENCES Encadrant(nomEncadrant,prenomEncadrant)
               );

CREATE TABLE Realisation (titre VARCHAR (80),
               noteFinale VARCHAR(6),
               commentaires VARCHAR(254),
		    PRIMARY KEY (titre)
               );

CREATE TABLE Jalon (numJalon SMALLINT(6),
               libelle VARCHAR(80),
               dateLimite DATE,
               note SMALLINT (6),
               idp BIGINT (20),
		    PRIMARY KEY (numJalon,idp)
               );

CREATE TABLE Etudiant (numEtu VARCHAR (10),
               nom VARCHAR (161),
               prenom VARCHAR (161),
               UE VARCHAR (10),
               equipe VARCHAR(80),
		    PRIMARY KEY (numEtu),
            FOREIGN KEY (UE) REFERENCES UE(code_apoge),
            FOREIGN KEY (equipe) REFERENCES Equipe(equipe)
               );   



/******************************SCRIPT SQL: SCHEMA E/A*******************************/
/**BON************Enseignant*******************************************/
CREATE TABLE Enseignant(
   idEns INT AUTO_INCREMENT,
   nom VARCHAR (80),
   prenom VARCHAR (80),
   PRIMARY KEY(idEns)
);
INSERT INTO Enseignant (nomEnseignant,prenomEnseignant) SELECT * FROM(
SELECT DISTINCT ue_responsable_nom AS nomResponsable , ue_responsable_prenom AS prenomResponsable
FROM donnees_fournies.instances
UNION
SELECT DISTINCT encadrant_nom AS nomEncadrant , encadrant_prenom AS prenomEncadrant
FROM donnees_fournies.instances) R

/**BON**********Etudiant*****************************************************/
CREATE TABLE Etudiant(
   numEtu VARCHAR (10),
   nom VARCHAR (161),
   prenom VARCHAR (161),
   UE VARCHAR (10),
   PRIMARY KEY(numEtu)
);

INSERT INTO Etudiant (numEtu,prenom,nom) SELECT * FROM(
SELECT DISTINCT etudiant1_numetu AS numEtu, SUBSTRING(etudiant1_nomprenom,1, INSTR(etudiant1_nomprenom,';')-1) AS prenom, 
SUBSTRING(etudiant1_nomprenom,INSTR(etudiant1_nomprenom,';')+1) AS nom
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant2_numetu AS numEtu, SUBSTRING(etudiant2_nomprenom,1, INSTR(etudiant2_nomprenom,';')-1) AS prenom,
SUBSTRING(etudiant2_nomprenom,INSTR(etudiant2_nomprenom,';')+1) AS nom
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant3_numetu AS numEtu, SUBSTRING(etudiant3_nomprenom,1, INSTR(etudiant3_nomprenom,';')-1) AS prenom,
SUBSTRING(etudiant3_nomprenom,INSTR(etudiant3_nomprenom,';')+1) AS nom
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant4_numetu AS numEtu, SUBSTRING(etudiant4_nomprenom,1, INSTR(etudiant4_nomprenom,';')-1) AS prenom,
SUBSTRING(etudiant4_nomprenom,INSTR(etudiant4_nomprenom,';')+1) AS nom
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant5_numetu AS numEtu, SUBSTRING(etudiant5_nomprenom,1, INSTR(etudiant5_nomprenom,';')-1) AS prenom,
SUBSTRING(etudiant5_nomprenom,INSTR(etudiant5_nomprenom,';')+1) AS nom
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant6_numetu AS numEtu, SUBSTRING(etudiant6_nomprenom,1, INSTR(etudiant6_nomprenom,';')-1) AS prenom,
SUBSTRING(etudiant6_nomprenom,INSTR(etudiant6_nomprenom,';')+1) AS nom
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant7_numetu AS numEtu, SUBSTRING(etudiant7_nomprenom,1, INSTR(etudiant7_nomprenom,';')-1) AS prenom,
SUBSTRING(etudiant7_nomprenom,INSTR(etudiant7_nomprenom,';')+1) AS nom
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant8_numetu AS numEtu, SUBSTRING(etudiant8_nomprenom,1, INSTR(etudiant8_nomprenom,';')-1) AS prenom,
SUBSTRING(etudiant8_nomprenom,INSTR(etudiant8_nomprenom,';')+1) AS nom
FROM donnees_fournies.instances)a WHERE numEtu IS NOT NULL
/******BON**************UE***************************************************/
CREATE TABLE UE(
   code_apoge VARCHAR(50),
   libelle VARCHAR (150),
   semestre VARCHAR (10),
	annee SMALLINT,
   Nbp INT,
   idEns INT,
   PRIMARY KEY(code_apoge),
   FOREIGN KEY(idEns) REFERENCES Enseignant(idEns)
);

INSERT INTO UE (code_apoge,libelle,semestre,annee,Nbp,idEns) SELECT * FROM(
SELECT DISTINCT I.code_apoge AS APOGE , I.ue_libelle AS libelle, I.semestre AS semestre, I.annee AS annee, COUNT(I.idp) AS idp, E.idEns AS idEns
FROM donnees_fournies.instances I JOIN Enseignant E ON I.ue_responsable_nom=E.nomEnseignant AND I.ue_responsable_prenom=E.prenomEnseignant
GROUP BY I.code_apoge) U


/**BON*************Projet******************************************************/
CREATE TABLE Projet(
   idp BIGINT (20),
   titre VARCHAR (80),
	PRIMARY KEY (idp)
);

INSERT INTO Projet (idp,titre) SELECT * FROM(
SELECT DISTINCT idp AS idp , SUBSTRING(projet_titre,INSTR(projet_titre,'Projet')+6,length(projet_titre)) AS titre
FROM donnees_fournies.instances) P

/**BON*****************Equipe**************************************************************/
CREATE TABLE Equipe(
   idEq INT AUTO_INCREMENT,
   equipe VARCHAR(80),
   idp BIGINT (20),
   idEns INT,
   PRIMARY KEY(idEq),
   FOREIGN KEY(idp) REFERENCES Projet(idp),
   FOREIGN KEY(idEns) REFERENCES Enseignant(idEns)
);
INSERT INTO Equipe (equipe,idEns,idp) SELECT * FROM(
SELECT DISTINCT nom_equipe AS equipe ,idEns AS idEns, idp AS idp
FROM donnees_fournies.instances I JOIN Enseignant E 
ON I.encadrant_nom=E.nomEnseignant AND I.encadrant_prenom=E.prenomEnseignant ) Q

/**BON****************Jalon**********************************************************/
CREATE TABLE Jalon(
   rang INT AUTO_INCREMENT,
   numJalon BIGINT(6),
   libelle VARCHAR(80),
   dateLimite DATE,
   note SMALLINT (6),
   idp BIGINT (20),
   PRIMARY KEY(rang),
   FOREIGN KEY(idp) REFERENCES Projet(idp)
);

INSERT INTO Jalon (numJalon,libelle,dateLimite,note,idp) SELECT * FROM(
SELECT DISTINCT jalon1_num AS numJalon , jalon1_libelle AS libelle, jalon1_datelimite AS dateLimite, jalon1_note AS note, idp AS idp
FROM donnees_fournies.instances
UNION
SELECT DISTINCT jalon2_num AS numJalon , jalon2_libelle AS libelle, jalon2_datelimite AS dateLimite, jalon2_note AS note, idp AS idp
FROM donnees_fournies.instances
UNION
SELECT DISTINCT jalon3_num AS numJalon , jalon3_libelle AS libelle, jalon3_datelimite AS dateLimite, jalon3_note AS note, idp AS idp
FROM donnees_fournies.instances
UNION
SELECT DISTINCT jalon4_num AS numJalon , jalon4_libelle AS libelle, jalon4_datelimite AS dateLimite, jalon4_note AS note, idp AS idp
FROM donnees_fournies.instances) J Where numJalon IS NOT NULL

/**BON**************Rendu**********************************************************/
CREATE TABLE Rendu(
   idr INT AUTO_INCREMENT,
   idp BIGINT (20),
   dateRendu Date,
   noteRendu SMALLINT(6),
   PRIMARY KEY (idr),
   FOREIGN KEY (idp) REFERENCES Projet(idp)
);

INSERT INTO Rendu (dateRendu,noteRendu,idp) SELECT * FROM(
SELECT DISTINCT rendu1_date AS dateR1 , rendu1_note AS noteR1, idp AS idp
FROM donnees_fournies.instances I 
UNION
SELECT DISTINCT rendu2_date AS dateR2 , rendu2_note AS noteR2, idp AS idp
FROM donnees_fournies.instances I 
UNION
SELECT DISTINCT rendu3_date AS dateR3 , rendu3_note AS noteR3, idp AS idp
FROM donnees_fournies.instances I 
UNION
SELECT DISTINCT rendu4_date AS dateR4 , rendu4_note AS noteR4, idp AS idp
FROM donnees_fournies.instances I ) r

/**BON**************Realisation**********************************************************/
CREATE TABLE Realisation(
   numReal BIGINT,
   projet VARCHAR (80),
   annee SMALLINT(6),
   noteFinale  SMALLINT(6),
   semestre VARCHAR(80),
   commentaires VARCHAR(254),
   idp BIGINT (20),
   PRIMARY KEY(numReal),
   FOREIGN KEY(idp) REFERENCES Projet(idp)
);
INSERT INTO Realisation (numReal,projet,annee,semestre,noteFinale,commentaires,idp) SELECT * FROM(
SELECT DISTINCT SUBSTRING(titre_realisation,INSTR(titre_realisation,'.')+1, INSTR(titre_realisation,'pour')-6) AS numReal, 
SUBSTRING(titre_realisation,INSTR(titre_realisation,'projet')+6, 9) AS projet,
SUBSTRING(titre_realisation,INSTR(titre_realisation,'_')+1, 4) AS annee,
SUBSTRING(titre_realisation,INSTR(titre_realisation,'_')+6, length(titre_realisation)-INSTR(titre_realisation,'_')+1) AS semestre,
note_finale AS noteFinale, observations AS commentaires,idp AS idp
FROM donnees_fournies.instances) R

/*********************************Les plus important*****************************/
CREATE TABLE Concours(
   idC INT,
   libelleC VARCHAR(50),
   description VARCHAR(50),
   prix DECIMAL(15,2),
   idp INT NOT NULL,
   PRIMARY KEY(idC),
   FOREIGN KEY(idp) REFERENCES Projet(idp)
);

CREATE TABLE EquipePedagogique(
   idEns INT,
   PRIMARY KEY(idEns)
);

CREATE TABLE Question(
   idQuestion VARCHAR(50),
   libelleQ VARCHAR(50),
   theme VARCHAR(50),
   APOGE VARCHAR(50) NOT NULL,
   PRIMARY KEY(idQuestion),
   FOREIGN KEY(APOGE) REFERENCES UE(APOGE)
);

CREATE TABLE Revue(
   idRevue INT,
   PRIMARY KEY(idRevue)
);

CREATE TABLE Batiment(
   idB INT,
   PRIMARY KEY(idB)
);

CREATE TABLE Salle(
   idB INT,
   idS INT,
   PRIMARY KEY(idB, idS),
   FOREIGN KEY(idB) REFERENCES Batiment(idB)
);

CREATE TABLE ElementA(
   idT VARCHAR(50),
   texte VARCHAR(50),
   PRIMARY KEY(idT)
);

CREATE TABLE Rapport(
   numJalon INT,
   titre VARCHAR(50),
   objectif VARCHAR(50),
   PRIMARY KEY(numJalon),
   FOREIGN KEY(numJalon) REFERENCES Jalon(numJalon)
);

CREATE TABLE Avancement(
   numJalon INT,
   etat VARCHAR(50),
   idp INT NOT NULL,
   idT VARCHAR(50) NOT NULL,
   PRIMARY KEY(numJalon),
   FOREIGN KEY(numJalon) REFERENCES Jalon(numJalon),
   FOREIGN KEY(idp) REFERENCES Projet(idp),
   FOREIGN KEY(idT) REFERENCES ElementA(idT)
);

CREATE TABLE Questionnaire(
   numJalon INT,
   theme VARCHAR(50),
   idp INT NOT NULL,
   idQuestion VARCHAR(50) NOT NULL,
   PRIMARY KEY(numJalon),
   FOREIGN KEY(numJalon) REFERENCES Jalon(numJalon),
   FOREIGN KEY(idp) REFERENCES Projet(idp),
   FOREIGN KEY(idQuestion) REFERENCES Question(idQuestion)
);

CREATE TABLE Code(
   numJalon INT,
   qualite VARCHAR(50),
   idRevue INT NOT NULL,
   PRIMARY KEY(numJalon),
   FOREIGN KEY(numJalon) REFERENCES Jalon(numJalon),
   FOREIGN KEY(idRevue) REFERENCES Revue(idRevue)
);

CREATE TABLE Soutenance(
   numJalon INT,
   titre VARCHAR(50),
   consigne VARCHAR(50),
   PRIMARY KEY(numJalon),
   FOREIGN KEY(numJalon) REFERENCES Jalon(numJalon)
);

CREATE TABLE comprendre(
   num_étu INT,
   idEq INT,
   role VARCHAR(50),
   PRIMARY KEY(num_étu, idEq),
   FOREIGN KEY(num_étu) REFERENCES Etudiant(num_étu),
   FOREIGN KEY(idEq) REFERENCES Equipe(idEq)
);

CREATE TABLE constitue(
   idEns INT,
   idEns INT,
   PRIMARY KEY(idEns, idEns),
   FOREIGN KEY(idEns) REFERENCES Enseignant(idEns),
   FOREIGN KEY(idEns) REFERENCES EquipePedagogique(idEns)
);

CREATE TABLE redige(
   idEns INT,
   idp INT,
   PRIMARY KEY(idEns, idp),
   FOREIGN KEY(idEns) REFERENCES Enseignant(idEns),
   FOREIGN KEY(idp) REFERENCES Projet(idp)
);

CREATE TABLE effectue(
   idEq INT,
   idR INT,
   PRIMARY KEY(idEq, idR),
   FOREIGN KEY(idEq) REFERENCES Equipe(idEq),
   FOREIGN KEY(idR) REFERENCES Realisation(idR)
);

CREATE TABLE evalue(
   idEns INT,
   idr INT,
   PRIMARY KEY(idEns, idr),
   FOREIGN KEY(idEns) REFERENCES Enseignant(idEns),
   FOREIGN KEY(idr) REFERENCES Rendu(idr)
);

CREATE TABLE inscrit(
   num_étu INT,
   APOGE VARCHAR(50),
   TD VARCHAR(50),
   TP VARCHAR(50),
   PRIMARY KEY(num_étu, APOGE),
   FOREIGN KEY(num_étu) REFERENCES Etudiant(num_étu),
   FOREIGN KEY(APOGE) REFERENCES UE(APOGE)
);

CREATE TABLE est_cree_de(
   idp INT,
   idp INT,
   PRIMARY KEY(idp, idp_1),
   FOREIGN KEY(idp) REFERENCES Projet(idp),
   FOREIGN KEY(idp_1) REFERENCES Projet(idp)
);

CREATE TABLE est_affecte(
   idEq INT,
   numJalon INT,
   idB INT,
   dateA DATE,
   horaire TIME,
   lieu VARCHAR(50),
   PRIMARY KEY(idEq, numJalon, idB),
   FOREIGN KEY(idEq) REFERENCES Equipe(idEq),
   FOREIGN KEY(numJalon) REFERENCES Soutenance(numJalon),
   FOREIGN KEY(idB) REFERENCES Batiment(idB)
);

CREATE TABLE declare3(
   idEns INT,
   APOGE VARCHAR(50),
   idp INT,
   PRIMARY KEY(idEns, APOGE, idp),
   FOREIGN KEY(idEns) REFERENCES Enseignant(idEns),
   FOREIGN KEY(APOGE) REFERENCES UE(APOGE),
   FOREIGN KEY(idp) REFERENCES Projet(idp)
);

