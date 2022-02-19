import SwiftUI
import MetalKit

class Coordinator : NSObject, MTKViewDelegate {
    var parent: MetalView
    var renderer: RendererWrapper

    init(_ parent: MetalView) {
        self.parent = parent
        renderer = RendererWrapper()
        super.init()
    }

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        renderer.resetTexture();
    }

    func draw(in view: MTKView) {
        renderer.draw(view)
    }
}

func makeMTKView(coordinator: Coordinator) -> MTKView
{
    let mtkView = MTKView()
    mtkView.delegate = coordinator
    mtkView.preferredFramesPerSecond = 60
    mtkView.enableSetNeedsDisplay = true
    if let metalDevice = MTLCreateSystemDefaultDevice() {
        mtkView.device = metalDevice
    }
    mtkView.framebufferOnly = false
    mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
    mtkView.drawableSize = mtkView.frame.size
    mtkView.enableSetNeedsDisplay = true
    mtkView.isPaused = false;
    return mtkView
}

// TODO try to make it without copying whole class
// swift directives do not work like preprocessor in C++
// these only differ in NS/UI parts in names
#if os(macOS)
struct MetalView: NSViewRepresentable {

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: NSViewRepresentableContext<MetalView>) -> MTKView {
        return makeMTKView(coordinator: context.coordinator)
    }

    func updateNSView(_ nsView: MTKView, context: NSViewRepresentableContext<MetalView>) {
    }
}
#else
struct MetalView: UIViewRepresentable {

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<MetalView>) -> MTKView {
        return makeMTKView(coordinator: context.coordinator);
    }

    func updateUIView(_ nsView: MTKView, context: UIViewRepresentableContext<MetalView>) {
    }
}
#endif

struct ContentView: View {
    var body: some View {
        MetalView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
        }
    }
}
