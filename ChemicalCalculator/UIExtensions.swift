//
//  UIExtensions.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 4/20/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    //let mintBlue = UIColor(red: 145/255.0, green: 186/255.0, blue: 185/255.0, alpha: 1.0)
    static func mintBlue() -> UIColor {
        return UIColor(red: 145/255.0, green: 186/255.0, blue: 185/255.0, alpha: 1.0)
    }

    static func warmOrange() -> UIColor {
        return UIColor(red: 238/255.0, green: 180/255.0, blue: 122/255.0, alpha: 1.0)
    }
    
    static func grayWhite() -> UIColor {
        return UIColor(red: 251/255.0, green: 248/255.0, blue: 243/255.0, alpha: 1.0)
    }
}

extension UIViewController {
     func addDoneButtonOnKeyboard(toTextField textField: UITextField) {
        
        let doneToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolBar.barStyle = .default
        
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        var items = [UIBarButtonItem]()
        items.append(done)
        
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        
        textField.inputAccessoryView = doneToolBar
       
    }
    
    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
