import Cocoa
import CoreGraphics // For CGWindowLevelForKey

// --- 1. Particle Structure (REMOVED) ---

// --- 2. The Custom "Canvas" View ---
class DesktopCanvasView: NSView {

    // We now make this a layer-backed view
    override var isOpaque: Bool {
        return false
    }

    // Keep a reference to our emitter layer
    private var emitterLayer: CAEmitterLayer?
    
    // We must tell the system we want to use a layer
    override var wantsUpdateLayer: Bool {
        return true // Use layer-backing
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupEmitter()
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupEmitter()
    }

    // This function replaces all the previous particle setup and display link logic
    private func setupEmitter() {
        // 1. Create the Emitter Layer
        let emitter = CAEmitterLayer()
        
        // 2. Configure the Emitter's shape and position
        emitter.emitterShape = .line // Emit particles from a line
        emitter.emitterPosition = CGPoint(x: self.bounds.width / 2, y: self.bounds.height + 10) // Start just above the screen
        emitter.emitterSize = CGSize(width: self.bounds.width, height: 1) // Line width is the screen width
        
        // 3. Create the Particle "Cell" (the template for a rain drop)
        let rainCell = CAEmitterCell()
        
        // 4. Configure the cell's behavior
        rainCell.contents = createRaindropImage() // Use a programmatically generated image
        
        rainCell.birthRate = 800 // How many particles per second
        rainCell.lifetime = 5.0 // How long a particle lives (in seconds)
        
        rainCell.velocity = -1500 // High constant speed (WAS -100)
        rainCell.velocityRange = 100 // Random variation in speed (WAS 30)
        
        rainCell.yAcceleration = 0 // No acceleration (WAS -150)
        rainCell.xAcceleration = 0 // No acceleration (WAS -20)
        
        rainCell.emissionLongitude = -.pi // Set the emission angle
        rainCell.emissionRange = .pi / 80 // Make lines very parallel (WAS .pi / 20)
        
        rainCell.scale = 0.5 // Base size
        rainCell.scaleRange = 0.3 // Random size variation
        
        rainCell.alphaRange = 0.5 // Random opacity (FIXED)
        rainCell.alphaSpeed = -0.1 // Fades out over its lifetime (FIXED)
        
        // 5. Add the cell to the emitter
        emitter.emitterCells = [rainCell]
        
        // 6. Add the emitter layer to our view's layer
        // We set 'wantsLayer' to true to get a layer
        self.wantsLayer = true
        self.layer?.addSublayer(emitter)
        self.emitterLayer = emitter
    }
    
    // This helper function creates a 2x20 pixel white streak
    // to represent a single raindrop.
    private func createRaindropImage() -> CGImage? {
        let width = 2
        let height = 20
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: width * 4, // 4 bytes per pixel (RGBA)
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        
        // Draw a white, rounded streak
        context.setFillColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let path = CGPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height),
                          cornerWidth: 1, cornerHeight: 1,
                          transform: nil)
        context.addPath(path)
        context.fillPath()
        
        return context.makeImage()
    }
}


// --- 3. The Application Delegate ---
class AppDelegate: NSObject, NSApplicationDelegate {

    private var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        guard let mainScreen = NSScreen.main else {
            fatalError("Could not find main screen")
        }
        let screenFrame = mainScreen.frame

        window = NSWindow(
            contentRect: screenFrame,
            styleMask: .borderless,
            backing: .buffered,
            defer: false
        )

        window.isOpaque = false
        window.backgroundColor = .clear
        
        // Use the Core Graphics window level for compatibility
        window.level = NSWindow.Level(Int(CGWindowLevelForKey(.desktopWindow)) + 1)
        
        window.collectionBehavior = [.canJoinAllSpaces, .stationary]
        window.ignoresMouseEvents = true

        // The view now handles its own layer-backed rendering
        let canvasView = DesktopCanvasView(frame: screenFrame)
        window.contentView = canvasView

        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Clean up code if necessary
    }
}

// --- 4. The Main Application Setup ---
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.regular)
app.run()