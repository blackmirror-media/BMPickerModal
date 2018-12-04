//
//  ViewController.swift
//  BMPickerModal
//
//  Created by Adam Eri on 10/19/2017.
//  Copyright (c) 2017 Adam Eri. All rights reserved.
//

import UIKit
import BMPickerModal

class ViewController: UIViewController {

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
