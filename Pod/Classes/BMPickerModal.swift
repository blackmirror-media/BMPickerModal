//
//  BMDatePickerModal.swift
//
//
//  Created by Adam Eri on 17/11/2014.
//  Copyright (c) blackmirror media. All rights reserved.
//

import Foundation
import UIKit

protocol BMPickerModalDelegate: class {
    func bmPickerModalDismissed()
}

@objc public enum BMPickerModalMode: Int {
    case DatePicker
    case Picker
}

public class BMPickerModal: UIViewController, UIPopoverPresentationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    weak var delegate: BMPickerModalDelegate?
    
    /// Closure to be executed when new date is selected
    public var onSelection: ((AnyObject) -> Void)?
    
    /// True if the picker is inside a popover. iPad only.
    public var shownInPopover: Bool = false
    
    /// True if the modal is currently visible
    public var isVisible: Bool = false
    
    /// Mode of the picker. DatePicker or simple Picker
    @objc public var mode: BMPickerModalMode = .DatePicker
    
    /// The DatePicker itself
    public var datePicker: UIDatePicker = UIDatePicker()
    
    /// The Picker itself
    public var picker: UIPickerView = UIPickerView()
    /// Data Source of te Picker. Array of elements
    public var pickerDataSource: NSArray?
    /// Index of the selected picker value
    private var selectedPickerValueIndex: Int = 0
    
    
    /// Text for save button
    public var saveButtonTitle: String = "Save"
    public var cancelButtonTitle: String = "Cancel"
    
    /// Blur effect style of the modal. ExtraLight by default
    public var blurEffectStyle: UIBlurEffectStyle = .ExtraLight
    
    /// Blur view
    private var blurEffectView: UIVisualEffectView!
    private let window: UIWindow = UIApplication.sharedApplication().windows[0]
    /// Size of the popover on the iPad
    private let popoverSize: CGSize = CGSizeMake(460, 261)
    
    // MARK: View Life Cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: self.blurEffectStyle))
        self.blurEffectView.frame = self.view.frame
        
        var pickerSize = self.window.frame.size
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            pickerSize = self.popoverSize
        }
        
        self.view.frame = CGRectMake(0, pickerSize.height - 260, pickerSize.width, 260)
        self.blurEffectView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        if self.mode == .DatePicker {
            self.datePicker.frame = CGRectMake(0, 30, pickerSize.width, 260);
            self.blurEffectView.contentView.addSubview(self.datePicker)
        }
        else if self.mode == .Picker {
            self.picker.frame = CGRectMake(0, 30, pickerSize.width, 260);
            self.picker.dataSource = self;
            self.picker.delegate = self;
            self.blurEffectView.contentView.addSubview(self.picker)
        }
        
        self.view.addSubview(blurEffectView)
    }
    
    override public func viewDidDisappear(animated: Bool) {
        self.shownInPopover = false
        self.isVisible = false
        super.viewDidDisappear(animated)
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.isVisible = true
        
        let cancelButton: UIButton = UIButton(type: UIButtonType.System)
        cancelButton.setTitle(self.cancelButtonTitle, forState: .Normal)
        cancelButton.frame = CGRectMake(5, 5, 100, 30);
        cancelButton.titleLabel?.textAlignment = NSTextAlignment.Left;
        cancelButton.addTarget(self, action: #selector(BMPickerModal.dismiss), forControlEvents: UIControlEvents.TouchUpInside);
        
        if self.blurEffectStyle == .Dark {
            cancelButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
        
        self.blurEffectView.contentView.addSubview(cancelButton)
        
        let saveButton: UIButton = UIButton(type: UIButtonType.System)
        saveButton.setTitle(self.saveButtonTitle, forState: .Normal)
        saveButton.frame = CGRectMake(self.view.frame.size.width - 90, 5, 100, 30);
        saveButton.titleLabel?.textAlignment = NSTextAlignment.Right;
        saveButton.addTarget(self, action: #selector(BMPickerModal.save), forControlEvents: UIControlEvents.TouchUpInside);
        
        if self.blurEffectStyle == .Dark {
            saveButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        }
        
        self.blurEffectView.contentView.addSubview(saveButton)
    }
    
    // MARK: User Actions
    
    /**
     Saving the value selected. Triggers the onSelection closure
     */
    func save () {
        if self.onSelection != nil {
            
            if self.mode == .DatePicker {
                self.onSelection!(self.datePicker.date)
            }
            else if self.mode == .Picker {
                self.onSelection!(self.selectedPickerValueIndex)
            }
            
        }
        self.dismiss(nil)
    }
    
    
    /**
     Opens the date picker modal
     */
    public func show () {
        self.show(nil)
    }
    
    /**
     Shows the date picker modal in a popover controller and sets the completion block.
     
     - parameter selection:  Closure to be executed when date/data is selectes
     - parameter sourceView: view to show from
     - parameter sourceRect: rect to align to
     - parameter inViewController: viewController used to present the modal
     */
    public func showInPopover (selection: ((AnyObject) -> Void)?, sourceView: UIView, sourceRect: CGRect, inViewController: UIViewController?) {
        self.shownInPopover = true
        self.onSelection = selection
        
        self.modalPresentationStyle = .Popover
        self.preferredContentSize = self.popoverSize
        
        var viewController: UIViewController? = inViewController
        
        if viewController == nil {
            viewController = self.window.rootViewController!
        }
        
        let popover = self.popoverPresentationController
        popover?.delegate = self
        popover?.sourceView = sourceView
        popover?.sourceRect = sourceRect
        
        viewController!.presentViewController(self, animated: true, completion: { () -> Void in
            // nothing here
        })
    }
    
    /**
     Shows the date picker modal and sets the completion block.
     
     - parameter selection: closure to be executed when new date is selected
     */
    public func show (selection: ((AnyObject) -> Void)?) {
        self.onSelection = selection
        
        self.view.alpha = 0.0
        window.addSubview(self.view)
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.alpha = 1.0;
        })
    }
    
    /**
     Closes the modal
     */
    public func dismiss (completion: (Void -> Void)?) {
        
        if self.shownInPopover {
            self.shownInPopover = false
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            UIView.animateWithDuration(0.3,
                                       animations: { () -> Void in
                                        self.view.alpha = 0.0;
            }) { (completed) -> Void in
                self.view.removeFromSuperview()
            }
        }
        
        self.delegate?.bmPickerModalDismissed()
        if completion != nil {
            completion!()
        }
    }
    
    // MARK: Picker View Delegates
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerDataSource?.count ?? 0
    }
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerDataSource?.objectAtIndex(row) as! NSString as String
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedPickerValueIndex = row
    }
}