-- AskMyDB demo database (Chinook-inspired music store)

CREATE TABLE IF NOT EXISTS "Artist" (
    "ArtistId" SERIAL PRIMARY KEY,
    "Name" VARCHAR(120)
);

CREATE TABLE IF NOT EXISTS "Album" (
    "AlbumId" SERIAL PRIMARY KEY,
    "Title" VARCHAR(160),
    "ArtistId" INTEGER REFERENCES "Artist"("ArtistId")
);

CREATE TABLE IF NOT EXISTS "Track" (
    "TrackId" SERIAL PRIMARY KEY,
    "Name" VARCHAR(200),
    "AlbumId" INTEGER REFERENCES "Album"("AlbumId"),
    "UnitPrice" NUMERIC(10,2),
    "Milliseconds" INTEGER
);

CREATE TABLE IF NOT EXISTS "Customer" (
    "CustomerId" SERIAL PRIMARY KEY,
    "FirstName" VARCHAR(40),
    "LastName" VARCHAR(20),
    "Country" VARCHAR(40),
    "Email" VARCHAR(60)
);

CREATE TABLE IF NOT EXISTS "Invoice" (
    "InvoiceId" SERIAL PRIMARY KEY,
    "CustomerId" INTEGER REFERENCES "Customer"("CustomerId"),
    "InvoiceDate" TIMESTAMP,
    "Total" NUMERIC(10,2)
);

CREATE TABLE IF NOT EXISTS "InvoiceLine" (
    "InvoiceLineId" SERIAL PRIMARY KEY,
    "InvoiceId" INTEGER REFERENCES "Invoice"("InvoiceId"),
    "TrackId" INTEGER REFERENCES "Track"("TrackId"),
    "UnitPrice" NUMERIC(10,2),
    "Quantity" INTEGER
);

-- Artists
INSERT INTO "Artist" ("Name") VALUES
('AC/DC'), ('Aerosmith'), ('Metallica'), ('Led Zeppelin'), ('Pink Floyd'),
('The Beatles'), ('Rolling Stones'), ('Nirvana'), ('Pearl Jam'), ('U2'),
('Radiohead'), ('David Bowie');

-- Albums (2 per artist)
INSERT INTO "Album" ("Title", "ArtistId") VALUES
('Back in Black', 1), ('Highway to Hell', 1),
('Rocks', 2), ('Toys in the Attic', 2),
('Master of Puppets', 3), ('Metallica', 3),
('Led Zeppelin IV', 4), ('Physical Graffiti', 4),
('The Dark Side of the Moon', 5), ('Wish You Were Here', 5),
('Abbey Road', 6), ('Let It Be', 6),
('Exile on Main St.', 7), ('Sticky Fingers', 7),
('Nevermind', 8), ('In Utero', 8),
('Ten', 9), ('Vs.', 9),
('The Joshua Tree', 10), ('Achtung Baby', 10),
('OK Computer', 11), ('Kid A', 11),
('Ziggy Stardust', 12), ('Heroes', 12);

