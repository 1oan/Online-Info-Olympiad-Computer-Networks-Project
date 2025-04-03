#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <errno.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <netdb.h>
#include <string.h>
#include <arpa/inet.h>
#include <stdbool.h>
#include <sys/select.h>

extern int errno;

#define port 2908
#define adresa "127.0.0.1"

int main()
{

    int sd;                    // descriptorul de socket
    struct sockaddr_in server; // structura folosita pentru conectare
                               // mesajul trimis
    char mesaj[1024];
    fd_set read_fds;

    if ((sd = socket(AF_INET, SOCK_STREAM, 0)) == -1)
    {
        perror("Eroare la crearea socketului.\n");
        return errno;
    }

    server.sin_family = AF_INET;
    server.sin_addr.s_addr = inet_addr(adresa);
    server.sin_port = htons(port);

    if (connect(sd, (struct sockaddr *)&server, sizeof(struct sockaddr)) == -1)
    {
        perror("Eroare la conectarea la server.\n");
        close(sd);
        return errno;
    }

    printf("PENTRU CA VERIFICAREA SURSELOR SA FUNCTIONEZE TREBUIE SCOASE DIN FOLDERE TESTELELE SI SURSELE PENTRU CA ASA SUNT PATH-URILE:D\n");

    printf("Conectarea la server a avut loc cu succes!\n");
    printf("Inregistreaza-te folosind comanda 'register [username]' sau logheaza-te folosind comanda 'login [username]'.\n");

    while (1)
    {
        FD_ZERO(&read_fds);
        FD_SET(STDIN_FILENO, &read_fds);
        FD_SET(sd, &read_fds);

        int max_fd = (STDIN_FILENO > sd) ? STDIN_FILENO : sd;

        if (select(max_fd + 1, &read_fds, NULL, NULL, NULL) < 0)
        {
            perror("Eroare la select.\n");
            break;
        }

        if (FD_ISSET(sd, &read_fds))
        {
            memset(mesaj, 0, sizeof(mesaj));
            if (read(sd, mesaj, sizeof(mesaj)) <= 0)
            {
                perror("Eroare la citirea de la server.\n");
                break;
            }
            else if (strncmp(mesaj, "exit", 4) == 0)
            {
                printf("[Raspunsul serverului]: Conexiunea a fost oprita. Programul se va inchide.\n");
                break;
            }

            printf("[Raspunsul serverului]: %s\n", mesaj);
        }

        if (FD_ISSET(STDIN_FILENO, &read_fds))
        {
            fflush(stdout);
            memset(mesaj, 0, sizeof(mesaj));
            fgets(mesaj, sizeof(mesaj), stdin);
            mesaj[strcspn(mesaj, "\n")] = 0;

            if (write(sd, mesaj, strlen(mesaj)) <= 0)
            {
                perror("Eroare la scrierea catre sever.\n");
                break;
            }
        }
    }

    close(sd);
    return 0;
}