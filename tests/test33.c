#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "utlist.h"

#define BUFLEN 20

typedef struct el {
    char bname[BUFLEN];
    struct el *next, *prev;
} el;

#define TEST_DATA_FILE "test11.dat"

static int namecmp(void *_a, void *_b)
{
    el *a = (el*)_a;
    el *b = (el*)_b;
    return strcmp(a->bname,b->bname);
}

int main(int argc, char *argv[])
{
    el *name, *tmp;
    el *head = NULL;

    char linebuf[BUFLEN];
    FILE *file;

    file = fopen( TEST_DATA_FILE, "r" );
    if (file == NULL) {
        perror("can't open: " TEST_DATA_FILE);
        exit(-1);
    }

    while (fgets(linebuf,BUFLEN,file) != NULL) {
        name = (el*)malloc(sizeof(el));
        if (name == NULL) {
            exit(-1);
        }
        strncpy(name->bname,linebuf,sizeof(name->bname));
        LL_PREPEND(head, name);
    }
    LL_SORT(head, namecmp);
    LL_FOREACH(head,tmp) {
        printf("%s", tmp->bname);
    }

    fclose(file);

    return 0;
}
