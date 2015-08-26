//
//  main.m
//  CerfingMeshPipeTransport
//
//  Created by Nevyn Bengtsson on 2015-08-26.
//  Copyright © 2015 ThirdCog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CerfingMeshPipe.h"



int main (int argc, const char * argv[])
{
	// Split into two peers
	pid_t child = fork();
	(void)child;
	
	@autoreleasepool {
		CerfingMeshPipe *peer = [CerfingMeshPipe new];
		[[NSRunLoop mainRunLoop] run];
	}
	
	return 0;
}
