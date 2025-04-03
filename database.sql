BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "AllTimeScores" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"total_points"	INTEGER,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "Users"("user_id")
);
CREATE TABLE IF NOT EXISTS "Contests" (
	"contest_id"	INTEGER,
	"duration"	INTEGER,
	"status"	TEXT,
	"start_time"	DATETIME,
	"end_time"	DATETIME,
	PRIMARY KEY("contest_id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "ContestsScores" (
	"contest_score_id"	INTEGER NOT NULL,
	"contest_id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"total_points"	INTEGER,
	PRIMARY KEY("contest_score_id" AUTOINCREMENT),
	FOREIGN KEY("contest_id") REFERENCES "Contests"("contest_id"),
	FOREIGN KEY("user_id") REFERENCES "Users"("user_id")
);
CREATE TABLE IF NOT EXISTS "Problems" (
	"problem_id"	INTEGER,
	"title"	TEXT NOT NULL,
	"description"	TEXT NOT NULL,
	"example_input"	TEXT NOT NULL,
	"example_output"	TEXT NOT NULL,
	PRIMARY KEY("problem_id" AUTOINCREMENT)
);
CREATE TABLE IF NOT EXISTS "Submissions" (
	"submission_id"	INTEGER,
	"user_id"	INTEGER NOT NULL,
	"problem_id"	INTEGER NOT NULL,
	"submission_source"	TEXT NOT NULL,
	"submission_time"	DATETIME,
	PRIMARY KEY("submission_id" AUTOINCREMENT),
	FOREIGN KEY("problem_id") REFERENCES "Problems"("problem_id"),
	FOREIGN KEY("user_id") REFERENCES "Users"("user_id")
);
CREATE TABLE IF NOT EXISTS "Tests" (
	"test_id"	INTEGER,
	"problem_id"	INTEGER NOT NULL,
	"input_file"	TEXT NOT NULL,
	"output_file"	TEXT NOT NULL,
	PRIMARY KEY("test_id" AUTOINCREMENT),
	FOREIGN KEY("problem_id") REFERENCES "Problems"("problem_id")
);
CREATE TABLE IF NOT EXISTS "TestsResults" (
	"result_id"	INTEGER NOT NULL,
	"submission_id"	INTEGER NOT NULL,
	"test_id"	INTEGER NOT NULL,
	"status"	TEXT,
	"points"	INTEGER,
	PRIMARY KEY("result_id" AUTOINCREMENT),
	FOREIGN KEY("submission_id") REFERENCES "Submissions"("submission_id"),
	FOREIGN KEY("test_id") REFERENCES "Tests"("test_id")
);
CREATE TABLE IF NOT EXISTS "Users" (
	"user_id"	INTEGER NOT NULL,
	"username"	TEXT NOT NULL UNIQUE,
	"role"	TEXT NOT NULL,
	PRIMARY KEY("user_id" AUTOINCREMENT)
);
INSERT INTO "AllTimeScores" VALUES (4,2,140);
INSERT INTO "AllTimeScores" VALUES (5,5,500);
INSERT INTO "AllTimeScores" VALUES (6,4,0);
INSERT INTO "AllTimeScores" VALUES (7,1,600);
INSERT INTO "Contests" VALUES (4,5,'ended','2025-01-14 17:12:37','2025-01-14 17:17:37');
INSERT INTO "Contests" VALUES (5,5,'ended','2025-01-14 17:20:42','2025-01-14 17:25:42');
INSERT INTO "Contests" VALUES (6,4,'ended','2025-01-14 17:22:48','2025-01-14 17:26:48');
INSERT INTO "Contests" VALUES (7,20,'ended','2025-01-14 17:32:59','2025-01-14 17:52:59');
INSERT INTO "Contests" VALUES (8,15,'ended','2025-01-14 20:03:29','2025-01-14 20:18:29');
INSERT INTO "Contests" VALUES (9,15,'ended','2025-01-14 20:08:26','2025-01-14 20:23:26');
INSERT INTO "Contests" VALUES (10,5,'ended','2025-01-14 20:48:15','2025-01-14 20:53:15');
INSERT INTO "Contests" VALUES (11,1,'ended','2025-01-14 20:50:25','2025-01-14 20:51:25');
INSERT INTO "Contests" VALUES (12,30,'ended','2025-01-14 23:10:53','2025-01-14 23:40:53');
INSERT INTO "Contests" VALUES (13,10,'ended','2025-01-14 23:12:51','2025-01-14 23:22:51');
INSERT INTO "Contests" VALUES (14,30,'ended','2025-01-14 23:18:13','2025-01-14 23:48:13');
INSERT INTO "Contests" VALUES (15,15,'ended','2025-01-14 23:22:50','2025-01-14 23:37:50');
INSERT INTO "Contests" VALUES (16,15,'ended','2025-01-14 23:34:56','2025-01-14 23:49:56');
INSERT INTO "Contests" VALUES (17,15,'ended','2025-01-14 23:37:54','2025-01-14 23:52:54');
INSERT INTO "Contests" VALUES (18,15,'ended','2025-01-14 23:39:01','2025-01-14 23:54:01');
INSERT INTO "Contests" VALUES (19,5,'ended','2025-01-14 23:40:45','2025-01-14 23:45:45');
INSERT INTO "Contests" VALUES (20,10,'ended','2025-01-14 23:42:32','2025-01-14 23:52:32');
INSERT INTO "Contests" VALUES (21,15,'ended','2025-01-14 23:45:50','2025-01-15 00:00:50');
INSERT INTO "Contests" VALUES (22,5,'ended','2025-01-14 23:50:50','2025-01-14 23:55:50');
INSERT INTO "Contests" VALUES (23,5,'ended','2025-01-14 23:52:41','2025-01-14 23:57:41');
INSERT INTO "Contests" VALUES (24,5,'ended','2025-01-14 23:57:18','2025-01-15 00:02:18');
INSERT INTO "Contests" VALUES (25,5,'ended','2025-01-15 00:01:12','2025-01-15 00:06:12');
INSERT INTO "Contests" VALUES (26,15,'ended','2025-01-15 00:10:45','2025-01-15 00:25:45');
INSERT INTO "Contests" VALUES (27,15,'ended','2025-01-15 00:11:58','2025-01-15 00:26:58');
INSERT INTO "Contests" VALUES (28,5,'ended','2025-01-15 00:15:39','2025-01-15 00:20:39');
INSERT INTO "Contests" VALUES (29,5,'ended','2025-01-15 00:30:54','2025-01-15 00:35:54');
INSERT INTO "Contests" VALUES (30,5,'ended','2025-01-15 00:33:49','2025-01-15 00:38:49');
INSERT INTO "Contests" VALUES (31,5,'ended','2025-01-15 00:36:27','2025-01-15 00:41:27');
INSERT INTO "Contests" VALUES (32,10,'ended','2025-01-15 00:40:30','2025-01-15 00:50:30');
INSERT INTO "Contests" VALUES (33,15,'ended','2025-01-15 00:42:12','2025-01-15 00:57:12');
INSERT INTO "Contests" VALUES (34,5,'ended','2025-01-15 00:44:33','2025-01-15 00:49:33');
INSERT INTO "Contests" VALUES (35,5,'ended','2025-01-15 00:45:46','2025-01-15 00:50:46');
INSERT INTO "Contests" VALUES (36,15,'ended','2025-01-15 00:49:52','2025-01-15 01:04:52');
INSERT INTO "Contests" VALUES (37,5,'ended','2025-01-15 00:52:03','2025-01-15 00:57:03');
INSERT INTO "Contests" VALUES (38,5,'ended','2025-01-15 01:18:55','2025-01-15 01:23:55');
INSERT INTO "Contests" VALUES (39,10,'ended','2025-01-15 01:24:11','2025-01-15 01:34:11');
INSERT INTO "Contests" VALUES (40,10,'ended','2025-01-15 01:52:49','2025-01-15 02:02:49');
INSERT INTO "Contests" VALUES (41,15,'ended','2025-01-15 01:58:55','2025-01-15 02:13:55');
INSERT INTO "Contests" VALUES (42,5,'ended','2025-01-15 02:02:00','2025-01-15 02:07:00');
INSERT INTO "Contests" VALUES (43,10,'ended','2025-01-15 02:12:16','2025-01-15 02:22:16');
INSERT INTO "Contests" VALUES (44,10,'ended','2025-01-15 02:14:16','2025-01-15 02:24:16');
INSERT INTO "Contests" VALUES (45,10,'ended','2025-01-15 02:33:29','2025-01-15 02:43:29');
INSERT INTO "Contests" VALUES (46,20,'ended','2025-01-15 02:41:07','2025-01-15 03:01:07');
INSERT INTO "Contests" VALUES (47,15,'ended','2025-01-15 02:44:55','2025-01-15 02:59:55');
INSERT INTO "Contests" VALUES (48,10,'ended','2025-01-15 02:48:45','2025-01-15 02:58:45');
INSERT INTO "Contests" VALUES (49,55,'ended','2025-01-15 03:24:46','2025-01-15 04:19:46');
INSERT INTO "Contests" VALUES (50,15,'ended','2025-01-15 04:22:12','2025-01-15 04:37:12');
INSERT INTO "Contests" VALUES (51,15,'ended','2025-01-15 04:40:42','2025-01-15 04:55:42');
INSERT INTO "Contests" VALUES (52,10,'ended','2025-01-15 04:49:53','2025-01-15 04:59:53');
INSERT INTO "Contests" VALUES (53,10,'ended','2025-01-15 04:53:28','2025-01-15 05:03:28');
INSERT INTO "Contests" VALUES (54,10,'ended','2025-01-15 05:00:03','2025-01-15 05:10:03');
INSERT INTO "Contests" VALUES (55,10,'ended','2025-01-15 05:03:05','2025-01-15 05:13:05');
INSERT INTO "Contests" VALUES (56,20,'ended','2025-01-15 05:03:22','2025-01-15 05:23:22');
INSERT INTO "Contests" VALUES (57,100,'ended','2025-01-15 05:09:10','2025-01-15 06:49:10');
INSERT INTO "Contests" VALUES (58,100,'ended','2025-01-15 05:09:48','2025-01-15 06:49:48');
INSERT INTO "Contests" VALUES (59,100,'ended','2025-01-15 05:12:12','2025-01-15 06:52:12');
INSERT INTO "ContestsScores" VALUES (1,40,2,0);
INSERT INTO "ContestsScores" VALUES (2,41,2,0);
INSERT INTO "ContestsScores" VALUES (3,41,2,0);
INSERT INTO "ContestsScores" VALUES (4,42,2,0);
INSERT INTO "ContestsScores" VALUES (5,43,2,0);
INSERT INTO "ContestsScores" VALUES (6,44,5,100);
INSERT INTO "ContestsScores" VALUES (7,45,5,100);
INSERT INTO "ContestsScores" VALUES (8,45,4,0);
INSERT INTO "ContestsScores" VALUES (9,46,5,100);
INSERT INTO "ContestsScores" VALUES (10,46,4,0);
INSERT INTO "ContestsScores" VALUES (11,47,2,0);
INSERT INTO "ContestsScores" VALUES (12,48,2,0);
INSERT INTO "ContestsScores" VALUES (13,49,2,100);
INSERT INTO "ContestsScores" VALUES (14,49,5,100);
INSERT INTO "ContestsScores" VALUES (15,49,4,0);
INSERT INTO "ContestsScores" VALUES (16,50,5,100);
INSERT INTO "ContestsScores" VALUES (17,51,5,0);
INSERT INTO "ContestsScores" VALUES (18,51,2,0);
INSERT INTO "ContestsScores" VALUES (19,52,2,40);
INSERT INTO "ContestsScores" VALUES (20,53,1,100);
INSERT INTO "ContestsScores" VALUES (21,54,1,100);
INSERT INTO "ContestsScores" VALUES (22,56,1,100);
INSERT INTO "ContestsScores" VALUES (23,57,1,100);
INSERT INTO "ContestsScores" VALUES (24,58,1,100);
INSERT INTO "ContestsScores" VALUES (25,59,1,100);
INSERT INTO "Problems" VALUES (1,'Factorial','Sa se scrie un program care citeste numarul natural n si determina valoarea lui n!.','4','24');
INSERT INTO "Problems" VALUES (2,'Maxprim','Fie un sir de numere, gasiti cel mai mare numar prim din aceasta. Daca nu exista numere prime in lista, afisati -1.','5
10 15 23 7 3
','23');
INSERT INTO "Problems" VALUES (3,'SortMatrix','Fie o matrice patratica a cu n linii si n coloane, Ordonati matricea in mod lexicografic, astfel incat coloanele sa fie sortate lexicografic, ca si cum fiecare coloana ar fi un sir de numere crescator.','3
3 2 1
6 5 4
9 8 7','1 2 3
4 5 6
7 8 9');
INSERT INTO "Submissions" VALUES (27,1,0,'factorial100.cpp','2025-01-15 00:27:48');
INSERT INTO "Submissions" VALUES (28,1,1,'factorial100.cpp','2025-01-15 00:31:11');
INSERT INTO "Submissions" VALUES (29,1,1,'factorial100.cpp','2025-01-15 00:34:00');
INSERT INTO "Submissions" VALUES (30,1,1,'factorial100.cpp','2025-01-15 00:36:55');
INSERT INTO "Submissions" VALUES (31,1,1,'factorial100.cpp','2025-01-15 00:38:31');
INSERT INTO "Submissions" VALUES (32,1,1,'factorial100.cpp','2025-01-15 00:40:40');
INSERT INTO "Submissions" VALUES (33,1,1,'factorial100.cpp','2025-01-15 00:42:23');
INSERT INTO "Submissions" VALUES (34,1,1,'factorial100.cpp','2025-01-15 00:45:10');
INSERT INTO "Submissions" VALUES (35,1,1,'factorial100.cpp','2025-01-15 00:45:56');
INSERT INTO "Submissions" VALUES (36,1,1,'factorial100.cpp','2025-01-15 00:50:08');
INSERT INTO "Submissions" VALUES (37,1,1,'factorial100.cpp','2025-01-15 00:52:18');
INSERT INTO "Submissions" VALUES (38,2,1,'factorial100.cpp','2025-01-15 00:53:02');
INSERT INTO "Submissions" VALUES (39,2,1,'factorial100.cpp','2025-01-15 01:20:52');
INSERT INTO "Submissions" VALUES (40,2,1,'factorial100.cpp','2025-01-15 01:24:32');
INSERT INTO "Submissions" VALUES (41,2,1,'factorial100.cpp','2025-01-15 01:25:19');
INSERT INTO "Submissions" VALUES (42,2,1,'factorial100.cpp','2025-01-15 01:53:04');
INSERT INTO "Submissions" VALUES (43,2,1,'factorial100.cpp','2025-01-15 01:59:26');
INSERT INTO "Submissions" VALUES (44,2,1,'factorial100.cpp','2025-01-15 02:00:09');
INSERT INTO "Submissions" VALUES (45,2,1,'factorial100.cpp','2025-01-15 02:02:17');
INSERT INTO "Submissions" VALUES (46,2,1,'factorial100.cpp','2025-01-15 02:02:26');
INSERT INTO "Submissions" VALUES (47,2,1,'factorial100.cpp','2025-01-15 02:03:19');
INSERT INTO "Submissions" VALUES (48,2,1,'factorial100.cpp','2025-01-15 02:12:44');
INSERT INTO "Submissions" VALUES (49,5,1,'factorial100.cpp','2025-01-15 02:14:33');
INSERT INTO "Submissions" VALUES (50,5,1,'factorial100.cpp','2025-01-15 02:33:54');
INSERT INTO "Submissions" VALUES (51,4,1,'output.txt','2025-01-15 02:35:01');
INSERT INTO "Submissions" VALUES (52,4,1,'client.c','2025-01-15 02:37:34');
INSERT INTO "Submissions" VALUES (53,5,1,'factorial100.cpp','2025-01-15 02:41:53');
INSERT INTO "Submissions" VALUES (54,4,1,'output.txt','2025-01-15 02:42:04');
INSERT INTO "Submissions" VALUES (55,2,1,'factorial100.cpp','2025-01-15 02:45:09');
INSERT INTO "Submissions" VALUES (56,2,1,'factorial100.cpp','2025-01-15 02:48:58');
INSERT INTO "Submissions" VALUES (57,2,1,'factorial100.cpp','2025-01-15 02:49:18');
INSERT INTO "Submissions" VALUES (58,2,1,'factorial100.cpp','2025-01-15 02:50:28');
INSERT INTO "Submissions" VALUES (59,2,1,'client','2025-01-15 02:51:26');
INSERT INTO "Submissions" VALUES (60,2,1,'factorial100.cpp','2025-01-15 03:25:06');
INSERT INTO "Submissions" VALUES (61,2,1,'client','2025-01-15 03:25:19');
INSERT INTO "Submissions" VALUES (62,5,1,'factorial100.cpp','2025-01-15 03:33:54');
INSERT INTO "Submissions" VALUES (63,4,1,'client','2025-01-15 03:35:24');
INSERT INTO "Submissions" VALUES (64,5,2,'maxprim20.cpp','2025-01-15 04:26:22');
INSERT INTO "Submissions" VALUES (65,5,2,'maxprim100.cpp','2025-01-15 04:26:58');
INSERT INTO "Submissions" VALUES (66,5,2,'maxprim60.cpp','2025-01-15 04:27:07');
INSERT INTO "Submissions" VALUES (67,5,2,'maxprim20.cpp','2025-01-15 04:33:54');
INSERT INTO "Submissions" VALUES (68,5,2,'maxprim60.cpp','2025-01-15 04:34:58');
INSERT INTO "Submissions" VALUES (69,5,2,'maxprim100.cpp','2025-01-15 04:35:15');
INSERT INTO "Submissions" VALUES (70,5,3,'sort20.cpp','2025-01-15 04:40:52');
INSERT INTO "Submissions" VALUES (71,5,3,'sort100.cpp','2025-01-15 04:41:05');
INSERT INTO "Submissions" VALUES (72,5,3,'sort40.cpp','2025-01-15 04:41:31');
INSERT INTO "Submissions" VALUES (73,5,3,'sort100.cpp','2025-01-15 04:44:05');
INSERT INTO "Submissions" VALUES (74,2,3,'sort100.cpp','2025-01-15 04:45:56');
INSERT INTO "Submissions" VALUES (75,2,2,'maxprim100.cpp','2025-01-15 04:50:11');
INSERT INTO "Submissions" VALUES (76,2,2,'maxprim80.cpp','2025-01-15 04:50:27');
INSERT INTO "Submissions" VALUES (77,2,2,'maxprim100.cpp','2025-01-15 04:51:56');
INSERT INTO "Submissions" VALUES (78,1,3,'sort20.cpp','2025-01-15 04:53:56');
INSERT INTO "Submissions" VALUES (79,1,3,'sort100.cpp','2025-01-15 04:54:05');
INSERT INTO "Submissions" VALUES (80,1,3,'sort100.cpp','2025-01-15 04:55:16');
INSERT INTO "Submissions" VALUES (81,1,3,'sort100.cpp','2025-01-15 04:55:44');
INSERT INTO "Submissions" VALUES (82,1,3,'sort40.cpp','2025-01-15 04:56:20');
INSERT INTO "Submissions" VALUES (83,1,3,'sort20.cpp','2025-01-15 04:56:28');
INSERT INTO "Submissions" VALUES (84,1,3,'sort100.cpp','2025-01-15 04:57:27');
INSERT INTO "Submissions" VALUES (85,1,3,'sort100.cpp','2025-01-15 04:58:37');
INSERT INTO "Submissions" VALUES (86,1,3,'sort20.cpp','2025-01-15 04:58:50');
INSERT INTO "Submissions" VALUES (87,1,3,'sort20.cpp','2025-01-15 05:00:23');
INSERT INTO "Submissions" VALUES (88,1,3,'sort100.cpp','2025-01-15 05:00:31');
INSERT INTO "Submissions" VALUES (89,1,3,'sort20.cpp','2025-01-15 05:02:29');
INSERT INTO "Submissions" VALUES (90,1,2,'maxprim80.cpp','2025-01-15 05:03:56');
INSERT INTO "Submissions" VALUES (91,1,2,'maxprim100.cpp','2025-01-15 05:04:07');
INSERT INTO "Submissions" VALUES (92,1,2,'maxprim100.cpp','2025-01-15 05:04:37');
INSERT INTO "Submissions" VALUES (93,1,2,'maxprim80.cpp','2025-01-15 05:05:03');
INSERT INTO "Submissions" VALUES (94,1,2,'maxprim100.cpp','2025-01-15 05:05:38');
INSERT INTO "Submissions" VALUES (95,1,2,'maxprim100.cpp','2025-01-15 05:07:51');
INSERT INTO "Submissions" VALUES (96,1,1,'factorial60.cpp','2025-01-15 05:09:23');
INSERT INTO "Submissions" VALUES (97,1,1,'factorial100.cpp','2025-01-15 05:09:40');
INSERT INTO "Submissions" VALUES (98,1,3,'sort60.cpp','2025-01-15 05:10:00');
INSERT INTO "Submissions" VALUES (99,1,3,'sort100.cpp','2025-01-15 05:10:08');
INSERT INTO "Submissions" VALUES (100,1,2,'maxprim100.cpp','2025-01-15 05:12:29');
INSERT INTO "Submissions" VALUES (101,1,2,'maxprim80.cpp','2025-01-15 05:12:41');
INSERT INTO "Submissions" VALUES (102,1,2,'maxprim20.cpp','2025-01-15 05:12:48');
INSERT INTO "Tests" VALUES (1,1,'inputfactorial1.txt','outputfactorial1.txt');
INSERT INTO "Tests" VALUES (2,1,'inputfactorial2.txt','outputfactorial2.txt');
INSERT INTO "Tests" VALUES (3,1,'inputfactorial3.txt','outputfactorial3.txt');
INSERT INTO "Tests" VALUES (4,1,'inputfactorial4.txt','outputfactorial4.txt');
INSERT INTO "Tests" VALUES (5,1,'inputfactorial5.txt','outputfactorial5.txt');
INSERT INTO "Tests" VALUES (6,2,'inputMaxprim1.txt','outputMaxprim1.txt');
INSERT INTO "Tests" VALUES (7,2,'inputMaxprim2.txt','outputMaxprim2.txt');
INSERT INTO "Tests" VALUES (8,2,'inputMaxprim3.txt','outputMaxprim3.txt');
INSERT INTO "Tests" VALUES (9,2,'inputMaxprim4.txt','outputMaxprim4.txt');
INSERT INTO "Tests" VALUES (10,2,'inputMaxprim5.txt','outputMaxprim5.txt');
INSERT INTO "Tests" VALUES (11,3,'inputSort1.txt','outputSort1.txt');
INSERT INTO "Tests" VALUES (12,3,'inputSort2.txt','outputSort2.txt');
INSERT INTO "Tests" VALUES (13,3,'inputSort3.txt','outputSort3.txt');
INSERT INTO "Tests" VALUES (14,3,'inputSort4.txt','outputSort4.txt');
INSERT INTO "Tests" VALUES (15,3,'inputSort5.txt','outputSort5.txt');
INSERT INTO "TestsResults" VALUES (1,37,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (2,37,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (3,37,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (4,37,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (5,37,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (6,38,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (7,38,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (8,38,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (9,38,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (10,38,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (11,39,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (12,39,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (13,39,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (14,39,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (15,39,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (16,40,1,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (17,40,2,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (18,40,3,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (19,40,4,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (20,40,5,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (21,41,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (22,41,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (23,41,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (24,41,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (25,41,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (26,42,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (27,42,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (28,42,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (29,42,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (30,42,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (31,43,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (32,43,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (33,43,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (34,43,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (35,43,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (36,44,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (37,44,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (38,44,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (39,44,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (40,44,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (41,45,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (42,45,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (43,45,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (44,45,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (45,45,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (46,46,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (47,46,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (48,46,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (49,46,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (50,46,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (51,47,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (52,47,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (53,47,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (54,47,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (55,47,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (56,48,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (57,48,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (58,48,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (59,48,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (60,48,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (61,49,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (62,49,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (63,49,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (64,49,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (65,49,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (66,50,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (67,50,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (68,50,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (69,50,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (70,50,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (71,52,1,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (72,52,2,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (73,52,3,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (74,52,4,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (75,52,5,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (76,53,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (77,53,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (78,53,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (79,53,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (80,53,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (81,54,1,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (82,54,2,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (83,54,3,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (84,54,4,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (85,55,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (86,55,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (87,55,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (88,55,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (89,55,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (90,56,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (91,56,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (92,56,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (93,56,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (94,56,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (95,57,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (96,57,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (97,57,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (98,57,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (99,57,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (100,58,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (101,58,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (102,58,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (103,58,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (104,58,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (105,59,1,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (106,59,2,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (107,59,3,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (108,59,4,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (109,59,5,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (110,60,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (111,60,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (112,60,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (113,60,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (114,60,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (115,61,1,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (116,61,2,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (117,61,3,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (118,61,4,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (119,61,5,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (120,62,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (121,62,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (122,62,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (123,62,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (124,62,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (125,63,1,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (126,63,2,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (127,63,3,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (128,63,4,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (129,63,5,'eroare la compilare',0);
INSERT INTO "TestsResults" VALUES (130,64,6,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (131,64,7,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (132,64,8,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (133,64,9,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (134,64,10,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (135,65,6,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (136,65,7,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (137,65,8,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (138,65,9,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (139,65,10,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (140,66,6,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (141,66,7,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (142,66,8,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (143,66,9,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (144,66,10,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (145,67,6,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (146,67,7,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (147,67,8,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (148,67,9,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (149,67,10,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (150,68,6,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (151,68,7,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (152,68,8,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (153,68,9,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (154,68,10,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (155,69,6,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (156,69,7,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (157,69,8,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (158,69,9,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (159,69,10,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (160,70,11,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (161,70,12,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (162,70,13,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (163,70,14,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (164,70,15,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (165,71,11,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (166,71,12,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (167,71,13,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (168,71,14,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (169,71,15,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (170,72,11,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (171,72,12,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (172,72,13,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (173,72,14,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (174,72,15,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (175,73,11,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (176,73,12,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (177,73,13,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (178,73,14,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (179,73,15,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (180,74,11,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (181,74,12,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (182,74,13,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (183,74,14,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (184,74,15,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (185,75,6,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (186,75,7,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (187,75,8,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (188,75,9,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (189,75,10,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (190,76,6,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (191,76,7,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (192,76,8,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (193,76,9,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (194,76,10,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (195,77,6,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (196,77,7,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (197,77,8,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (198,77,9,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (199,77,10,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (200,78,11,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (201,78,12,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (202,78,13,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (203,78,14,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (204,78,15,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (205,79,11,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (206,79,12,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (207,79,13,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (208,79,14,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (209,79,15,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (210,80,11,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (211,80,12,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (212,80,13,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (213,80,14,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (214,80,15,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (215,81,11,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (216,81,12,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (217,81,13,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (218,81,14,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (219,81,15,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (220,82,11,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (221,82,12,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (222,82,13,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (223,82,14,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (224,82,15,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (225,83,11,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (226,83,12,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (227,83,13,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (228,83,14,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (229,83,15,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (230,84,11,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (231,84,12,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (232,84,13,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (233,84,14,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (234,84,15,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (235,85,11,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (236,85,12,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (237,85,13,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (238,85,14,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (239,85,15,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (240,86,11,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (241,86,12,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (242,86,13,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (243,86,14,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (244,86,15,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (245,87,11,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (246,87,12,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (247,87,13,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (248,87,14,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (249,87,15,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (250,88,11,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (251,88,12,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (252,88,13,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (253,88,14,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (254,88,15,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (255,89,11,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (256,89,12,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (257,89,13,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (258,89,14,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (259,89,15,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (260,90,6,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (261,90,7,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (262,90,8,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (263,90,9,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (264,90,10,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (265,91,6,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (266,91,7,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (267,91,8,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (268,91,9,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (269,91,10,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (270,92,6,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (271,92,7,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (272,92,8,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (273,92,9,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (274,92,10,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (275,93,6,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (276,93,7,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (277,93,8,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (278,93,9,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (279,93,10,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (280,94,6,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (281,94,7,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (282,94,8,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (283,94,9,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (284,94,10,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (285,95,6,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (286,95,7,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (287,95,8,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (288,95,9,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (289,95,10,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (290,96,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (291,96,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (292,96,3,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (293,96,4,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (294,96,5,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (295,97,1,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (296,97,2,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (297,97,3,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (298,97,4,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (299,97,5,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (300,98,11,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (301,98,12,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (302,98,13,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (303,98,14,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (304,98,15,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (305,99,11,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (306,99,12,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (307,99,13,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (308,99,14,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (309,99,15,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (310,100,6,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (311,100,7,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (312,100,8,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (313,100,9,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (314,100,10,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (315,101,6,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (316,101,7,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (317,101,8,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (318,101,9,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (319,101,10,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (320,102,6,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (321,102,7,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (322,102,8,'Raspuns gresit!',0);
INSERT INTO "TestsResults" VALUES (323,102,9,'Raspuns corect!',20);
INSERT INTO "TestsResults" VALUES (324,102,10,'Raspuns gresit!',0);
INSERT INTO "Users" VALUES (1,'admin','admin');
INSERT INTO "Users" VALUES (2,'ionut','participant');
INSERT INTO "Users" VALUES (3,'andrei','participant');
INSERT INTO "Users" VALUES (4,'cristi','participant');
INSERT INTO "Users" VALUES (5,'max','participant');
COMMIT;
