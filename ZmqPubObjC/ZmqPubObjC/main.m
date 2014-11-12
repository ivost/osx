
#import "ZMQObjC.h"

int
main(int argc, const char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    ZMQContext *ctx = [[[ZMQContext alloc] initWithIOThreads:1U] autorelease];
    
    // Socket to talk to server
    ZMQSocket *subscriber = [ctx socketWithType:ZMQ_SUB];
    if (![subscriber connectToEndpoint:@"tcp://localhost:5556"]) {
        /* ZMQSocket will already have logged the error. */
        return EXIT_FAILURE;
    }
    
    /* Subscribe to all messages */
    const char *filter = "";
    NSData *filterData = [NSData dataWithBytes:filter length:strlen(filter)];
    [subscriber setData:filterData forOption:ZMQ_SUBSCRIBE];
    
    /* Process updates. */
    NSLog(@"Waiting...\n");
    const int kMaxUpdate = 10;
    for (int update_nbr = 0; update_nbr < kMaxUpdate; ++update_nbr) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSData *msg = [subscriber receiveDataWithFlags:0];
        const char *msgs = [msg bytes];
        printf("Received: %s\n", msgs);
        [pool drain];
    }
    
    /* [ZMQContext sockets] makes it easy to close all associated sockets. */
    [[ctx sockets] makeObjectsPerformSelector:@selector(close)];
    [pool drain];
    return EXIT_SUCCESS;
}
