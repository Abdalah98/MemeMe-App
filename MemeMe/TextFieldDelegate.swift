//
//  TextFieldDelegate.swift
//  MemeMe
//
//  Created by Abdalah on 4/3/19.
//  Copyright © 2019 Abdalah. All rights reserved.
//

import UIKit
import Foundation

class TextFieldDelegate: UIViewController ,UITextFieldDelegate,UINavigationControllerDelegate{

    // textfield
    // Hide keyboard on pressing return

  
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
      // Clear default texts from text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
         if (textField.text == "TOP" || textField.text == "BOTTOM") {
        textField.text = ""
        textField.text?.removeAll()
        }
}
    
    
    
}
