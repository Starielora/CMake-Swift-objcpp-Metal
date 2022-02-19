#include "Renderer.h"

namespace test
{
    namespace
    {
        id<MTLComputePipelineState> createPipelineState(id<MTLDevice> gpu)
        {
            NSError* errors;
            id<MTLLibrary> library = [gpu newDefaultLibrary];
            assert(!errors);

            id<MTLFunction> function = [library newFunctionWithName:@"compute"];

            auto pipelineState = [gpu newComputePipelineStateWithFunction:function error:&errors];
            assert(!errors);

            return pipelineState;
        }
    }

    Renderer::Renderer()
        : _gpu(MTLCreateSystemDefaultDevice())
        , _commandQueue([_gpu newCommandQueue])
        , _computePipelineState(createPipelineState(_gpu))
    {

    }

    void Renderer::resetTexture()
    {
        _texture = nil;
    }

    void Renderer::draw(MTKView* view)
    {
        if (_texture)
        {
            @autoreleasepool {
                auto drawable = [view currentDrawable];
                auto commandBuffer = [_commandQueue commandBuffer];

                auto blit = [commandBuffer blitCommandEncoder];
                [blit copyFromTexture:_texture toTexture:drawable.texture];
                [blit endEncoding];

                [commandBuffer presentDrawable:drawable];
                [commandBuffer commit];
            }
        }
        else
        {
            @autoreleasepool {
                auto drawable = [view currentDrawable];
                _texture = drawable.texture;
                auto size = simd_make_float2(_texture.width, _texture.height);
                auto commandBuffer = [_commandQueue commandBuffer];
                auto computeEncoder = [commandBuffer computeCommandEncoder];
                [computeEncoder setComputePipelineState:_computePipelineState];
                [computeEncoder setTexture:_texture atIndex:0];
                [computeEncoder setBytes:&size length:sizeof(simd_float2) atIndex:0];
                auto width = _computePipelineState.threadExecutionWidth;
                auto height = _computePipelineState.maxTotalThreadsPerThreadgroup / width;
                auto threadsPerGroup = MTLSizeMake(width, height, 1);
                auto threadsPerGrid = MTLSizeMake(_texture.width, _texture.height, 1);
                [computeEncoder dispatchThreadgroups:threadsPerGrid threadsPerThreadgroup:threadsPerGroup];
                [computeEncoder endEncoding];
                [commandBuffer presentDrawable:drawable];
                [commandBuffer commit];
                [commandBuffer waitUntilCompleted];
            }
        }
    }
}
