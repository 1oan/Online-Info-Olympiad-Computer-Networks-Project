#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <errno.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <signal.h>
#include <pthread.h>
#include <sqlite3.h>
#include <map>
#include <string>
#include <thread>
#include <vector>
#include <fstream>
#include <iostream>

#define port 2908
#define adresa "127.0.0.1"

extern int errno;

sqlite3 *db;
std::map<int, std::string> client_map; // Map pentru useri logati
int problem_id;
std::string titlu, enunt, input, output;

int conn_database()
{
    int rc = sqlite3_open("database", &db);
    if (rc)
    {
        printf("Nu pot deschide baza de date \n");
        return rc;
    }
    else
        printf("Baza de date deschisa cu succes \n");
    return 0;
}

bool is_username_taken(const std::string &username)
{
    sqlite3_stmt *stmt;
    std::string select_sql = "select count(*) from Users where username = '" + username + "';";

    int rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);

    rc = sqlite3_step(stmt);
    bool taken = false;
    if (rc == SQLITE_ROW && sqlite3_column_int(stmt, 0) > 0)
        taken = true;

    sqlite3_finalize(stmt);
    return taken;
}

bool is_contest_running()
{
    sqlite3_stmt *stmt;
    std::string select_sql = "select count(*) from Contests where status = 'running';";

    int rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);

    rc = sqlite3_step(stmt);
    bool running = false;
    if (rc == SQLITE_ROW && sqlite3_column_int(stmt, 0) > 0)
        running = true;

    sqlite3_finalize(stmt);
    return running;
}

void problema_random(int &problem_id, std::string &titlu, std::string &enunt, std::string &input, std::string &output)
{
    // problema random din db
    sqlite3_stmt *stmt;
    std::string select_sql = "select * from Problems order by random() limit 1;";

    int rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);

    rc = sqlite3_step(stmt);
    if (rc == SQLITE_ROW)
    {
        problem_id = sqlite3_column_int(stmt, 0);
        titlu = std::string((const char *)sqlite3_column_text(stmt, 1));
        enunt = std::string((const char *)sqlite3_column_text(stmt, 2));
        input = std::string((const char *)sqlite3_column_text(stmt, 3));
        output = std::string((const char *)sqlite3_column_text(stmt, 4));
    }
    sqlite3_finalize(stmt);
}

void insert_contest(int minutes)
{
    sqlite3_stmt *stmt;
    std::string insert_sql = "INSERT INTO Contests (duration, status, start_time, end_time) VALUES (" + std::to_string(minutes) + ", 'running', datetime('now'), datetime('now', '+" + std::to_string(minutes) + " minutes'));";
    int rc = sqlite3_prepare_v2(db, insert_sql.c_str(), -1, &stmt, NULL);
    rc = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

void end_contest(std::string raspuns, int clientSocket)
{
    std::string update_sql = "UPDATE Contests SET status = 'ended' WHERE status = 'running';";
    sqlite3_stmt *stmt;
    int rc = sqlite3_prepare_v2(db, update_sql.c_str(), -1, &stmt, NULL);
    rc = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
    raspuns = "Concursul a fost oprit cu succes!\n";
    send(clientSocket, raspuns.c_str(), raspuns.length(), 0);

    // mesaj pt toti clientii
    std::string mesaj_concurs = "Concursul s-a incheiat! Multumim pentru participare!\n";
    for (const auto &w : client_map)
        if (w.second != "admin")
            send(w.first, mesaj_concurs.c_str(), mesaj_concurs.length(), 0);
}

void insert_submission(int clientSocket, int problem_id, std::string source_code)
{
    // adauga solutie in db
    sqlite3_stmt *stmt;
    std::string insert_sql = "INSERT INTO Submissions (user_id, problem_id, submission_source, submission_time) VALUES ((SELECT user_id FROM Users WHERE username = '" + client_map[clientSocket] + "'), " + std::to_string(problem_id) + " , '" + source_code + "' , datetime('now'));";
    int rc = sqlite3_prepare_v2(db, insert_sql.c_str(), -1, &stmt, NULL);
    rc = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

void get_current_ranking(int clientSocket)
{
    // clasament current
    sqlite3_stmt *stmt;
    std::string select_sql = "SELECT u.username, c.total_points FROM ContestsScores c JOIN Users u ON c.user_id = u.user_id WHERE c.contest_id = (SELECT contest_id FROM Contests WHERE status = 'running') ORDER BY c.total_points DESC;";

    int rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);

    std::string raspuns = "Clasamentul curent:\n";
    int i = 1;
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        raspuns += std::to_string(i++) + ". " + std::string((const char *)sqlite3_column_text(stmt, 0)) + " - " + std::to_string(sqlite3_column_int(stmt, 1)) + " puncte\n";
    }

    sqlite3_finalize(stmt);
    send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
}

