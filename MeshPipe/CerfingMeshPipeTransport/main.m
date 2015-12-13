//
//  main.m
//  CerfingMeshPipeTransport
//
//  Created by Nevyn Bengtsson on 2015-08-26.
//  Copyright © 2015 ThirdCog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CerfingMeshPipe.h"

@interface DemoPeer : NSObject <CerfingConnectionDelegate>
{
	NSString *_name;
	CerfingMeshPipe *_cerfingMesh;
}
@end
@implementation DemoPeer
- (id)initWithName:(NSString*)name
{
	if(!(self = [super init]))
		return nil;
	
	_name = name;
	_cerfingMesh = [[CerfingMeshPipe alloc] initWithBasePort:23853 count:4 peerName:name];
	_cerfingMesh.delegate = self;
	
	[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(sayHi) userInfo:nil repeats:YES];
	
	return self;
}

-(void)command:(CerfingConnection*)proto printMessage:(NSDictionary*)dict
{
	NSLog(@"I received '%@' from %@", dict[@"msg"], proto);
}

- (void)sayHi
{
	for(CerfingConnection *connection in _cerfingMesh.peerConnections) {
		[connection sendDict:@{
			kCerfingCommand: @"printMessage",
			@"msg": [NSString stringWithFormat:@"Whee hello I'm %@", _name],
		}];
	}
}

@end


int main (int argc, const char * argv[])
{
	@autoreleasepool {
		DemoPeer *peer = [[DemoPeer alloc] initWithName:[[NSProcessInfo processInfo] arguments][1]];
		(void)peer;
		[[NSRunLoop mainRunLoop] run];
	}
	
	return 0;
}
