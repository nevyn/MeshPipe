//
//  MeshPipe.h
//  MeshPipe
//
//  Created by Nevyn Bengtsson on 2015-08-18.
//  Copyright © 2015 ThirdCog. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MeshPipeDelegate, MeshPipePeerDelegate;
@class MeshPipePeer;

@interface MeshPipe : NSObject
/*!
	@arg port Starting port for your protocol. Must be same for all participants.
	@arg count The maximum number of participating apps; this is how many sockets will be used.
			   Must be same for all participants.
	@arg peerName Name for this app/peer. I suggest using "\(appBundleName).\(nameOfLibrary)".
	
	Each app will try to connect to `count` other apps, so don't make this number too
	large as it will create a very large number of UDP sockets.

	Try somehow to choose a port and range that does not overlap with other apps'
	usage of UDP or MeshPipe. Perhaps we can coordinate usage on the Github wiki for this
	project?

*/
- (instancetype)initWithBasePort:(int)basePort count:(int)count peerName:(NSString*)peerName delegate:(id<MeshPipeDelegate>)delegate;
- (void)disconnect;

@property(nonatomic,readonly) int basePort;
@property(nonatomic,readonly) int count;
@property(nonatomic,readonly) NSString *peerName;
@property(nonatomic,readonly, weak) id<MeshPipeDelegate> delegate;

/// Connected peers (other running apps)
@property(nonatomic) NSSet<MeshPipePeer*> *peers;
@end

@interface MeshPipePeer : NSObject
@property(nonatomic,readonly) NSString *name;
@property(nonatomic,weak,readwrite) id<MeshPipePeerDelegate> delegate;
- (void)sendData:(NSData*)data;
@end

@protocol MeshPipeDelegate <NSObject>
@optional
- (void)meshPipe:(MeshPipe*)pipe acceptedNewPeer:(MeshPipePeer*)peer;
- (void)meshPipe:(MeshPipe *)pipe lostPeer:(MeshPipePeer*)peer withError:(NSError*)error;
- (void)meshPipe:(MeshPipe*)pipe receivedData:(NSData*)data fromPeer:(MeshPipePeer*)peer;
@end

@protocol MeshPipePeerDelegate <NSObject>
- (void)meshPipePeer:(MeshPipePeer*)peer receivedData:(NSData*)data;
@end

extern NSString *const MeshPipeErrorDomain;
typedef enum {
	/// Remote peer explicitly disconnected
	MeshPipeErrorPeerDisconnected = 1,
	/// Remote peer stopped sending keepalives
	MeshPipeErrorPeerTimedOut = 2,
} MeshPipeError;