void get_alltime_ranking(int clientSocket)
{
    // clasament alltime
    sqlite3_stmt *stmt;
    std::string select_sql = "SELECT u.username, s.total_points FROM AllTimeScores s JOIN Users u ON s.user_id = u.user_id ORDER BY s.total_points DESC;";

    int rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);

    std::string raspuns = "Clasamentul general:\n";
    int i = 1;
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        raspuns += std::to_string(i++) + ". " + std::string((const char *)sqlite3_column_text(stmt, 0)) + " - " + std::to_string(sqlite3_column_int(stmt, 1)) + " puncte\n";
    }

    sqlite3_finalize(stmt);
    send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
}

void verify_submission(int clientSocket, int problem_id)
{
    std::string source;
    int submission_id;
    // iau ultima solutie trimisa
    sqlite3_stmt *stmt;
    std::string select_sql = "SELECT submission_id, submission_source FROM Submissions WHERE user_id = (SELECT user_id FROM Users WHERE username = '" + client_map[clientSocket] + "') AND problem_id = " + std::to_string(problem_id) + " ORDER BY submission_time DESC LIMIT 1;";
    int rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);
    rc = sqlite3_step(stmt);

    submission_id = sqlite3_column_int(stmt, 0);
    source = std::string((const char *)sqlite3_column_text(stmt, 1));
    sqlite3_finalize(stmt); 

    // iau test_idurile de la testele problemelor
    std::vector<int> test_ids;
    select_sql = "SELECT test_id FROM Tests WHERE problem_id = " + std::to_string(problem_id) + ";";
    rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        test_ids.push_back(sqlite3_column_int(stmt, 0));
    }
    sqlite3_finalize(stmt);

    // verific solutie
    // compilez, daca nu compileaza adaug 0 si 'eroare compilare' in testresults
    std::string compile = "g++ -o submission " + source;
    int compile_status = system(compile.c_str());
    if (compile_status != 0)
    {
        for (int i = 0; i < 5; i++)
        {
            std::string insert_sql = "INSERT INTO TestsResults (submission_id, test_id, status, points) VALUES (" + std::to_string(submission_id) + ", " + std::to_string(test_ids[i]) + ", 'eroare la compilare', 0);";
            rc = sqlite3_prepare_v2(db, insert_sql.c_str(), -1, &stmt, NULL);
            rc = sqlite3_step(stmt);
            sqlite3_finalize(stmt);
        }
    }
    else
    {
        // execut cu testele, 20p per test trecut 
        select_sql = "SELECT input_file, output_file FROM Tests WHERE problem_id = " + std::to_string(problem_id) + ";";
        rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);

        std::vector<std::pair<std::string, std::string>> test_files;
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            std::string input = std::string((const char *)sqlite3_column_text(stmt, 0));
            std::string output = std::string((const char *)sqlite3_column_text(stmt, 1));
            test_files.push_back({input, output});
        }
        sqlite3_finalize(stmt);

        for (int i = 0; i < test_files.size(); i++)
        {
            std::string input_file = test_files[i].first;
            std::string expected_output = test_files[i].second;

            std::string run_test = "./submission < " + input_file + " > output.txt";
            int test_status = system(run_test.c_str());

            if (test_status != 0)
            {
                std::string insert_sql = "INSERT INTO TestsResults (submission_id, test_id, status, points) VALUES (" + std::to_string(submission_id) + ", " + std::to_string(test_ids[i]) + ", 'eroare la rularea testului', 0);";
                rc = sqlite3_prepare_v2(db, insert_sql.c_str(), -1, &stmt, NULL);
                rc = sqlite3_step(stmt);
                sqlite3_finalize(stmt);
            }
            else
            {
                // compar cele 2 output-uri
                std::ifstream output("output.txt");
                std::ifstream expected_output_file(expected_output);

                std::string output_line, expected_output_line;
                bool ok = true;

                while (std::getline(output, output_line) && std::getline(expected_output_file, expected_output_line))
                {
                    if (output_line != expected_output_line)
                    {
                        ok = false;
                        break;
                    }
                }
                if (ok && (std::getline(output, output_line) || std::getline(expected_output_file, expected_output_line)))
                    ok = false;

                std::string status = ok ? "Raspuns corect!" : "Raspuns gresit!";
                int puncte = ok ? 20 : 0;
                std::string insert_sql = "INSERT INTO TestsResults (submission_id, test_id, status, points) VALUES (" + std::to_string(submission_id) + ", " + std::to_string(test_ids[i]) + ", '" + status + "', " + std::to_string(puncte) + ");";
                rc = sqlite3_prepare_v2(db, insert_sql.c_str(), -1, &stmt, NULL);
                rc = sqlite3_step(stmt);
                sqlite3_finalize(stmt);
            }
        }
    }
}

