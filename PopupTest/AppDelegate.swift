import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate , RightButtonQuitMenu{
    
    let statusItem: NSStatusItem
    let popover: NSPopover
    var popoverMonitor: AnyObject?
    
    override init() {
        popover = NSPopover()
        popover.contentViewController = ContentViewController()
        statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        
        super.init()
        setupStatusButton()
    }
    
    func setupStatusButton() {
        if let statusButton = statusItem.button {
            statusButton.image = NSImage(named: "Status")
            statusButton.alternateImage = NSImage(named: "StatusHighlighted")

            //
            // WORKAROUND
            //
            // DummyControl interferes mouseDown events to keep statusButton highlighted while popover is open.
            //
            let dummyControl = DummyControl()
            dummyControl.frame = statusButton.bounds
            statusButton.addSubview(dummyControl)
            statusButton.superview!.subviews = [statusButton, dummyControl]
            dummyControl.action = "onPress:"
            dummyControl.target = self
            dummyControl.delegate = self

        }
    }
    
    func onPress(sender: AnyObject) {
        if popover.shown == false {
            openPopover()
        }
        else {
            closePopover()
        }
    }
    
    func openPopover() {
        if let statusButton = statusItem.button {
            statusButton.highlight(true)
            popover.showRelativeToRect(NSZeroRect, ofView: statusButton, preferredEdge: NSMinYEdge)
            popoverMonitor = NSEvent.addGlobalMonitorForEventsMatchingMask(.LeftMouseDownMask, handler: { (event: NSEvent!) -> Void in
                self.closePopover()
            })
        }
    }
    
    func closePopover() {
        popover.close()
        if let statusButton = statusItem.button {
            statusButton.highlight(false)
        }
        if let monitor : AnyObject = popoverMonitor {
            NSEvent.removeMonitor(monitor)
            popoverMonitor = nil
        }
    }
    
    
    func rightButtonClicked() {
        println("right button clicked")
        //show menu bar
        //options is quit
        //when quit touched quit the app
        
        closePopover()
        
        
        
    }
    
}