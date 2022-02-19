#pragma once

#include <Metal/Metal.h>
#include <MetalKit/MetalKit.h>

namespace test
{
    class Renderer
    {
    public:
        Renderer();
        void draw(MTKView*);
        void resetTexture();

    private:
        const id<MTLDevice> _gpu;
        const id<MTLCommandQueue> _commandQueue;
        const id<MTLComputePipelineState> _computePipelineState;
        id<MTLTexture> _texture;
    };
}
