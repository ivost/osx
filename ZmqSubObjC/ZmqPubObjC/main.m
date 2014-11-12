#import "ZMQObjC.h"
// PUBLISHER
/////////////
int
main(int argc, const char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    ZMQContext *ctx = [[[ZMQContext alloc] initWithIOThreads:1U] autorelease];
    char msg[100] = "HELLO";
    
    ZMQSocket *sock = [ctx socketWithType:ZMQ_PUB];
    // subscriber binds, publisher connects
    if (![sock connectToEndpoint:@"tcp://localhost:5556"]) {
        return EXIT_FAILURE;
    }
    
    
    const int kMaxUpdate = 10;
    for (int update_nbr = 0; update_nbr < kMaxUpdate; ++update_nbr) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSData *data = [NSData dataWithBytes:msg length:strlen(msg)];
        sleep(1);
        NSLog(@"Sending...\n");
        [sock sendData: data withFlags:0];
        [pool drain];
    }
    
    /* [ZMQContext sockets] makes it easy to close all associated sockets. */
    [[ctx sockets] makeObjectsPerformSelector:@selector(close)];
    [pool drain];
    return EXIT_SUCCESS;
}


