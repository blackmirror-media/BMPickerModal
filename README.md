# BMPickerModal

BMPickerModal is an iOS drop-in class that displays a UIPicker or a
UIDatePicker as modal view or in a popover controller on the iPad. Used
to let the user select from a list of data or pick a date without leaving the
current screen. Closures allow easy customisation.


## Requirements

Built in Swift 4 for iOS 10.0+. All devices supported. can be used in both
Swift and in ObjectiveC projects.

## Adding BMPickerModal To Your Project

### Cocoapods

CocoaPods is the recommended way to add BMPickerModal to your project.
As BMPickerModal is written in Swift, you need to add the `use_frameworks!`
option to your podfile.

```
pod 'BMPickerModal'
```

### Usage 


Import the module to your project.

```Swift
import BMPickerModal
```

#### Creating 

Create an optional stored property for your `BMPickerModal`. Then instantiate the control,
when the your view is already added to the window. This is needed for the control to be
added properly.

```Swift
class SomeClass {
  var datePickerModal: BMPickerModal?

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    self.datePickerModal = BMPickerModal()
    self.datePickerModal?.mode = .datePicker

    self.datePickerModal?.show { selectedDate in
      print(selectedDate)
      // Do something with the date here
    }
  }
}
```

Available modes:
* `.datePicker` - Default
* `.picker` 


#### Showing On The iPhone

```Swift
datePickerModal?.show { selectedDate in
  print(selectedDate)
  // Do something with the date here
}
```

**Checking whether the control is visible**

```Swift
let visible: Bool = self.datePickerModal?.isVisible
```

#### Showing On The iPad

`selection`: Closure to be executed when date/data is selected
`sourceView`: View to show from
`sourceRect`: CGRect to align to
`inViewController`: ViewController used to present the modal

```Swift
self.datePickerModal?
  .showInPopover({ (selectedDate) -> Void in
    let theNewDate = selectedDate as! NSDate
  },
  sourceView: self.view,
  sourceRect: cell!.frame,
  inViewController: self)
```

**Checking whether the control is shown in a popover**

```Swift
let inPopover: Bool = self.datePickerModal.shownInPopover
```

#### Dismissing

```Swift
self.datePickerModal?.dismiss()
```

You can add custom actions to the dismissal event by defining the onDismiss
closure.

```Swift
self.datePickerModal?.onDismiss = {
  // do stuff when dismissed
}
```

#### Customising the DatePicker

Access the UIDatePicker view and cusomise as per the Apple documentation.

```Swift
self.datePickerModal?.datePicker.datePickerMode = UIDatePickerMode.date
```

#### Customising the Picker

Set the `pickerDataSource` NSArray property for filling the UIPickerView.


