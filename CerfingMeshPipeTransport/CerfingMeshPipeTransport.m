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
	CMPTReadRequest *req = [_readRequests firstObject];
	if(!req)
		return;
	
	NSMutableData *payload = [_queuedPayloads firstObject];
	if(!payload)
		return;
	
	// We can't split a Cerfing message across multiple payloads,
	// as the payloads themselves are UDP datagrams and may be delivered out-of-order.
	NSAssert(req.length <= payload.length, @"Read request/payload length mismatch. Each payload must contain exactly the same amount of data as one full Cerfing message.");
	
	// Request will now be handled.
	[_readRequests removeObject:req];
	
	NSRange requestedRange = NSMakeRange(0, req.length);
	NSData *requestedData = [payload subdataWithRange:requestedRange];
	if(payload.length == req.length) {
		[_queuedPayloads removeObjectAtIndex:0];
	} else {
		[payload replaceBytesInRange:requestedRange withBytes:NULL length:0];
	}
	
	[self.delegate transport:self didReadData:requestedData withTag:req.tag];
	
	// Keep handling read requests until _readRequests or _queuedPayloads is empty
	[self _exhaustReadRequests];
}

- (NSString*)description
{
	return [NSString stringWithFormat:@"<%@@%p over %@>", [self class], self, _peer];
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
