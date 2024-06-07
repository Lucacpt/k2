DROP database IF EXISTS GeekFactoryDB;
CREATE database GeekFactoryDB;

USE GeekFactoryDB;

-- Le password verranno crittografate in SHA-256
-- Prima di inserirle nel database

DROP TABLE IF EXISTS UserAccount;
CREATE TABLE UserAccount
(
	email varchar(50) PRIMARY KEY NOT NULL,
    passwordUser varchar(64) NOT NULL, -- Lunghezza SHA-256
	nome varchar(50) NOT NULL,
    cognome varchar(50) NOT NULL,
    indirizzo varchar(50) NOT NULL,
    telefono varchar(15) NOT NULL,
    numero char(16) NOT NULL,
    intestatario varchar(50) NOT NULL,
    CVV char(3) NOT NULL,
    ruolo varchar(16) NOT NULL DEFAULT 'registeredUser'
);

DROP TABLE IF EXISTS Cliente;
CREATE TABLE Cliente
(
	email varchar(50) PRIMARY KEY NOT NULL,
    FOREIGN KEY(email) REFERENCES UserAccount(email) ON UPDATE cascade ON DELETE cascade
);

DROP TABLE IF EXISTS Venditore;
CREATE TABLE Venditore
(
	email varchar(50) PRIMARY KEY NOT NULL,
    feedback int DEFAULT NULL,
    FOREIGN KEY(email) REFERENCES UserAccount(email) ON UPDATE cascade ON DELETE cascade
);

DROP TABLE IF EXISTS Tipologia;
CREATE TABLE Tipologia
(
    nome ENUM('Arredamento Casa','Action Figures','Gadget') PRIMARY KEY NOT NULL
);

DROP TABLE IF EXISTS Prodotto;
CREATE TABLE Prodotto
(
	codice int PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome varchar(50) NOT NULL,
    descrizione text NOT NULL,
    deleted BOOL NOT NULL DEFAULT false,
    prezzo double(10,2) NOT NULL,
    model varchar(200) NOT NULL,
    speseSpedizione double(5,2) DEFAULT 0,
    emailVenditore varchar(50) NOT NULL,
    tag ENUM('Manga/Anime', 'Film/Serie TV', 'Videogiochi', 'Originali') NOT NULL,
    nomeTipologia ENUM('Arredamento Casa','Action Figures','Gadget') NOT NULL,
    dataAnnuncio date NOT NULL,
    FOREIGN KEY(emailVenditore) REFERENCES Venditore(email) ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY(nomeTipologia) REFERENCES Tipologia(nome) ON UPDATE cascade ON DELETE cascade
)ENGINE=InnoDB AUTO_INCREMENT=1000;

DROP TABLE IF EXISTS Ordine;
CREATE TABLE Ordine
(
	codiceOrdine int NOT NULL AUTO_INCREMENT,
    codiceProdotto int NOT NULL,
    emailCliente varchar(50) NOT NULL,
    prezzoTotale double(10,2) NOT NULL,
    quantity int NOT NULL,
    dataAcquisto date NOT NULL,
    PRIMARY KEY(codiceOrdine,codiceProdotto),
    FOREIGN KEY(codiceProdotto) REFERENCES Prodotto(codice) ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY(emailCliente) REFERENCES Cliente(email) ON UPDATE cascade ON DELETE cascade
)ENGINE=InnoDB AUTO_INCREMENT=100;

DROP TABLE IF EXISTS Recensione;
CREATE TABLE Recensione
(
	codiceRecensione int NOT NULL AUTO_INCREMENT,
    codiceProdotto int NOT NULL,
    emailCliente varchar(50) NOT NULL,
    votazione tinyint unsigned NOT NULL,
    testo text,
    dataRecensione date NOT NULL,
    PRIMARY KEY(codiceRecensione,codiceProdotto),
    FOREIGN KEY(codiceProdotto) REFERENCES Prodotto(codice) ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY(emailCliente) REFERENCES Cliente(email) ON UPDATE cascade ON DELETE cascade
);

DROP TABLE IF EXISTS Preferiti;
CREATE TABLE Preferiti
(
	codiceProdotto int NOT NULL,
    emailCliente varchar(50) NOT NULL,
    PRIMARY KEY(codiceProdotto,emailCliente),
    FOREIGN KEY(codiceProdotto) REFERENCES Prodotto(codice) ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY(emailCliente) REFERENCES Cliente(email) ON UPDATE cascade ON DELETE cascade
);

/* Inserimento dati */

