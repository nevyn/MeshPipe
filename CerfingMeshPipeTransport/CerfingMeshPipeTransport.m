//
//  CerfingMeshPipeTransport.m
//  MeshPipe
//
//  Created by Nevyn Bengtsson on 2015-08-26.
//  Copyright © 2015 ThirdCog. All rights reserved.
//

#import "CerfingMeshPipeTransport.h"

@interface CMPTReadRequest : NSObject
- (instancetype)initWithTag:(long)tag length:(NSUInteger)length;
@property(nonatomic) long tag;
@property(nonatomic) NSUInteger length;
@end

@interface CerfingMeshPipeTransport () <MeshPipePeerDelegate>
{
	NSMutableArray<CMPTReadRequest*> *_readRequests;
	NSMutableArray<NSMutableData*> *_queuedPayloads;
}
@end

@implementation CerfingMeshPipeTransport
- (instancetype)initWithPeer:(MeshPipePeer*)peer;
{
	if(!(self = [super init]))
		return nil;
	_peer = peer;
	_readRequests = [NSMutableArray new];
	_queuedPayloads = [NSMutableArray new];
	peer.delegate = self;
	return self;
}

- (void)_exhaustReadRequests
{
	if([_queuedPayloads count] == 0)
		return;
	
}

#pragma mark Transport concrete implementations

- (void)readDataToLength:(NSUInteger)length withTimeout:(NSTimeInterval)timeout tag:(long)tag
{
	[_readRequests addObject:[[CMPTReadRequest alloc] initWithTag:tag length:length]];
	[self _exhaustReadRequests];
}

- (void)writeData:(NSData*)data withTimeout:(NSTimeInterval)timeout
{
	[_peer sendData:data];
}

- (void)disconnect
{
	NSAssert(NO, @"Not implemented");
}

- (BOOL)isConnected
{
	return YES;
}

#pragma mark MeshPipePeer delegate
- (void)meshPipePeer:(MeshPipePeer*)peer receivedData:(NSData*)data
{
	[_queuedPayloads addObject:[data mutableCopy]];
	[self _exhaustReadRequests];
}
@end

@implementation CMPTReadRequest
- (instancetype)initWithTag:(long)tag length:(NSUInteger)length
{
	if(!(self = [super init]))
		return nil;
	_tag = tag;
	_length = length;
	return self;
}
@end
