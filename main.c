#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>

void *func(void *arg)
{
    char *res = "Fo 'l join\n";
    pthread_exit((void *)res);
}
int main()
{
    char *res = malloc(sizeof(char) * 30);
    pthread_t *thread = malloc(sizeof(pthread_t));

    pthread_create(thread, NULL, func, NULL);
    pthread_join(*thread, (void *)(&res));

    printf("%s", res);
}