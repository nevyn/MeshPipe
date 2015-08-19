//
//  MeshPipe.h
//  MeshPipe
//
//  Created by Nevyn Bengtsson on 2015-08-18.
//  Copyright © 2015 ThirdCog. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MeshPipeDelegate;
@class MeshPipePeer;

@interface MeshPipe : NSObject
- (instancetype)initWithBasePort:(int)basePort count:(int)count peerName:(NSString*)peerName delegate:(id<MeshPipeDelegate>)delegate;
- (void)disconnect;

@property(nonatomic,readonly) int basePort;
@property(nonatomic,readonly) int count;
@property(nonatomic,readonly) NSString *peerName;
@property(nonatomic,readonly) id<MeshPipeDelegate> delegate;

@property(nonatomic) NSSet<MeshPipePeer*> *peers;
@end

@interface MeshPipePeer : NSObject
@property(nonatomic,readonly) NSString *name;
- (void)sendData:(NSData*)data;
@end

@protocol MeshPipeDelegate <NSObject>
@optional
- (void)meshPipe:(MeshPipe*)pipe acceptedNewPeer:(MeshPipePeer*)peer;
- (void)meshPipe:(MeshPipe *)pipe lostPeer:(MeshPipePeer*)peer withError:(NSError*)error;
- (void)meshPipe:(MeshPipe*)pipe receivedData:(NSData*)data fromPeer:(MeshPipePeer*)peer;
@end

extern NSString *const MeshPipeErrorDomain;
typedef enum {
	/// Remote peer explicitly disconnected
	MeshPipeErrorPeerDisconnected = 1,
	/// Remote peer stopped sending keepalives
	MeshPipeErrorPeerTimedOut = 2,
} MeshPipeError;
