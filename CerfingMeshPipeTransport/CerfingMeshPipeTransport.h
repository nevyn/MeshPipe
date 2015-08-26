//
//  CerfingMeshPipeTransport.h
//  MeshPipe
//
//  Created by Nevyn Bengtsson on 2015-08-26.
//  Copyright © 2015 ThirdCog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MeshPipe/MeshPipe.h>
#import <Cerfing/Transports/CerfingTransport.h>

@interface CerfingMeshPipeTransport : CerfingTransport
- (instancetype)initWithPeer:(MeshPipePeer*)peer;
@property(nonatomic,readonly) MeshPipePeer *peer;
@end
