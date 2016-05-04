//
//  BMDatePickerModal.swift
//
//
//  Created by Adam Eri on 17/11/2014.
//  Copyright (c) blackmirror media. All rights reserved.
//

import Foundation
import UIKit

@objc public enum BMPickerModalMode: Int {
    case DatePicker
    case Picker
}

public class BMPickerModal: UIViewController, UIPopoverPresentationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    /// Closure to be executed when new date is selected
    public var onSelection: ((AnyObject) -> Void)?
    public var shownInPopover: Bool = false
	public var pickerBackgroundView: UIView!
	
    @objc public var mode: BMPickerModalMode = .DatePicker
    public var datePicker: UIDatePicker = UIDatePicker()

    public var picker: UIPickerView = UIPickerView()
    public var pickerDataSource: NSArray?
    public var isVisible: Bool = false
    private var selectedPickerValueIndex: Int = 0

    private let window: UIWindow = UIApplication.sharedApplication().keyWindow!
    private let popoverSize: CGSize = CGSizeMake(460, 261)

    // MARK: View Life Cycle

    override public func viewDidLoad() {
        super.viewDidLoad()

		let viewFrame = self.window.frame
		
		self.view.frame = viewFrame
		self.view.backgroundColor = UIColor.init(white: 0, alpha: 0.5)
		
		let pickerFrame = CGRectMake(0, viewFrame.height - 260, viewFrame.width, 260)
		var pickerSize = pickerFrame.size
		
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            pickerSize = self.popoverSize
		}
		
		let backgroundGestureView = UIView.init(frame: CGRectMake(0, 0, viewFrame.width, viewFrame.height - 260))
		backgroundGestureView.backgroundColor = UIColor.clearColor()
		self.view.addSubview(backgroundGestureView)
		
		let tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: "dismiss")
		tapGestureRecognizer.numberOfTapsRequired = 1
		backgroundGestureView.addGestureRecognizer(tapGestureRecognizer)
		
		self.pickerBackgroundView = UIView.init(frame: pickerFrame)
		self.pickerBackgroundView.backgroundColor = UIColor.whiteColor()
		self.view.addSubview(self.pickerBackgroundView)
		
        if self.mode == .DatePicker {
            self.datePicker.frame = CGRectMake(0, 30, pickerSize.width, 260);
			self.pickerBackgroundView.addSubview(self.datePicker)
        }
        else if self.mode == .Picker {
            self.picker.frame = CGRectMake(0, 30, pickerSize.width, 260);
            self.picker.dataSource = self;
            self.picker.delegate = self;
            self.pickerBackgroundView.addSubview(self.picker)
        }
		
		let cancelButton: UIButton = UIButton(type:.System)
		cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), forState: .Normal)
		cancelButton.frame = CGRectMake(5, 5, 80, 30);
		cancelButton.titleLabel?.textAlignment = NSTextAlignment.Left;
		cancelButton.addTarget(self, action: "dismiss", forControlEvents: UIControlEvents.TouchUpInside);
		//cancelButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
		self.pickerBackgroundView.addSubview(cancelButton)
		
		let saveButton: UIButton = UIButton(type:.System)
		saveButton.setTitle(NSLocalizedString("Save", comment: ""), forState: .Normal)
		saveButton.frame = CGRectMake(self.view.frame.size.width - 90, 5, 80, 30);
		saveButton.titleLabel?.textAlignment = NSTextAlignment.Right;
		saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside);
		//saveButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
		self.pickerBackgroundView.addSubview(saveButton)
    }

    override public func viewDidDisappear(animated: Bool) {
        self.shownInPopover = false
        self.isVisible = false
        super.viewDidDisappear(animated)
    }

    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.isVisible = true
    }

    // MARK: User Actions

    func save () {
        if self.onSelection != nil {

            if self.mode == .DatePicker {
                self.onSelection!(self.datePicker.date)
            }
            else if self.mode == .Picker {
                self.onSelection!(self.selectedPickerValueIndex)
            }

        }
        self.dismiss()
    }


    /// Opens the date picker modal
    public func show () {
        self.show(nil)
    }

    /**
    Shows the date picker modal in a popover controller and sets the completion block.

    :param: selection  Closure to be executed when date/data is selectes
    :param: sourceView view to show from
    :param: sourceRect rect to align to
    :param: inViewController viewController used to present the modal
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

    :param: selection closure to be executed when new date is selected
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
    public func dismiss () {

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