-- Tracks (3 per album)
INSERT INTO "Track" ("Name", "AlbumId", "UnitPrice", "Milliseconds") VALUES
('Hells Bells', 1, 0.99, 312000), ('Back in Black', 1, 0.99, 255000), ('You Shook Me All Night Long', 1, 0.99, 210000),
('Highway to Hell', 2, 0.99, 208000), ('Girls Got Rhythm', 2, 0.99, 202000), ('Touch Too Much', 2, 0.99, 228000),
('Last Child', 3, 0.99, 192000), ('Back in the Saddle', 3, 0.99, 233000), ('Rats in the Cellar', 3, 0.99, 254000),
('Sweet Emotion', 4, 0.99, 278000), ('Walk This Way', 4, 0.99, 196000), ('Big Ten Inch Record', 4, 0.99, 168000),
('Battery', 5, 0.99, 312000), ('Master of Puppets', 5, 0.99, 514000), ('Orion', 5, 0.99, 508000),
('Enter Sandman', 6, 0.99, 331000), ('Sad but True', 6, 0.99, 324000), ('Nothing Else Matters', 6, 0.99, 388000),
('Black Dog', 7, 0.99, 294000), ('Rock and Roll', 7, 0.99, 220000), ('Stairway to Heaven', 7, 2.99, 481000),
('Kashmir', 8, 1.99, 508000), ('Trampled Under Foot', 8, 0.99, 333000), ('Houses of the Holy', 8, 0.99, 243000),
('Money', 9, 0.99, 382000), ('Time', 9, 0.99, 421000), ('Brain Damage', 9, 0.99, 228000),
('Shine On You Crazy Diamond', 10, 0.99, 836000), ('Welcome to the Machine', 10, 0.99, 441000), ('Wish You Were Here', 10, 0.99, 334000),
('Come Together', 11, 0.99, 259000), ('Something', 11, 0.99, 182000), ('Here Comes the Sun', 11, 0.99, 185000),
('Two of Us', 12, 0.99, 217000), ('Let It Be', 12, 0.99, 243000), ('The Long and Winding Road', 12, 0.99, 218000),
('Tumbling Dice', 13, 0.99, 231000), ('Happy', 13, 0.99, 214000), ('Loving Cup', 13, 0.99, 251000),
('Brown Sugar', 14, 0.99, 229000), ('Wild Horses', 14, 0.99, 342000), ('Can''t You Hear Me Knocking', 14, 0.99, 427000),
('Smells Like Teen Spirit', 15, 0.99, 301000), ('Come as You Are', 15, 0.99, 219000), ('Lithium', 15, 0.99, 256000),
('Heart-Shaped Box', 16, 0.99, 280000), ('All Apologies', 16, 0.99, 231000), ('Dumb', 16, 0.99, 143000),
('Once', 17, 0.99, 235000), ('Alive', 17, 0.99, 355000), ('Even Flow', 17, 0.99, 284000),
('Daughter', 18, 0.99, 237000), ('Black', 18, 0.99, 351000), ('Jeremy', 18, 0.99, 312000),
('Where the Streets Have No Name', 19, 0.99, 276000), ('I Still Haven''t Found What I''m Looking For', 19, 0.99, 281000), ('With or Without You', 19, 0.99, 295000),
('Zoo Station', 20, 0.99, 263000), ('Even Better Than the Real Thing', 20, 0.99, 221000), ('One', 20, 0.99, 271000),
('Airbag', 21, 0.99, 284000), ('Paranoid Android', 21, 0.99, 383000), ('Karma Police', 21, 0.99, 264000),
('Everything in Its Right Place', 22, 0.99, 249000), ('How to Disappear Completely', 22, 0.99, 354000), ('Idioteque', 22, 0.99, 261000),
('Moonage Daydream', 23, 0.99, 320000), ('Starman', 23, 0.99, 254000), ('Ziggy Stardust', 23, 0.99, 193000),
('Heroes', 24, 0.99, 366000), ('Sons of the Silent Age', 24, 0.99, 234000), ('Blackout', 24, 0.99, 221000);

-- Customers
INSERT INTO "Customer" ("FirstName", "LastName", "Country", "Email") VALUES
('Luís', 'Gonçalves', 'Brazil', 'luisg@example.com'),
('Leonie', 'Köhler', 'Germany', 'leoniek@example.com'),
('François', 'Tremblay', 'Canada', 'francoT@example.com'),
('Bjørn', 'Hansen', 'Norway', 'bjornh@example.com'),
('František', 'Wichterlová', 'Czech Republic', 'frantaw@example.com'),
('Helena', 'Holý', 'Czech Republic', 'helenh@example.com'),
('Astrid', 'Gruber', 'Austria', 'astridg@example.com'),
('Daan', 'Peeters', 'Belgium', 'daanp@example.com'),
('Kara', 'Nielsen', 'Denmark', 'karan@example.com'),
('Eduardo', 'Martins', 'Brazil', 'eduardom@example.com'),
('Alexandre', 'Rocha', 'Brazil', 'alexandrer@example.com'),
('Roberto', 'Almeida', 'Brazil', 'robertoa@example.com'),
('Fernanda', 'Ramos', 'Brazil', 'fernandar@example.com'),
('Mark', 'Philips', 'Canada', 'markp@example.com'),
('Jennifer', 'Peterson', 'Canada', 'jenniferp@example.com'),
('Frank', 'Harris', 'USA', 'frankh@example.com'),
('Jack', 'Smith', 'USA', 'jacks@example.com'),
('Michelle', 'Brooks', 'USA', 'michelleb@example.com'),
('Tim', 'Goyer', 'USA', 'timg@example.com'),
('Dan', 'Miller', 'USA', 'danm@example.com');

