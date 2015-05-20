import AppKit

protocol RightButtonQuitMenu:class{
    func rightButtonClicked()
}

class DummyControl : NSControl {
    
    weak var delegate:RightButtonQuitMenu?
    
    override func mouseDown(theEvent: NSEvent) {
        superview!.mouseDown(theEvent)
        sendAction(action, to: target)
    }
    
    override func rightMouseDown(theEvent: NSEvent) {
        delegate?.rightButtonClicked()
    }
}
