#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <dirent.h>

int main()
{
    DIR *dir;
    char *path = "/usr/src/app/migrations";
    char database_url[128];
    char cmd[256];

    dir = opendir(path);
    if (dir == NULL)
    {
        printf("No migrations directory found: %s\n", path);
        return 1;
    }
    struct dirent *ent;
    while ((ent = readdir(dir)) != NULL)
    {
        if (ent->d_name[0] == '.')
        {
            continue;
        }
        sprintf(database_url, "%s/%s?sslmode=disable", getenv("DATABASE_URL_BASE"), ent->d_name);

        // データベースの作成
        printf("Creating database: %s\n", database_url);
        sprintf(cmd, "/usr/local/bin/sqlx database create \
                --database-url %s", database_url);
        system(cmd);

        // マイグレーションの実行
        printf("Running migration: %s\n", database_url);
        sprintf(cmd, "/usr/local/bin/sqlx migrate run \
                --source-file /usr/src/app/migrations/%s \
                --database-url %s", ent->d_name, database_url);
        system(cmd);
    }
    closedir(dir);
}
