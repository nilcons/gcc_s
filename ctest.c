#include <pthread.h>
#include <unistd.h>

static void *thread_func(void *ignored_argument) {
  sleep(100);
  return NULL;
}

void x() {
  pthread_t thr;
  pthread_create(&thr, NULL, &thread_func, NULL);
  pthread_cancel(thr);
}
