#import "CerfingMeshPipe.h"
#import "CerfingMeshPipeTransport.h"


@interface CerfingMeshPipe () <MeshPipeDelegate>
{
	MeshPipe *_pipe;
	NSMutableSet<CerfingConnection*> *_peerConnections;
}
@end

@implementation CerfingMeshPipe
- (instancetype)initWithBasePort:(int)basePort count:(int)count peerName:(NSString*)peerName;
{
	if(!(self = [super init]))
		return nil;
	_peerConnections = [NSMutableSet new];
	_pipe = [[MeshPipe alloc] initWithBasePort:basePort count:count peerName:peerName delegate:self];
	
	return self;
}

- (void)broadcastDict:(NSDictionary*)dict
{
	for(CerfingConnection *connection in _peerConnections) {
		[connection sendDict:dict];
	}
}

- (CerfingConnection*)connectionForPeer:(MeshPipePeer*)peer
{
	for(CerfingConnection *connection in _peerConnections) {
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
	cerfingPeerConnection.automaticallyDispatchCommands = YES;
	[_peerConnections addObject:cerfingPeerConnection];
	[transport.delegate transportDidConnect:transport];
}

- (void)meshPipe:(MeshPipe *)pipe lostPeer:(MeshPipePeer*)peer withError:(NSError*)error;
{
	CerfingMeshPipeTransport *transport = [[CerfingMeshPipeTransport alloc] initWithPeer:peer];
	CerfingConnection *conn = [self connectionForPeer:peer];
	[transport.delegate transport:transport willDisconnectWithError:error];
	[_peerConnections removeObject:conn];
	[transport.delegate transportDidDisconnect:transport];
}
@end