void update_score(int clientSocket)
{
    // contest_id
    sqlite3_stmt *stmt;
    std::string select_sql = "SELECT contest_id FROM Contests WHERE status = 'running';";
    int rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL); 
    rc = sqlite3_step(stmt);
    int contest_id = sqlite3_column_int(stmt, 0);
    sqlite3_finalize(stmt);

    // user_id
    select_sql = "SELECT user_id FROM Users WHERE username = '" + client_map[clientSocket] + "';";
    rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);
    rc = sqlite3_step(stmt);
    std::string user_id = std::to_string(sqlite3_column_int(stmt, 0));
    sqlite3_finalize(stmt);

    // scorul solutiei
    select_sql = "SELECT sum(points) FROM TestsResults WHERE submission_id = (SELECT submission_id FROM Submissions WHERE user_id = " + user_id + " ORDER BY submission_time DESC LIMIT 1);";
    rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);
    rc = sqlite3_step(stmt);
    int score = sqlite3_column_int(stmt, 0);
    sqlite3_finalize(stmt);

    // update sau insert?
    select_sql = "SELECT count(*) FROM ContestsScores WHERE user_id = " + user_id + " and contest_id = " + std::to_string(contest_id) + ";";
    rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);
    rc = sqlite3_step(stmt);
    bool has_score = sqlite3_column_int(stmt, 0) > 0;
    sqlite3_finalize(stmt);

    std::string update_sql;
    if (has_score)
    {
        select_sql = "SELECT total_points FROM ContestsScores WHERE user_id = " + user_id + " AND contest_id = " + std::to_string(contest_id) + ";";
        rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);
        rc = sqlite3_step(stmt);
        int current_score = (rc == SQLITE_ROW) ? sqlite3_column_int(stmt, 0) : 0;
        sqlite3_finalize(stmt);

        if (score > current_score)
            update_sql = "UPDATE ContestsScores SET total_points = " + std::to_string(score) + " WHERE user_id = " + user_id + " AND contest_id = " + std::to_string(contest_id) + ";";
    }
    else
    {
        update_sql = "INSERT INTO ContestsScores (contest_id, user_id, total_points) VALUES (" + std::to_string(contest_id) + ", " + user_id + ", " + std::to_string(score) + ");";
    }
    rc = sqlite3_prepare_v2(db, update_sql.c_str(), -1, &stmt, NULL);
    rc = sqlite3_step(stmt);
    sqlite3_finalize(stmt);

    // alltimescore = suma tuturor scorurilor de la concursuri
    select_sql = "SELECT sum(total_points) FROM ContestsScores WHERE user_id = " + user_id + ";";
    rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);
    rc = sqlite3_step(stmt);
    score = sqlite3_column_int(stmt, 0);
    sqlite3_finalize(stmt);

    // update sau insert?
    select_sql = "SELECT count(*) FROM AllTimeScores WHERE user_id = " + user_id + ";";
    rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);
    rc = sqlite3_step(stmt);
    has_score = sqlite3_column_int(stmt, 0) > 0;
    sqlite3_finalize(stmt);

    if (has_score)
    {
        update_sql = "UPDATE AllTimeScores SET total_points = " + std::to_string(score) + " WHERE user_id = " + user_id + ";";
    }
    else
    {
        update_sql = "INSERT INTO AllTimeScores (user_id, total_points) VALUES (" + user_id + ", " + std::to_string(score) + ");";
    }
    rc = sqlite3_prepare_v2(db, update_sql.c_str(), -1, &stmt, NULL);
    rc = sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}

