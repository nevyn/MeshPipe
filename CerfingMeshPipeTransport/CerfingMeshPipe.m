#import "CerfingMeshPipe.h"
#import "CerfingMeshPipeTransport.h"


@interface CerfingMeshPipe () <MeshPipeDelegate>
{
	MeshPipe *_pipe;
	NSMutableSet<CerfingConnection*> *_cerfingPeerConnections;
}
@end

@implementation CerfingMeshPipe
- (instancetype)initWithBasePort:(int)basePort count:(int)count peerName:(NSString*)peerName;
{
	if(!(self = [super init]))
		return nil;
	_cerfingPeerConnections = [NSMutableSet new];
	_pipe = [[MeshPipe alloc] initWithBasePort:basePort count:count peerName:peerName delegate:self];
	
	return self;
}

- (CerfingConnection*)connectionForPeer:(MeshPipePeer*)peer
{
	for(CerfingConnection *connection in _cerfingPeerConnections) {
		CerfingMeshPipeTransport *transport = (id)connection.transport;
		if(transport.peer == peer)
			return connection;
	}
	return nil;
}

- (void)meshPipe:(MeshPipe*)pipe acceptedNewPeer:(MeshPipePeer*)peer
{
	CerfingMeshPipeTransport *transport = [[CerfingMeshPipeTransport alloc] initWithPeer:peer];
	CerfingConnection *cerfingPeerConnection = [[CerfingConnection alloc] initWithTransport:transport delegate:self.delegate];
	[_cerfingPeerConnections addObject:cerfingPeerConnection];
}

- (void)meshPipe:(MeshPipe *)pipe lostPeer:(MeshPipePeer*)peer withError:(NSError*)error;
{
	CerfingConnection *conn = [self connectionForPeer:peer];
	[_cerfingPeerConnections removeObject:conn];
}
@end
