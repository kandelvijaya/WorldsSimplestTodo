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
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 207))
        
        searchField = NSTextField()
        searchField.delegate = self
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.focusRingType = .None
        searchField.placeholderString = "Enter a task.."
        view.addSubview(searchField)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-(20)-[searchField]-(20)-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["searchField":searchField]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-(20)-[searchField(==25)]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["searchField":searchField]))
        
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
        
        //reset the value on the text field
        searchField.stringValue = ""
        searchField.placeholderString = "Good! anyhting else.."
    }
    
    
    
    //MARK: my functions
    func addItemToList(itemString:String){
        //put the date and time too
        var dateGood = NSDateFormatter()
        dateGood.dateFormat = "hh:mm"
        dateGood.timeZone = NSTimeZone()
        
        var textDate = dateGood.stringFromDate(NSDate())
        
        var label = NSTextField()
        label.stringValue = itemString + "   -\(textDate)"
        
        //uncomment to show a plain text
        label.editable = false
//        label.bezeled = false
//        label.drawsBackground = false
//        label.textColor = NSColor.purpleColor()
        label.backgroundColor = NSColor.purpleColor()
        label.translatesAutoresizingMaskIntoConstraints = false     //telling compiler not to autogenerate
        
        //put it on the labels
        labels.insert(label, atIndex: 0)    //from first
        
        //add to view
        view.addSubview(label)
        
        //remove all of them
        for label in labels{
            label.removeFromSuperview()
        }
        
        
        //now add them properly
        var counter = 0
        var verticalConstraint = [AnyObject]()
        for ilabel in labels{
            
            //add to superview
            view.addSubview(ilabel)
            
            if counter == 0{
                //this is first and latest attach to the seachField
                verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:[searchField]-10-[label]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["label":ilabel, "searchField":self.searchField])
            }else{
                //attach to the previous one
                verticalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:[lastLabel]-5-[label]", options: NSLayoutFormatOptions(0), metrics: nil, views: ["label":ilabel, "lastLabel":labels[counter - 1]])
            }
            
            //horizontal constraint remians the same always
            var horizontalConstraint = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[thislabel]-20-|", options: NSLayoutFormatOptions(0), metrics: nil, views: ["thislabel":ilabel])
            
            //add constraints
            view.addConstraints(verticalConstraint)
            view.addConstraints(horizontalConstraint)
            
            //increment
            counter++
        }
        
        
        //TODO: add swipe gesture to mark completion
        var swipeGesture = NSPanGestureRecognizer(target: self, action: "panned")
        label.addGestureRecognizer(swipeGesture)
    }
    
}