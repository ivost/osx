#include <assert.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <unistd.h>

#include "zmq.h"
#include "zhelpers.h"


// PUBLISHER
//void *publisher = zmq_socket (context, ZMQ_PUB);
//int rc = zmq_bind (publisher, "tcp://*:5556");
//assert (rc == 0);
//sleep(1);
////  Send message to all subscribers
//for (int i=0; i<10; i++) {
//    char update [20];
//    sprintf (update, "HELLO %d", i);
//    //s_send (publisher, update);
//    printf("Sending %s\n", update);
//    zmq_send (publisher, update, strlen(update), 0);
//}
//zmq_close (publisher);

int main (void)
{
    int rc;
    void *context = zmq_ctx_new ();
    void *sock = zmq_socket (context, ZMQ_SUB);
    rc = zmq_bind (sock, "tcp://*:5556");
    char filter[100] = "";
    rc = zmq_setsockopt (sock, ZMQ_SUBSCRIBE,
                         filter, strlen (filter));
    
    //sleep(1);
    for (int i=0; i<10; i++) {
        printf("waiting...\n");
        char * msg = s_recv(sock);
        if (msg)
            printf("received %s\n", msg);
        free(msg);
    }
    zmq_close (sock);
    zmq_ctx_destroy (context);
    return 0;
}
