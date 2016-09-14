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
  case datePicker
  case picker
}

public class BMPickerModal: UIViewController, UIPopoverPresentationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
  
  /// Closure to be executed when new date is selected
  public var onSelection: ((AnyObject) -> Void)?
  
  /// True if the picker is inside a popover. iPad only.
  public var shownInPopover: Bool = false
  
  /// True if the modal is currently visible
  public var isVisible: Bool = false
  
  /// Mode of the picker. DatePicker or simple Picker
  @objc public var mode: BMPickerModalMode = .datePicker
  
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
  public var blurEffectStyle: UIBlurEffectStyle = .extraLight
  
  /// Blur view
  private var blurEffectView: UIVisualEffectView!
  private let window: UIWindow = UIApplication.shared.windows[0]
  /// Size of the popover on the iPad
  private let popoverSize: CGSize = CGSize(width: 460, height: 261)
  
  // MARK: View Life Cycle
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    self.blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: self.blurEffectStyle))
    self.blurEffectView.frame = self.view.frame
    
    var pickerSize = self.window.frame.size
    
    if UIDevice.current.userInterfaceIdiom == .pad {
      pickerSize = self.popoverSize
    }
    
    self.view.frame = CGRect(x: 0, y: pickerSize.height - 260, width: pickerSize.width, height: 260)
    self.blurEffectView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height);
    
    if self.mode == .datePicker {
      self.datePicker.frame = CGRect(x: 0, y: 30, width: pickerSize.width, height: 260);
      self.blurEffectView.contentView.addSubview(self.datePicker)
    }
    else if self.mode == .picker {
      self.picker.frame = CGRect(x: 0, y: 30, width: pickerSize.width, height: 260);
      self.picker.dataSource = self;
      self.picker.delegate = self;
      self.blurEffectView.contentView.addSubview(self.picker)
    }
    
    self.view.addSubview(blurEffectView)
  }
  
  override public func viewDidDisappear(_ animated: Bool) {
    self.shownInPopover = false
    self.isVisible = false
    super.viewDidDisappear(animated)
  }
  
  override public func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.isVisible = true
    
    let cancelButton: UIButton = UIButton(type: UIButtonType.system)
    cancelButton.setTitle(self.cancelButtonTitle, for: UIControlState())
    cancelButton.frame = CGRect(x: 5, y: 5, width: 100, height: 30);
    cancelButton.titleLabel?.textAlignment = NSTextAlignment.left;
    cancelButton.addTarget(self, action: #selector(dismiss as (Void) -> Void), for: UIControlEvents.touchUpInside);
    
    if self.blurEffectStyle == .dark {
      cancelButton.setTitleColor(UIColor.black, for: UIControlState())
    }
    
    self.blurEffectView.contentView.addSubview(cancelButton)
    
    let saveButton: UIButton = UIButton(type: UIButtonType.system)
    saveButton.setTitle(self.saveButtonTitle, for: UIControlState())
    saveButton.frame = CGRect(x: self.view.frame.size.width - 90, y: 5, width: 100, height: 30);
    saveButton.titleLabel?.textAlignment = NSTextAlignment.right;
    saveButton.addTarget(self, action: #selector(BMPickerModal.save), for: UIControlEvents.touchUpInside);
    
    if self.blurEffectStyle == .dark {
      saveButton.setTitleColor(UIColor.black, for: UIControlState())
    }
    
    self.blurEffectView.contentView.addSubview(saveButton)
  }
  
  // MARK: User Actions
  
  /**
   Saving the value selected. Triggers the onSelection closure
   */
  func save () {
    if self.onSelection != nil {
      
      if self.mode == .datePicker {
        self.onSelection!(self.datePicker.date as AnyObject)
      }
      else if self.mode == .picker {
        self.onSelection!(self.selectedPickerValueIndex as AnyObject)
      }
      
    }
    self.dismiss()
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
  public func showInPopover (_ selection: ((AnyObject) -> Void)?, sourceView: UIView, sourceRect: CGRect, inViewController: UIViewController?) {
    self.shownInPopover = true
    self.onSelection = selection
    
    self.modalPresentationStyle = .popover
    self.preferredContentSize = self.popoverSize
    
    var viewController: UIViewController? = inViewController
    
    if viewController == nil {
      viewController = self.window.rootViewController!
    }
    
    let popover = self.popoverPresentationController
    popover?.delegate = self
    popover?.sourceView = sourceView
    popover?.sourceRect = sourceRect
    
    viewController!.present(self, animated: true, completion: { () -> Void in
      // nothing here
    })
  }
  
  /**
   Shows the date picker modal and sets the completion block.
   
   - parameter selection: closure to be executed when new date is selected
   */
  public func show (_ selection: ((AnyObject) -> Void)?) {
    self.onSelection = selection
    
    self.view.alpha = 0.0
    window.addSubview(self.view)
    UIView.animate(withDuration: 0.3, animations: { () -> Void in
      self.view.alpha = 1.0;
    })
  }
  
  /**
   Closes the modal
   */
  public func dismiss() {
    
    if self.shownInPopover {
      self.shownInPopover = false
      super.dismiss(animated: true, completion: nil)
    }
    else {
      UIView.animate(withDuration: 0.3,
                     animations: { () -> Void in
                      self.view.alpha = 0.0;
      }) { (completed) -> Void in
        self.view.removeFromSuperview()
      }
    }
  }
  
  // MARK: Picker View Delegates
  
  public func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return self.pickerDataSource?.count ?? 0
  }
  
  public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return self.pickerDataSource?.object(at: row) as! NSString as String
  }
  
  public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    self.selectedPickerValueIndex = row
  }
}
