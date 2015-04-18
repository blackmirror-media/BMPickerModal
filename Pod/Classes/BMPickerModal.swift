//
//  BMDatePickerModal.swift
//
//
//  Created by Adam Eri on 17/11/2014.
//  Copyright (c) blackmirror media. All rights reserved.
//

import Foundation
import UIKit

public class BMPickerModal: UIViewController, UIPopoverPresentationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    public enum BMPickerModalMode {
        case DatePicker
        case Picker
    }

    /// Closure to be executed when new date is selected
    public var selectionClosure: ((AnyObject) -> Void)?
    public var shownInPopover: Bool = false

    public var mode: BMPickerModalMode = .DatePicker
    public var datePicker: UIDatePicker = UIDatePicker()

    public var picker: UIPickerView = UIPickerView()
    public var pickerDataSource: NSArray?
    public var isVisible: Bool = false
    private var selectedPickerValueIndex: Int = 0

    private let window: UIWindow = UIApplication.sharedApplication().windows[0] as! UIWindow
    private let popoverSize: CGSize = CGSizeMake(460, 261)
    private var ios7Popover: UIPopoverController?

    // MARK: View Life Cycle

    override public func viewDidLoad() {
        super.viewDidLoad()

        var pickerSize = self.window.frame.size

        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            pickerSize = self.popoverSize
        }

        self.view.frame = CGRectMake(0, pickerSize.height - 260, pickerSize.width, 260)
        self.view.backgroundColor = UIColor.whiteColor()

        if self.mode == .DatePicker {
            self.datePicker.frame = CGRectMake(0, 30, pickerSize.width, 260);
            self.view.addSubview(self.datePicker)
        }
        else if self.mode == .Picker {
            self.picker.frame = CGRectMake(0, 30, pickerSize.width, 260);
            self.picker.dataSource = self;
            self.picker.delegate = self;
            self.view.addSubview(self.picker)
        }
    }

    override public func viewDidDisappear(animated: Bool) {
        self.shownInPopover = false
        self.isVisible = false
        super.viewDidDisappear(animated)
    }

    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.isVisible = true

        var cancelButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), forState: .Normal)
        cancelButton.frame = CGRectMake(5, 5, 100, 30);
        cancelButton.titleLabel?.textAlignment = NSTextAlignment.Left;
        cancelButton.addTarget(self, action: "dismiss", forControlEvents: UIControlEvents.TouchUpInside);
        //cancelButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
        self.view.addSubview(cancelButton)

        var saveButton: UIButton = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        saveButton.setTitle(NSLocalizedString("Save", comment: ""), forState: .Normal)
        saveButton.frame = CGRectMake(self.view.frame.size.width - 90, 5, 100, 30);
        saveButton.titleLabel?.textAlignment = NSTextAlignment.Right;
        saveButton.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside);
        //saveButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
        self.view.addSubview(saveButton)
    }

    // MARK: User Actions

    func save () {
        if self.selectionClosure != nil {

            if self.mode == .DatePicker {
                self.selectionClosure!(self.datePicker.date)
            }
            else if self.mode == .Picker {
                self.selectionClosure!(self.selectedPickerValueIndex)
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

    :param: selection  Selected Date
    :param: sourceView view to show from
    :param: sourceRect rect to align to
    :param: inView viewController used to present it from
    */
    public func showInPopover (selection: ((AnyObject) -> Void)?, sourceView: UIView, sourceRect: CGRect, inViewController: UIViewController?) {
        self.shownInPopover = true
        self.selectionClosure = selection

        self.modalPresentationStyle = .Popover
        self.preferredContentSize = self.popoverSize

        var viewController: UIViewController? = inViewController

        if viewController == nil {
            viewController = self.window.rootViewController!
        }

        let isIOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)

        if isIOS7 {
            self.ios7Popover = UIPopoverController(contentViewController: self)
            self.ios7Popover!.presentPopoverFromRect(sourceRect, inView: sourceView, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
        else {
            var popover = self.popoverPresentationController
            popover?.delegate = self
            popover?.sourceView = sourceView
            popover?.sourceRect = sourceRect

            viewController!.presentViewController(self, animated: true, completion: { () -> Void in
                // nothing here
            })
        }
    }

    /**
    Shows the date picker modal and sets the completion block.

    :param: selection closure to be executed when new date is selected
    */
    public func show (selection: ((AnyObject) -> Void)?) {
        self.selectionClosure = selection

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
            let isIOS7 = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_1)
            if isIOS7 {
                self.ios7Popover?.dismissPopoverAnimated(true)
            }
            else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
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

    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.pickerDataSource?.objectAtIndex(row) as! NSString as String
    }

    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedPickerValueIndex = row
    }
}