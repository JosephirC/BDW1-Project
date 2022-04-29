/*Creation d'une table Etudiant en utilisant les donnees fournies dans la table 
instances et on utilise pour "SUBSTRING" pour segmenter 
le nom et prenom des etudiants ***************************/
CREATE TABLE Etudiant(
   numEtu VARCHAR (10),
   nom VARCHAR (161),
   prenom VARCHAR (161),
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

/**BON************Enseignant*******************************************/
CREATE TABLE Enseignant(
   idEns INT AUTO_INCREMENT,
   nomEnseignant VARCHAR (80),
   prenomEnseignant VARCHAR (80),
   PRIMARY KEY(idEns)
);
INSERT INTO Enseignant (nomEnseignant,prenomEnseignant) SELECT * FROM(
SELECT DISTINCT ue_responsable_nom AS nomResponsable , ue_responsable_prenom AS prenomResponsable
FROM donnees_fournies.instances
UNION
SELECT DISTINCT encadrant_nom AS nomEncadrant , encadrant_prenom AS prenomEncadrant
FROM donnees_fournies.instances) R

/******BON**************UE***************************************************/
CREATE TABLE UE(
   code_apoge VARCHAR(50),
   libelle VARCHAR (150),
   semestre VARCHAR (10),
	annee SMALLINT,
   Nbp INT,
   idEns INT,
   PRIMARY KEY(code_apoge,semestre,annee),
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

/**BON*****************Equipe**************************************************************/
CREATE TABLE Equipe(
   equipe VARCHAR(80),
   idp BIGINT (20),
   idEns INT,
   PRIMARY KEY(equipe),
   FOREIGN KEY(idp) REFERENCES Projet(idp),
   FOREIGN KEY(idEns) REFERENCES Enseignant(idEns)
);
INSERT INTO Equipe (equipe,idEns,idp) SELECT * FROM(
SELECT DISTINCT nom_equipe AS equipe ,idEns AS idEns, idp AS idp
FROM donnees_fournies.instances I JOIN Enseignant E 
ON I.encadrant_nom=E.nomEnseignant AND I.encadrant_prenom=E.prenomEnseignant ) Q


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

/**BON**************Rendu**********************************************************/
CREATE TABLE Rendu(
   idr INT AUTO_INCREMENT,
   idp BIGINT (20),
   dateRendu Date,
   noteRendu SMALLINT(6),
    numReal BIGINT,
   PRIMARY KEY (idr),
   FOREIGN KEY (idp) REFERENCES Projet(idp),
   FOREIGN KEY (numReal) REFERENCES Realisation(numReal)
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


/**Bieen**Concours*****/
CREATE TABLE Concours(
   idC INT AUTO_INCREMENT,
   idp BIGINT (20),
   PRIMARY KEY(idC),
   FOREIGN KEY(idp) REFERENCES Projet(idp)
);
INSERT INTO Concours (idp) SELECT * FROM(
   SELECT DISTINCT idp FROM donnees_fournies.instances)c


/**Bieen********EquipePedagogique*******/
CREATE TABLE EquipePedagogique(
   idEqP INT AUTO_INCREMENT,
   PRIMARY KEY(idEqP)
);

/**Bieen*****A REVOIR***Revue*******/
CREATE TABLE Revue(
   idRevue INT AUTO_INCREMENT,
   PRIMARY KEY(idRevue)
);

/***Bieen*******Rapport*******/
CREATE TABLE Rapport(
   rang INT,
   FOREIGN KEY(rang) REFERENCES Jalon(rang)
);
INSERT INTO Rapport(rang) SELECT * FROM(
   SELECT DISTINCT rang FROM Jalon)S


/***Bieen*******ElementA*******/
CREATE TABLE ElementA(
   idT INT AUTO_INCREMENT,
   PRIMARY KEY(idT)
);

/***Bieen*******Avancement*******/
CREATE TABLE Avancement(
   rang INT,
   idp BIGINT (20),
   idT INT,
   etat VARCHAR(30),
   FOREIGN KEY(rang) REFERENCES Jalon(rang),
   FOREIGN KEY(idp) REFERENCES Projet(idp),
   FOREIGN KEY(idT) REFERENCES ElementA(idT)
);
INSERT INTO Avancement(rang, idp) SELECT * FROM(
   SELECT DISTINCT rang FROM Jalon WHERE libelle LIKE '%Avancement%')y

/*****Bieen**********Code*********************/
CREATE TABLE Code(
   rang INT,
   idRevue INT,
   FOREIGN KEY(rang) REFERENCES Jalon(rang),

   FOREIGN KEY(idRevue) REFERENCES Revue(idRevue)
);
INSERT INTO Code(rang) SELECT * FROM(
   SELECT DISTINCT rang FROM Jalon WHERE libelle LIKE '%Revue%')d

/*****Bieen**********Soutenance*********************/
CREATE TABLE Soutenance(
   rang INT,
   titre VARCHAR(50),
   consigne VARCHAR(50),
   FOREIGN KEY(rang) REFERENCES Jalon(rang)
);
INSERT INTO Soutenance(rang) SELECT * FROM(
   SELECT DISTINCT rang FROM Jalon WHERE libelle LIKE '%Soutenance%')d


/***********est_cree_de**************/
CREATE TABLE est_cree_de(
   idp_1  BIGINT (20),
   idp BIGINT (20),
   PRIMARY KEY(idp, idp_1),
   FOREIGN KEY(idp) REFERENCES Projet(idp),
   FOREIGN KEY(idp_1) REFERENCES Projet(idp)
)

/***********est_affecte**************/
CREATE TABLE est_affecte(
   equipe VARCHAR(80),
   rang INT,
   idB INT,
   dateA DATE,
   horaire TIME,
   lieu VARCHAR(50),
   PRIMARY KEY(equipe, rang),
   FOREIGN KEY(equipe) REFERENCES Equipe(equipe),
   FOREIGN KEY(rang) REFERENCES Jalon(rang)
);
INSERT INTO est_affecte (equipe,rang) SELECT * FROM (
   SELECT DISTINCT nom_equipe,rang FROM Jalon J JOIN donnees_fournies.instances I ON I.idp=J.idp )p

/****BIEN************inscrit*********************/
CREATE TABLE inscrit(
   numEtu VARCHAR (10),
   code_apoge VARCHAR(50),
   TD VARCHAR(50),
   TP VARCHAR(50),
   annee smallint,
   semestre VARCHAR(10),
   PRIMARY KEY(numEtu, code_apoge,annee,semestre),
   FOREIGN KEY(numEtu) REFERENCES Etudiant(numEtu),
    FOREIGN KEY(code_apoge) REFERENCES UE(code_apoge)
);
INSERT INTO inscrit(numEtu,code_apoge, semestre, annee) SELECT DISTINCT * FROM (
SELECT DISTINCT etudiant1_numetu AS numEtu, code_apoge AS APOGE, semestre AS semestre, annee AS annee
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant2_numetu AS numEtu, code_apoge AS APOGE, semestre AS semestre, annee AS annee
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant3_numetu AS numEtu, code_apoge AS APOGE, semestre AS semestre, annee AS annee
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant4_numetu AS numEtu, code_apoge AS APOGE, semestre AS semestre, annee AS annee
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant5_numetu AS numEtu, code_apoge AS APOGE, semestre AS semestre, annee AS annee
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant6_numetu AS numEtu, code_apoge AS APOGE, semestre AS semestre, annee AS annee
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant7_numetu AS numEtu, code_apoge AS APOGE, semestre AS semestre, annee AS annee
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant8_numetu AS numEtu, code_apoge AS APOGE, semestre AS semestre, annee AS annee
FROM donnees_fournies.instances)a WHERE numEtu IS NOT NULL

/*****B SANS INSERT *********constitue*********************/
CREATE TABLE constitue(
   idEns INT,
   idEqP VARCHAR(80),
   PRIMARY KEY(idEns, idEqP),
   FOREIGN KEY(idEns) REFERENCES Enseignant(idEns),
   FOREIGN KEY(idEqP) REFERENCES EquipePedagogique(idEqP)
);

/*** BIEEEEN***********comprendre*********************/
CREATE TABLE comprendre(
   numEtu VARCHAR (10),
   equipe VARCHAR(80),
   role VARCHAR(50),
   PRIMARY KEY(numEtu, equipe),
   FOREIGN KEY(numEtu) REFERENCES Etudiant(numEtu),
   FOREIGN KEY(equipe) REFERENCES Equipe(equipe)
);
INSERT INTO comprendre(numEtu,equipe)
SELECT * FROM(
SELECT DISTINCT etudiant1_numetu AS numEtu, nom_equipe
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant2_numetu AS numEtu, nom_equipe
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant3_numetu AS numEtu, nom_equipe
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant4_numetu AS numEtu, nom_equipe
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant5_numetu AS numEtu, nom_equipe
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant6_numetu AS numEtu, nom_equipe
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant7_numetu AS numEtu, nom_equipe
FROM donnees_fournies.instances
UNION
SELECT DISTINCT etudiant8_numetu AS numEtu, nom_equipe
FROM donnees_fournies.instances)A where numEtu IS NOT NULL

/*****BIEEEEN***********effectue*********************/
CREATE TABLE effectue(
   equipe VARCHAR(80),
   numReal BIGINT,
   FOREIGN KEY(equipe) REFERENCES Equipe(equipe),
   FOREIGN KEY(numReal) REFERENCES Realisation(numReal)
);
INSERT INTO effectue(equipe, numReal)SELECT * FROM(
  SELECT DISTINCT equipe AS equipe, SUBSTRING(titre_realisation,INSTR(titre_realisation,'.')+1, INSTR(titre_realisation,'pour')-6) AS numReal
FROM donnees_fournies.instances I JOIN p2110758.Equipe E ON E.equipe= I.nom_equipe) e