void send_feedback(int clientSocket, int problem_id)
{
    // user_id
    sqlite3_stmt *stmt;
    std::string select_sql = "SELECT user_id FROM Users WHERE username = '" + client_map[clientSocket] + "';";
    int rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);
    rc = sqlite3_step(stmt);
    std::string user_id = std::to_string(sqlite3_column_int(stmt, 0));
    sqlite3_finalize(stmt);

    // submission_id
    select_sql = "SELECT submission_id FROM Submissions WHERE user_id = " + user_id + " AND problem_id = " + std::to_string(problem_id) + " ORDER BY submission_time DESC LIMIT 1;";
    rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);
    rc = sqlite3_step(stmt);
    int submission_id = sqlite3_column_int(stmt, 0);
    sqlite3_finalize(stmt);

    // feedbackul solutiei
    select_sql = "SELECT status, points FROM TestsResults WHERE submission_id = " + std::to_string(submission_id) + ";";
    rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);

    std::string feedback = "Feedback:\n";
    int i = 1, total_points = 0;
    while (sqlite3_step(stmt) == SQLITE_ROW)
    {
        feedback += "Test " + std::to_string(i++) + ": " + std::string((const char *)sqlite3_column_text(stmt, 0)) + " - " + std::to_string(sqlite3_column_int(stmt, 1)) + " puncte\n";
        total_points += sqlite3_column_int(stmt, 1);
    }
    feedback += "Punctaj total: " + std::to_string(total_points) + "\n";

    sqlite3_finalize(stmt);

    send(clientSocket, feedback.c_str(), feedback.length(), 0);
}

