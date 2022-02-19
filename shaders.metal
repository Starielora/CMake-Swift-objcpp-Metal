#include <metal_stdlib>
using namespace metal;

kernel void compute(texture2d<half, access::write> output [[texture(0)]], constant float2& screenSize [[buffer(0)]], uint2 id [[thread_position_in_grid]])
{
    constexpr auto thickness = 0.25f;
    const auto halfx = half(screenSize.x / 2);
    const auto v = half2((half(id.x) / halfx), (half(id.y) / halfx));
    const auto aspect = half(screenSize.y) / half(screenSize.x);
    const float len = length(v - half2(1, aspect));
    if (len < 1 - thickness || len > 1.f)
        output.write(half4(0.0, 0.0, 0.0, 1.0), id);
    else
        output.write(half4(0.5, 0.0, len, 1.0), id);
}