-- Invoices (spread across 2019-2022)
INSERT INTO "Invoice" ("CustomerId", "InvoiceDate", "Total") VALUES
(1,  '2019-01-13', 1.98), (2,  '2019-01-15', 3.96), (3,  '2019-02-08', 5.94),
(4,  '2019-03-05', 0.99), (5,  '2019-03-18', 1.98), (6,  '2019-04-21', 13.86),
(7,  '2019-05-06', 8.91), (8,  '2019-06-11', 1.98), (9,  '2019-07-02', 3.96),
(10, '2019-08-17', 5.94), (11, '2019-09-03', 0.99), (12, '2019-10-14', 1.98),
(13, '2019-11-20', 13.86),(14, '2019-12-07', 8.91), (15, '2020-01-22', 1.98),
(16, '2020-02-09', 3.96), (17, '2020-03-14', 5.94), (18, '2020-04-25', 0.99),
(19, '2020-05-30', 1.98), (20, '2020-06-16', 13.86),(1,  '2020-07-08', 8.91),
(2,  '2020-08-01', 1.98), (3,  '2020-09-12', 3.96), (4,  '2020-10-29', 5.94),
(5,  '2020-11-18', 0.99), (6,  '2020-12-03', 1.98), (7,  '2021-01-19', 13.86),
(8,  '2021-02-14', 8.91), (9,  '2021-03-07', 1.98), (10, '2021-04-22', 3.96),
(11, '2021-05-11', 5.94), (12, '2021-06-28', 0.99), (13, '2021-07-15', 1.98),
(14, '2021-08-03', 13.86),(15, '2021-09-24', 8.91), (16, '2021-10-10', 1.98),
(17, '2021-11-01', 3.96), (18, '2021-12-18', 5.94), (19, '2022-01-09', 0.99),
(20, '2022-02-27', 1.98), (1,  '2022-03-13', 13.86),(2,  '2022-04-06', 8.91),
(3,  '2022-05-21', 1.98), (4,  '2022-06-04', 3.96), (5,  '2022-07-17', 5.94),
(6,  '2022-08-30', 0.99), (7,  '2022-09-12', 1.98), (8,  '2022-10-05', 13.86),
(9,  '2022-11-22', 8.91), (10, '2022-12-09', 1.98);

-- InvoiceLines (linking invoices to tracks)
INSERT INTO "InvoiceLine" ("InvoiceId", "TrackId", "UnitPrice", "Quantity") VALUES
(1,1,0.99,1),(1,2,0.99,1),(2,3,0.99,1),(2,4,0.99,1),(2,5,0.99,1),(2,6,0.99,1),
(3,7,0.99,1),(3,8,0.99,1),(3,9,0.99,1),(3,10,0.99,1),(3,11,0.99,1),(3,12,0.99,1),
(4,13,0.99,1),(5,14,0.99,1),(5,15,0.99,1),(6,16,0.99,1),(6,17,0.99,1),(6,18,0.99,1),
(6,19,0.99,1),(6,20,0.99,1),(6,21,0.99,1),(6,22,0.99,1),(6,23,0.99,1),(6,24,0.99,1),
(6,25,0.99,1),(6,26,0.99,1),(6,27,0.99,1),(6,28,0.99,1),(7,29,0.99,1),(7,30,0.99,1),
(7,31,0.99,1),(7,32,0.99,1),(7,33,0.99,1),(7,34,0.99,1),(7,35,0.99,1),(7,36,0.99,1),
(7,37,0.99,1),(8,38,0.99,1),(8,39,0.99,1),(9,40,0.99,1),(9,41,0.99,1),(9,42,0.99,1),
(9,43,0.99,1),(10,44,0.99,1),(10,45,0.99,1),(10,46,0.99,1),(10,47,0.99,1),(10,48,0.99,1),
(10,49,0.99,1),(11,50,0.99,1),(12,51,0.99,1),(12,52,0.99,1),(13,53,0.99,1),(13,54,0.99,1),
(13,55,0.99,1),(13,56,0.99,1),(13,57,0.99,1),(13,58,0.99,1),(13,59,0.99,1),(13,60,0.99,1),
(13,61,0.99,1),(13,62,0.99,1),(13,63,0.99,1),(13,64,0.99,1),(13,65,0.99,1),(13,66,0.99,1),
(14,67,0.99,1),(14,68,0.99,1),(14,69,0.99,1),(14,70,0.99,1),(14,71,0.99,1),(14,72,0.99,1),
(14,1,0.99,1),(14,2,0.99,1),(14,3,0.99,1),(15,1,0.99,1),(15,5,0.99,1),(16,10,0.99,1),
(16,15,0.99,1),(16,20,0.99,1),(16,25,0.99,1),(17,30,0.99,1),(17,35,0.99,1),(17,40,0.99,1),
(17,45,0.99,1),(17,50,0.99,1),(17,55,0.99,1),(18,60,0.99,1),(19,65,0.99,1),(19,70,0.99,1),
(20,1,0.99,1),(20,8,0.99,1),(20,15,0.99,1),(20,22,0.99,1),(20,29,0.99,1),(20,36,0.99,1),
(20,43,0.99,1),(20,50,0.99,1),(20,57,0.99,1),(20,64,0.99,1),(20,71,0.99,1),(20,72,0.99,1),
(20,4,0.99,1),(20,5,0.99,1);
