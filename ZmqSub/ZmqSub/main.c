#include <assert.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <unistd.h>

#include "zmq.h"

// PUBLISHER

int main (void)
{
    //  Prepare our context and publisher
    void *context = zmq_ctx_new ();
    void *publisher = zmq_socket (context, ZMQ_PUB);
    int rc = zmq_bind (publisher, "tcp://*:5556");
    assert (rc == 0);
    sleep(1);
    //  Send message to all subscribers
    for (int i=0; i<10; i++) {
        char update [20];
        sprintf (update, "HELLO %d", i);
        //s_send (publisher, update);
        printf("Sending %s\n", update);
        zmq_send (publisher, update, strlen(update), 0);
    }
    zmq_close (publisher);
    zmq_ctx_destroy (context);
    return 0;
}
