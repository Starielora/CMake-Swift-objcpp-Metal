#include "RendererWrapper.h"
#include "Renderer.h"

#import <Foundation/Foundation.h>

#include <memory>

@implementation RendererWrapper
std::unique_ptr<test::Renderer> wrapper;

- (id)init
{
    wrapper = std::unique_ptr<test::Renderer>(new test::Renderer());
    return self;
}

- (void)dealloc
{
    wrapper.reset();
}

- (void)draw:(MTKView*)view
{
    assert(wrapper);
    wrapper->draw(view);
}

- (void)resetTexture
{
    wrapper->resetTexture();
}
@end
