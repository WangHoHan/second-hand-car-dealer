DROP TABLE IF EXISTS Sprzedaż, [Posiadanie Model-Silnik], [Posiadanie Dodatkowe Wyposażenie-Samochód], Samochód, Profil, Osobowy, Ciężarowy, Model, Silnik, Marka, Klient, [Dodatkowe Wyposażenie], Dealer;
CREATE TABLE Dealer
(
    nazwa VARCHAR(30) NOT NULL CONSTRAINT pk_dealer_nazwa PRIMARY KEY, 
    adres VARCHAR(50)
);
CREATE TABLE [Dodatkowe Wyposażenie]
(
    nazwa VARCHAR(30) NOT NULL CONSTRAINT pk_dodatkowe_wyposażenie_nazwa PRIMARY KEY
);
CREATE TABLE Klient
(
    id INT NOT NULL IDENTITY(1,1) CONSTRAINT pk_klient_id PRIMARY KEY, 
    imię VARCHAR(30) CONSTRAINT ck_klient_imię CHECK (imię LIKE '[A-Z]%'), 
    nazwisko VARCHAR(30) CONSTRAINT ck_klient_nazwisko CHECK (nazwisko LIKE '[A-Z]%'), 
    [numer telefonu] VARCHAR(15)
);
CREATE TABLE Marka
(
    nazwa VARCHAR(30) NOT NULL CONSTRAINT pk_marka_nazwa PRIMARY KEY, 
    [rok założenia] INT CONSTRAINT ck_marka_rok_założenia CHECK ([rok założenia] <= 2020)
);
CREATE TABLE Silnik
(
    identyfikator INT NOT NULL IDENTITY(1,1) CONSTRAINT pk_silnik_identyfikator PRIMARY KEY, 
    [opis parametrów] TEXT, 
    [rodzaj paliwa] VARCHAR(30)
);
CREATE TABLE Model
(
    identyfikator INT NOT NULL IDENTITY(1,1) CONSTRAINT pk_model_identyfikator PRIMARY KEY, 
    nazwa VARCHAR(30), 
    [rok wprowadzenia na rynek] INT CONSTRAINT ck_model_rok_wprowadzenia_na_rynek CHECK ([rok wprowadzenia na rynek] <= 2020), 
    Model_identyfikator_poprzednik INT NULL, 
    Marka_nazwa VARCHAR(30) NOT NULL, 
    CONSTRAINT fk_model_model_identyfikator_poprzednik FOREIGN KEY (Model_identyfikator_poprzednik) REFERENCES Model(identyfikator), 
    CONSTRAINT fk_model_marka_nazwa FOREIGN KEY (Marka_nazwa) REFERENCES Marka(nazwa)
);
CREATE UNIQUE INDEX indunique ON Model(Model_identyfikator_poprzednik) WHERE Model_identyfikator_poprzednik IS NOT NULL;
CREATE TABLE Ciężarowy
(
    Model_identyfikator INT NOT NULL CONSTRAINT pk_ciężarowy_model_identyfikator PRIMARY KEY, 
    ładowność VARCHAR(30), 
    CONSTRAINT fk_ciężarowy_model_identyfikator FOREIGN KEY (Model_identyfikator) REFERENCES Model(identyfikator)
);
CREATE TABLE Osobowy
(
    Model_identyfikator INT NOT NULL CONSTRAINT pk_osobowy_model_identyfikator PRIMARY KEY, 
    [liczba pasażerów] INT, 
    [pojemność bagażnika] VARCHAR(30), 
    CONSTRAINT fk_osobowy_model_identyfikator FOREIGN KEY (Model_identyfikator) REFERENCES Model(identyfikator)
);
CREATE TABLE Profil
(
    Dealer_nazwa VARCHAR(30) NOT NULL, 
    Model_identyfikator INT NOT NULL, 
    CONSTRAINT pk_profil_dealer_nazwa_model_identyfikator PRIMARY KEY(Dealer_nazwa, Model_identyfikator), 
    CONSTRAINT fk_profil_dealer_nazwa FOREIGN KEY (Dealer_nazwa) REFERENCES Dealer(nazwa), 
    CONSTRAINT fk_profil_model_identyfikator FOREIGN KEY (Model_identyfikator) REFERENCES Model(identyfikator)
);
CREATE TABLE Samochód
(
	VIN VARCHAR(17) NOT NULL CONSTRAINT pk_samochód_vin PRIMARY KEY, 
    [kraj pochodzenia] VARCHAR(30), 
    przebieg INT, 
    [rok produkcji] INT CONSTRAINT ck_samochód_rok_produkcji CHECK ([rok produkcji] <= 2020), 
    [skrzynia biegów] VARCHAR(30), 
    Dealer_nazwa VARCHAR(30), 
    Model_identyfikator INT NOT NULL, 
    Silnik_identyfikator INT NOT NULL, 
    CONSTRAINT fk_samochód_dealer_nazwa FOREIGN KEY (Dealer_nazwa) REFERENCES Dealer(nazwa), 
    CONSTRAINT fk_samochód_model_identyfikator FOREIGN KEY (Model_identyfikator) REFERENCES Model(identyfikator), 
    CONSTRAINT fk_samochód_silnik_identyfikator FOREIGN KEY (Silnik_identyfikator) REFERENCES Silnik(identyfikator)
);
CREATE TABLE [Posiadanie Dodatkowe Wyposażenie-Samochód]
(
    Dodatkowe_Wyposażenie_nazwa VARCHAR(30) NOT NULL, 
    Samochód_VIN VARCHAR(17) NOT NULL, 
    CONSTRAINT pk_posiadanie_dodatkowe_wyposażenie_samochód_dodatkowe_wyposażenie_nazwa_samochód_vin PRIMARY KEY(Dodatkowe_Wyposażenie_nazwa, Samochód_VIN), 
    CONSTRAINT fk_posiadanie_dodatkowe_wyposażenie_samochód_dodatkowe_wyposażenie_nazwa FOREIGN KEY (Dodatkowe_Wyposażenie_nazwa) REFERENCES [Dodatkowe Wyposażenie](nazwa), 
    CONSTRAINT fk_posiadanie_dodatkowe_wyposażenie_samochód_samochód_vin FOREIGN KEY (Samochód_VIN) REFERENCES Samochód(VIN)
);
CREATE TABLE [Posiadanie Model-Silnik]
(
    Model_identyfikator INT NOT NULL, 
    Silnik_identyfikator  INT NOT NULL, 
    CONSTRAINT pk_posiadanie_model_silnik_model_identyfikator_silnik_identyfikator PRIMARY KEY(Model_identyfikator, Silnik_identyfikator), 
    CONSTRAINT fk_posiadanie_model_silnik_model_identyfikator FOREIGN KEY (Model_identyfikator) REFERENCES Model(identyfikator), 
    CONSTRAINT fk_posiadanie_model_silnik_silnik_identyfikator FOREIGN KEY (Silnik_identyfikator) REFERENCES Silnik(identyfikator)
);
CREATE TABLE Sprzedaż
(
	Samochód_VIN VARCHAR(17) NOT NULL, 
	[data] DATETIME NOT NULL, 
    cena MONEY, 
    Dealer_nazwa VARCHAR(30) NOT NULL, 
    Klient_id INT NOT NULL, 
    CONSTRAINT pk_sprzedaż_data_samochód_vin PRIMARY KEY([data], Samochód_VIN), 
    CONSTRAINT fk_sprzedaż_samochód_vin FOREIGN KEY (Samochód_VIN) REFERENCES Samochód(VIN), 
    CONSTRAINT fk_sprzedaż_dealer_nazwa FOREIGN KEY (Dealer_nazwa) REFERENCES Dealer(nazwa), 
    CONSTRAINT fk_sprzedaż_klient_id FOREIGN KEY (Klient_id) REFERENCES Klient(id)
);
INSERT INTO Dealer VALUES
('Dealer Nowak', 'ul. Kwiatowa 4 Poznań'), 
('Dealer Kowalski', 'ul. Szkolna 35 Wrocław'), 
('Dealer Pieprzyk', 'ul. Leśna 10 Łódź'), 
('Dealer Jakubowski', 'ul. Krótka 2 Białystok');
INSERT INTO [Dodatkowe Wyposażenie] VALUES
('Radio'), 
('Klimatyzacja'), 
('GPS'), 
('Skórzane fotele');
INSERT INTO Klient VALUES
('Jan', 'Wójcik', '+48 123 456 789'), 
('Jakub', 'Polak', '+48 321 654 987'), 
('Michał', 'Lemańczuk', '+48 789 456 123'), 
('Paweł', 'Janus', '+48 789 123 456');
INSERT INTO Marka VALUES
('Opel', 1862), 
('Ford', 1903), 
('Subaru', 1953), 
('BMW', 1916);
INSERT INTO Silnik VALUES
('100 KM', 'LPG'), 
('114 KM', 'Biodiesel'), 
('350 KM', 'Benzyna'), 
('70 KM', 'Olej napędowy');
INSERT INTO Model VALUES
('Impreza I', 1993, NULL, 'Subaru'), 
('Impreza II', 2000, 1, 'Subaru'), 
('Vivaro', 2001, NULL, 'Opel'), 
('Transit', 1953, NULL, 'Ford');
INSERT INTO Ciężarowy VALUES
(3, '4000 l'), 
(4, '7000 l');
INSERT INTO Osobowy VALUES
(1, 5, '385 l'), 
(2, 5, '450 l');
INSERT INTO Profil VALUES
('Dealer Nowak', 1), 
('Dealer Nowak', 2), 
('Dealer Pieprzyk', 3), 
('Dealer Jakubowski', 4);
INSERT INTO Samochód VALUES
('1GCEK19R4XR105721', 'Japonia', 380456, 1994, 'manualna', 'Dealer Nowak', 1, 3), 
('1G2ZH361874244245', 'Japonia', 150443, 1993, 'manualna', 'Dealer Nowak', 1, 3), 
('5B4HP32Y9X3308303', 'Niemcy', 80123, 2001, 'automatyczna', 'Dealer Pieprzyk', 3, 2), 
('4S3BMBH63C3020795', 'Stany Zjednoczone', 200541, 1956, 'manualna', 'Dealer Jakubowski', 4, 3);
INSERT INTO [Posiadanie Dodatkowe Wyposażenie-Samochód] VALUES
('Radio', '1GCEK19R4XR105721'), 
('Klimatyzacja', '1GCEK19R4XR105721'), 
('Radio', '1G2ZH361874244245'), 
('GPS', '5B4HP32Y9X3308303');
INSERT INTO [Posiadanie Model-Silnik] VALUES
(1, 3), 
(2, 3), 
(3, 2), 
(4, 3);
INSERT INTO Sprzedaż VALUES
('1GCEK19R4XR105721', '1999-10-13 12:45:16', 80000, 'Dealer Nowak', 1), 
('1GCEK19R4XR105721', '2001-01-25 08:10:44', 55000, 'Dealer Nowak', 1), 
('1G2ZH361874244245', '1995-06-05 09:33:01', 77000, 'Dealer Nowak', 2), 
('5B4HP32Y9X3308303', '2005-09-22 17:01:05', 40500, 'Dealer Pieprzyk', 3), 
('4S3BMBH63C3020795', '1964-02-01 15:00:03', 31800, 'Dealer Jakubowski', 4);