void *raspunde(void *arg)
{
    int clientSocket = *(int *)arg;
    free(arg);                      

    char mesaj[1024] = {0};
    std::string raspuns;

    while (1)
    {
        int bytesReceived = recv(clientSocket, mesaj, 1024, 0);
        if (bytesReceived <= 0)
        {
            printf("Clientul %s s-a deconectat de la server.\n", client_map[clientSocket].c_str());
            client_map.erase(clientSocket);
            break;
        }

        printf("Am primit comanda! Incerc sa execut!\n");

        if (strncmp(mesaj, "register", 8) == 0)
        {
            // register
            std::string username = mesaj + 9;
            if (is_username_taken(username))
            {
                raspuns = "Eroare! Username-ul este deja folosit.\n";
            }
            else if (client_map.find(clientSocket) != client_map.end())
            {
                raspuns = "Eroare! Sunteti deja autentificat intr-un cont!\n";
            }
            else
            {
                // adaug username ul in baza de date
                std::string insert_sql = "INSERT INTO Users (username, role) VALUES ('" + username + "', 'participant');";
                sqlite3_stmt *stmt;
                int rc = sqlite3_prepare_v2(db, insert_sql.c_str(), -1, &stmt, NULL);
                rc = sqlite3_step(stmt);
                client_map[clientSocket] = username;
                raspuns = "Felicitari! Contul a fost creat cu succes!\n Bun venit, " + username + "!\n";
                sqlite3_finalize(stmt);
            }
            send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
        }
        else if (strncmp(mesaj, "login", 5) == 0)
        {
            std::string username = mesaj + 6;
            if (!is_username_taken(username))
            {
                raspuns = "Eroare! Username-ul nu exista in baza de date.\n";
            }
            else if (client_map.find(clientSocket) != client_map.end())
            {
                raspuns = "Eroare! Sunteti deja autentificat intr-un cont!\n";
            }
            else
            {
                bool username_in_use = false;
                for (const auto &w : client_map)
                {
                    if (w.second == username)
                    {
                        username_in_use = true;
                        break;
                    }
                }

                if (username_in_use)
                {
                    raspuns = "Eroare! Acest utilizator este deja conectat de pe alt dispozitiv!\n";
                }
                else
                {
                    client_map[clientSocket] = username;
                    raspuns = "Bun venit, " + username + "!\n";
                }
            }
            send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
        }
        else if (strcmp(mesaj, "quit") == 0)
        {
            raspuns = "exit\n";
            client_map.erase(clientSocket);
            send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
            break;
        }
        else if (client_map.find(clientSocket) != client_map.end())
        {
            // comenzi pentru utilizatorii autentificati
            if (strncmp(mesaj, "start_contest", 13) == 0)
            {
                char *command = strtok(mesaj, " ");  // "start_contest"
                char *parameter = strtok(NULL, " "); //  minutele
                int minutes = 0;
                minutes = atoi(parameter);
                if (!(client_map[clientSocket] == "admin"))
                {
                    raspuns = "Eroare! Nu aveti permisiunea de a porni un concurs!\n";
                    send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
                }
                else if (is_contest_running())
                {
                    raspuns = "Eroare! Un concurs este deja in desfasurare!\n";
                    send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
                }
                else if (minutes <= 0)
                {
                    raspuns = "Eroare! Durata concursului nu este valida!\n";
                    send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
                }
                else
                {

                    insert_contest(minutes);

                    raspuns = "Concursul a fost pornit cu succes!\n";
                    send(clientSocket, raspuns.c_str(), raspuns.length(), 0);

                    problema_random(problem_id, titlu, enunt, input, output);

                    // mesaj pt clienti
                    std::string mesaj_concurs = "Concursul a inceput! Aveti " + std::to_string(minutes) + " minute pentru a trimite solutiile!\n";
                    mesaj_concurs += "Problema pe care trebuie sa o rezolvati este: " + titlu + "\n";
                    mesaj_concurs += "Pentru a vedea detaliile problemei, folositi comanda 'get_problem'.\n";
                    mesaj_concurs += "Pentru a trimite solutia, folositi comanda 'submit_solution [source_name]'.\n";
                    for (const auto &w : client_map)
                        if (w.second != "admin")
                            send(w.first, mesaj_concurs.c_str(), mesaj_concurs.length(), 0);

                    // contest_id
                    sqlite3_stmt *stmt;
                    std::string select_sql = "SELECT contest_id FROM Contests WHERE status = 'running';";
                    int rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);
                    rc = sqlite3_step(stmt);
                    int contest_id = sqlite3_column_int(stmt, 0);
                    sqlite3_finalize(stmt);

                    // set_timeout 
                    std::thread([contest_id, raspuns, minutes, clientSocket](){
                        std::this_thread::sleep_for(std::chrono::minutes(minutes));

                        sqlite3_stmt *stmt;
                        std::string select_sql = "SELECT count(*) FROM Contests WHERE status = 'running' and contest_id = '" + std::to_string(contest_id) + "';";
                        int rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);
                        rc = sqlite3_step(stmt);
                        int is_running = sqlite3_column_int(stmt, 0);
                        sqlite3_finalize(stmt);

                        if(is_running > 0) end_contest(raspuns, clientSocket); }).detach();
                }
            }
            else if (strcmp(mesaj, "end_contest") == 0)
            {
                // end contest
                if (!(client_map[clientSocket] == "admin"))
                {
                    raspuns = "Eroare! Nu aveti permisiunea de a opri un concurs!\n";
                    send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
                }
                else if (!is_contest_running())
                {
                    raspuns = "Eroare! Nu exista niciun concurs in desfasurare!\n";
                    send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
                }
                else
                {
                    end_contest(raspuns, clientSocket);
                }
            }
            else if (strcmp(mesaj, "get_problem") == 0)
            {
                if (!is_contest_running())
                {
                    raspuns = "Eroare! Nu exista niciun concurs in desfasurare!\n";
                    send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
                }
                else
                {
                    // trimite date la client
                    raspuns = "Enunt: " + enunt + "\n";
                    raspuns += "Input: " + input + "\n";
                    raspuns += "Output: " + output + "\n";
                    send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
                }
            }
            else if (strncmp(mesaj, "submit_solution", 15) == 0)
            {
                if (!is_contest_running())
                {
                    raspuns = "Eroare! Nu exista niciun concurs in desfasurare!\n";
                    send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
                }
                else
                {
                    char *command = strtok(mesaj, " ");    // submit_solution
                    char *source_name = strtok(NULL, " "); // source file

                    if (access(source_name, F_OK) == -1 || access(source_name, R_OK) == -1)
                    {
                        raspuns = "Eroare! Fisierul sursa nu exista sau nu are permisiuned de citire!\n";
                        send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
                    }
                    else
                    {
                        insert_submission(clientSocket, problem_id, source_name);
                        raspuns = "Solutia a fost trimisa cu succes!\n";
                        send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
                        // verific solutia
                        verify_submission(clientSocket, problem_id);
                        // adaug punctele
                        update_score(clientSocket);
                        // feedback
                        send_feedback(clientSocket, problem_id);
                    }
                }
            }
            else if (strncmp(mesaj, "get_scoreboard", 14) == 0)
            {
                char *command = strtok(mesaj, " ");  // get_scoreboard
                char *parameter = strtok(NULL, " "); // source file

                if (strcmp(parameter, "current") == 0)
                {
                    if (!is_contest_running())
                    {
                        raspuns = "Eroare! Nu exista niciun concurs in desfasurare!\n";
                        send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
                    }
                    else
                    {
                        get_current_ranking(clientSocket);
                    }
                }
                else if (strcmp(parameter, "alltime") == 0)
                {
                    get_alltime_ranking(clientSocket);
                }
                else
                {
                    raspuns = "Eroare! Parametru necunoscut!\n";
                    send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
                }
            }
            else if (strcmp(mesaj, "get_time_left") == 0)
            {
                if (!is_contest_running())
                {
                    raspuns = "Eroare! Nu exista niciun concurs in desfasurare!\n";
                    send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
                }
                else
                {
                    // timp_ramas din concurs
                    sqlite3_stmt *stmt;
                    std::string select_sql = "SELECT CAST((julianday(end_time) - julianday('now')) * 24 * 60 * 60 AS INTEGER) AS time_remaining FROM Contests WHERE status = 'running';";
                    int rc = sqlite3_prepare_v2(db, select_sql.c_str(), -1, &stmt, NULL);

                    rc = sqlite3_step(stmt);
                    int time_remaining = sqlite3_column_int(stmt, 0);
                    int minutes = time_remaining / 60;
                    int seconds = time_remaining % 60;
                    raspuns = "Timp ramas: " + std::to_string(minutes) + ":" + std::to_string(seconds) + "\n";

                    sqlite3_finalize(stmt);
                    send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
                }
            }
            else if (strcmp(mesaj, "logout") == 0)
            {
                raspuns = "Clientul, " + client_map[clientSocket] + ", s-a deconectat de la server.\n";
                send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
                client_map.erase(clientSocket);
            }
            else
            {
                raspuns = "Eroare! Comanda necunoscuta!\n";
                send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
            }
        }
        else
        {
            raspuns = "Eroare! Nu sunteti autentificat intr-un la platforma!\n";
            send(clientSocket, raspuns.c_str(), raspuns.length(), 0);
        }

        memset(mesaj, 0, 1024);
    }

    close(clientSocket); // inchide client socket
    printf("Conexiunea a fost oprita.\n");
    return NULL;
}

