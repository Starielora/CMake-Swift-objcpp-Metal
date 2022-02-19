//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#pragma once

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

@interface RendererWrapper : NSObject
- (void) draw:(MTKView*)view;
- (void) resetTexture;
@end
