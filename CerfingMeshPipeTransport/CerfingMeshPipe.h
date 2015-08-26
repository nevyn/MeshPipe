#import <Foundation/Foundation.h>
#import <Cerfing/CerfingConnection.h>

@interface CerfingMeshPipe : NSObject
- (instancetype)initWithBasePort:(int)basePort count:(int)count peerName:(NSString*)peerName;

// This will become the delegate for all CerfingConnections. Don't change this more than once
// directly after calling init.
@property(nonatomic,weak) id<CerfingConnectionDelegate> delegate;

@property(nonatomic,copy,readonly) NSSet<CerfingConnection*> *peerConnections;
@end