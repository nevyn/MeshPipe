#import <Foundation/Foundation.h>
#import <Cerfing/CerfingConnection.h>

@interface CerfingMeshPipe : NSObject
- (instancetype)initWithBasePort:(int)basePort count:(int)count peerName:(NSString*)peerName;
@property(nonatomic,weak) id<CerfingConnectionDelegate> delegate;
@end