/* Account Utente */
INSERT INTO UserAccount (email, passwordUser, nome, cognome, indirizzo, telefono, numero, intestatario, CVV, ruolo)
VALUES 
('geekfactory@gmail.com', SHA2('12345678', 256), 'Geek', 'Factory', 'Unisa, Dipartimento Informatica', '3476549862', '5436724598431234', 'GeekFactory', '476', 'admin'),
('mariorossi@gmail.com', SHA2('12345678', 256), 'Mario', 'Rossi', 'Caserta, Via Lazio 14', '3476549862', '5436724598431234', 'Mario Rossi', '476', 'registeredUser'),
('luigiverdi@gmail.com', SHA2('12345678', 256), 'Luigi', 'Verdi', 'Roma, Via Cesare 17', '3518457668', '6745982476311234', 'Luigi Verdi', '435', 'registeredUser'),
('lorenzobianchi@gmail.com', SHA2('12345678', 256), 'Lorenzo', 'Bianchi', 'Messina, Via Federico Fellini 14', '3474351776', '8791267534971234', 'Lorenzo Bianchi', '143', 'registeredUser'),
('gigiprossi@gmail.com', SHA2('12345678', 256), 'Gigi Pio', 'Rossi', 'Caserta, Via Lazio 14', '3518234671', '7613872515281234', 'Gigi Pio Rossi', '621', 'registeredUser'),
('davidesari@yahoo.com', SHA2('12345678', 256), 'Davide', 'Sari', 'Palermo, Via Libertà 15', '3517628334', '8901034567391234', 'Davide Sari', '165', 'registeredUser'),
('emildcarlo@libero.it', SHA2('12345678', 256), 'Emiliano', 'De Carlo', 'Napoli, Via Superiore 24', '3479228888', '3241768501101234', 'Emiliano De Carlo', '823', 'registeredUser'),
('saraverdi@gmail.com', SHA2('12345678', 256), 'Sara', 'Verdi', 'Pisa, Via Miracoli 73', '3476629882', '6734891203451234', 'Sara Verdi', '820', 'registeredUser'),
('federeale@yahoo.com', SHA2('12345678', 256), 'Federica', 'Reale', 'Torino, Via Gran Paradiso 6', '3517634234', '2367892145781234', 'Federica Reale', '432', 'registeredUser');

/* Clienti */
INSERT INTO Cliente (email) VALUES 
('mariorossi@gmail.com'),
('luigiverdi@gmail.com'),
('lorenzobianchi@gmail.com'),
('gigiprossi@gmail.com'),
('davidesari@yahoo.com'),
('emildcarlo@libero.it'),
('saraverdi@gmail.com'),
('federeale@yahoo.com');

/* Venditori */
INSERT INTO Venditore (email, feedback) VALUES 
('geekfactory@gmail.com', 4);

/* Tipologia */
INSERT INTO Tipologia (nome) VALUES 
('Arredamento Casa'),
('Action Figures'),
('Gadget');

/* Prodotti */
INSERT INTO Prodotto (nome, descrizione, prezzo, model, speseSpedizione, emailVenditore, tag, nomeTipologia, dataAnnuncio)
VALUES 
('Divano Moderno', 'Un divano moderno e confortevole.', 599.99, 'DM101', 19.99, 'geekfactory@gmail.com', 'Originali', 'Arredamento Casa', '2024-06-07'),
('Funko Pop! Naruto', 'Una action figure Funko Pop! di Naruto.', 12.99, 'FPN101', 6.99, 'geekfactory@gmail.com', 'Manga/Anime', 'Action Figures', '2024-06-07'),
('Tazza Avengers', 'Tazza con grafica degli Avengers.', 9.99, 'TAZAV101', 4.99, 'geekfactory@gmail.com', 'Film/Serie TV', 'Gadget', '2024-06-07');

/* Ordini */
INSERT INTO Ordine (codiceProdotto, emailCliente, prezzoTotale, quantity, dataAcquisto)
VALUES 
(1000, 'mariorossi@gmail.com', 599.99, 1, '2024-06-07'),
(1001, 'luigiverdi@gmail.com', 12.99, 1, '2024-06-07'),
(1002, 'lorenzobianchi@gmail.com', 9.99, 2, '2024-06-07');

/* Recensioni */
INSERT INTO Recensione (codiceProdotto, emailCliente, votazione, testo, dataRecensione)
VALUES 
(1000, 'mariorossi@gmail.com', 5, 'Bellissimo divano, molto comodo!', '2024-06-07'),
(1001, 'luigiverdi@gmail.com', 4, 'Molto carino, mi piace!', '2024-06-07'),
(1002, 'lorenzobianchi@gmail.com', 3, 'Bella tazza, ma un po\' piccola.', '2024-06-07');

/* Preferiti */
INSERT INTO Preferiti (codiceProdotto, emailCliente)
VALUES 
(1000, 'mariorossi@gmail.com'),
(1001, 'luigiverdi@gmail.com');

COMMIT;
