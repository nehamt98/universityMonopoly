-- Populating the tables with inital state

INSERT INTO Tokens
VALUES ('Mortarboard'), ('Book'), ('Certificate'), ('Gown'), (' Laptop'), ('Pen');


INSERT INTO Locations
VALUES
(1, 'welcome_week', 'Specials'), (2, 'kilburn', 'Buildings'), (3, 'it', 'Buildings'),
(4, 'hearing_1', 'Specials'), (5, 'uni_place', 'Buildings'), (6, 'ambs', 'Buildings'),
(7, 'rag_1', 'Specials'), (8, 'suspension', 'Specials'), (9, 'crawford', 'Buildings'),
(10, 'sugden', 'Buildings'), (11, 'ali_g', 'Specials'), (12, 'shopping_precint', 'Buildings'),
(13, 'mecd', 'Buildings'), (14, 'rag_2', 'Specials'), (15, 'library', 'Buildings'),
(16, 'sam_alex', 'Buildings'), (17, 'hearing_2', 'Specials'), (18, 'youre_suspended', 'Specials'),
(19, 'museum', 'Buildings'), (20, 'whitworth_hall', 'Buildings');

INSERT INTO Buildings
VALUES
(2, 15, NULL, 0), (3, 15, NULL, 0), (5, 25, NULL, 0), (6, 25, NULL, 0),
(9, 30, NULL, 0), (10, 30, NULL, 0), (12, 35, NULL, 0), (13, 35, NULL, 0),
(15, 40, NULL, 0), (16, 40, NULL, 0), (19, 50, NULL, 0), (20, 50, NULL, 0);


INSERT INTO Specials
VALUES
(1, 'Awarded 100cr.'), (4, 'You are found guilty of academic malpractice. Fined 20cr.'),
(7, 'You win a fancy dress competition. Awarded 15cr.'), (8, 'Suspension'),
(11, 'Free Resting.'), (14, 'You receive a bursary and share it with your friends. Give all other players 10cr.'),
(17, 'You are in rent arrears. Fined 25cr.'), (18, 'You are suspended.');

