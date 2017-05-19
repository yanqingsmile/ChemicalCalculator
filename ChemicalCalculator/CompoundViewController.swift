//
//  CompoundViewController.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 2/20/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import UIKit
import CoreData
import Material

class CompoundViewController: UIViewController {
    
    // MARK: - Properties
    var name: String = ""
    var formula: String?
    var molecularMass: Double = 0.0
    var purity: Double = 1.0
   
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var nameTextField: TextField!
    
    @IBOutlet weak var formulaTextField: TextField!
    
    @IBOutlet weak var molecularMassTextField: ErrorTextField!
    
    @IBOutlet weak var purityTextField: ErrorTextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    fileprivate var textFields: [TextField] {
        return [nameTextField, formulaTextField, molecularMassTextField, purityTextField]
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        if presentingViewController != nil {
            presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func textFieldDidChange(_ sender: TextField) {
        self.title = nameTextField.text
        if let errorTextFieldSender = sender as? ErrorTextField {
            errorTextFieldSender.isErrorRevealed = checkValidInput(in: errorTextFieldSender)
            if errorTextFieldSender.isErrorRevealed {
                errorTextFieldSender.detail = "Invalid number"
            }
        }
        checkValidCompound()
    }
    
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFields.forEach({
            $0.delegate = self
            $0.dividerNormalColor = UIColor.warmOrange()
        })
        
        // Set up views if editing an existing Compound
        self.title = name
        nameTextField.text = name
        formulaTextField.text = formula
        molecularMassTextField.text = String(molecularMass)
        purityTextField.text = String(purity * 100)
        
        
        // Enable the save button only when all the text fields have valid values.
        checkValidCompound()
        
        // Add Done button on keyboard
        self.addDoneButtonOnKeyboard(toTextField: molecularMassTextField)
        self.addDoneButtonOnKeyboard(toTextField: purityTextField)
    }
    
    // Scroll the scroll view when keyboard appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotifications()
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CompoundViewController.keyboardDidShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(CompoundViewController.keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 10, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

    }
    
    
    // MARK: - Methods
    fileprivate func checkValidCompound() {
        // Disable saveButton when the name or formula or molecular mass is empty.
        let name = nameTextField.text ?? ""
        let molecularMass = Double(molecularMassTextField.text!)
        let purity = Double(purityTextField.text!)
        saveButton.isEnabled = !name.isEmpty && molecularMass != nil && purity != nil
    }
    
    fileprivate func checkValidInput(in textField: ErrorTextField) -> Bool{
        return (!textField.text!.isEmpty) && (Double(textField.text!) == nil)
    }

    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let obj = sender as? UIBarButtonItem, saveButton === obj {
            name = nameTextField.text ?? ""
            formula = formulaTextField.text
            molecularMass = Double(molecularMassTextField.text!)!
            purity = Double(purityTextField.text!)! / 100
        }
    }
}

// MARK: - TextFieldDelegate
extension CompoundViewController: TextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        return true
    }
}

