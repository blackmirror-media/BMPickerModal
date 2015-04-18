# BMPickerModal

BMPickerModal is an iOS drop-in class that displays a UIPicker or a UIDatePicker as modal view or in a popover controller on the iPad. Used to let the user select from a list of data or pick a date without leaving the current screen. Closures allow easy customisation.


## Requirements

Built in Swift 1.2 for iOS 8.1+. All devices supported.

## Adding BMPickerModal To Your Project

### Cocoapods

CocoaPods is the recommended way to add BMPickerModal to your project. 

```
pod 'BMPickerModal'
```

### Usage 

#### Creating 

```Swift
var datePickerModal = BMPickerModal()
```

#### Showing On The iPhone

```Swift
datePickerModal?.show({ (selectedDate) -> Void in
    let theNewDate = selectedDate as! NSDate
    // Do something with the date here
})
```

**Checking whether the control is visible**

```Swift
let visible: Bool = datePickerModal.isVisible
```

#### Showing On The iPad

`selection`: Closure to be executed when date/data is selected
`sourceView`: View to show from
`sourceRect`: CGRect to align to
`inViewController`: ViewController used to present the modal

```Swift
datePickerModal?.showInPopover({ (selectedDate) -> Void in
    let theNewDate = selectedDate as! NSDate
    // Do something with the date here
}, sourceView: self.view, sourceRect: cell!.frame, inViewController: self)
```

**Checking whether the control is shown in a popover**

```Swift
let inPopover: Bool = datePickerModal.shownInPopover
```

#### Dismissing

```Swift
datePickerModal?.dismiss()
```

Available styles:
* `.PlainTextInput` - Simple text field
* `.NumberInput` - Text field accepting numbers only - numeric keyboard

#### Customising the DatePicker

Access the UIDatePicker view and cusomise as per the Apple documentation.

```Swift
datePickerModal?.datePicker.datePickerMode = UIDatePickerMode.Date
```