int main()
{
    struct sockaddr_in server; // structura folosita de server
    struct sockaddr_in from;
    int sd;            // descriptorul de socket
    pthread_t th[100]; // Identificatorii thread-urilor care se vor crea
    int i = 0;

    if ((sd = socket(AF_INET, SOCK_STREAM, 0)) == -1)
    {
        perror("Eroare la crearea socketului");
        return errno;
    }

    int on = 1;
    setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on));

    server.sin_family = AF_INET;
    server.sin_addr.s_addr = htonl(INADDR_ANY);
    server.sin_port = htons(port);

    if (bind(sd, (struct sockaddr *)&server, sizeof(struct sockaddr)) == -1)
    {
        perror("Eroare la binding");
        return errno;
    }

    if (listen(sd, 5) == -1)
    {
        perror("Eroare la listen");
        return errno;
    }

    if (conn_database() != 0)
    {
        return 1; // exit daca nu se conecteaza
    }

    while (1)
    {
        int *clientSocket = (int *)malloc(sizeof(int));
        __socklen_t length = sizeof(from);

        if ((*clientSocket = accept(sd, (struct sockaddr *)&from, &length)) < 0)
        {
            perror("Eroare la acceptarea conexiunii cu clientul");
            free(clientSocket);
            return errno;
        }

        printf("[THREAD %d] Clientul a fost conectat cu succes.\n", i);

        if (pthread_create(&th[i++], NULL, raspunde, clientSocket) != 0)
        {
            perror("Eroare la crearea threadului");
            close(*clientSocket);
            free(clientSocket);
            continue;
        }

        pthread_detach(th[i - 1]); //detach sa functioneze indep.
    }

    close(sd);         // close la socket ul serverului
    sqlite3_close(db);
    return 0;
}