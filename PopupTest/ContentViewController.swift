import AppKit

class ContentViewController : NSViewController, NSTextFieldDelegate {
    
    var searchField : NSTextField!
    var viewDictionary = [String:AnyObject]()
    var labels = [NSTextField]()
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func loadView() {
        view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(
            item: view, attribute: .Width, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 280))
        view.addConstraint(NSLayoutConstraint(
            item: view, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 200))
        
        searchField = NSTextField()
        searchField.delegate = self
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.focusRingType = .None
        view.addSubview(searchField)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-(20)-[searchField]-(20)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["searchField":searchField]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-(20)-[searchField(==30)]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["searchField":searchField]))
        
        viewDictionary["searchField"] = searchField
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onEndEditing:", name: NSControlTextDidEndEditingNotification, object: searchField)
    }
    
    func onEndEditing(note : NSNotification) {
        NSLog("Search for %@", searchField.stringValue)
        
        //TODO: add the item below the list
        addItemToList(searchField.stringValue)
    }
    
    
    
    //MARK: my functions
    func addItemToList(itemString:String){
        var label = NSTextField()
        label.stringValue = itemString
        label.editable = false
        label.backgroundColor = NSColor.purpleColor()
        
        label.translatesAutoresizingMaskIntoConstraints = false     //telling compiler not to autogenerate
        
        view.addSubview(label, positioned: NSWindowOrderingMode.Below, relativeTo: searchField)
        
        
        //theres no problem for the horizontal one
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[thislabel]-20-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["thislabel":label]))
        
        
        var verticalConstraint:[AnyObject]!
        if labels.count > 0 {
            verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:[lastLabel]-5-[label]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["label":label, "lastLabel":labels.last!])
        
        }else{
            //this is the first one so 
            verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[searchField]-10-[label]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["searchField":searchField, "label":label])
            
        }
        
        view.addConstraints(verticalConstraint)
        
        //add it to dictionary of views
        self.labels.append(label)
        
        
        //TODO: add swipe gesture to mark completion
        var swipeGesture = NSPanGestureRecognizer(target: self, action: "panned")
        label.addGestureRecognizer(swipeGesture)
    }
    
}