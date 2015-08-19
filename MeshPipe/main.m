//
//  main.m
//  MeshPipe
//
//  Created by Nevyn Bengtsson on 2015-08-18.
//  Copyright © 2015 ThirdCog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MeshPipe.h"

@interface Main : NSObject <MeshPipeDelegate>
{
	MeshPipe *_pipe;
}
@end
@implementation Main
- (void)run
{
	NSString *name = [[NSProcessInfo processInfo] arguments][1];
	_pipe = [[MeshPipe alloc] initWithBasePort:12568 count:8 peerName:name delegate:self];
}
- (void)meshPipe:(MeshPipe*)pipe acceptedNewPeer:(MeshPipePeer*)peer
{
	NSLog(@"New peer, is now %@", pipe.peers);
	[peer sendData:[@"Hello" dataUsingEncoding:NSUTF8StringEncoding]];
}
- (void)meshPipe:(MeshPipe *)pipe lostPeer:(MeshPipePeer*)peer withError:(NSError*)error
{
	NSLog(@"Lost peer %@, is now %@", pipe.peers, error);
}
- (void)meshPipe:(MeshPipe*)pipe receivedData:(NSData*)data fromPeer:(MeshPipePeer*)peer
{
	NSLog(@"Peer %@ data: %@", peer, data);
}
@end

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		[[Main new] run];
		[[NSRunLoop mainRunLoop] run];
	}
    return 0;
}
