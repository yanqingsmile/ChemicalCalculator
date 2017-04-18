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
    
    @IBOutlet weak var nameTextField: TextField!
    
    @IBOutlet weak var formulaTextField: TextField!
    
    @IBOutlet weak var molecularMassTextField: ErrorTextField!
    
    @IBOutlet weak var purityTextField: ErrorTextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
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
        nameTextField.delegate = self
        formulaTextField.delegate = self
        molecularMassTextField.delegate = self
        purityTextField.delegate = self
        
        // Set up views if editing an existing Compound
        self.title = name
        nameTextField.text = name
        formulaTextField.text = formula
        molecularMassTextField.text = String(molecularMass)
        purityTextField.text = String(purity * 100)
        
        
        // Enable the save button only when all the text fields have valid values.
        checkValidCompound()

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
            purity = Double(purityTextField.text!)!
        }
    }


}

// MARK: - TextFieldDelegate
extension CompoundViewController: TextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField is ErrorTextField {
            //textFieldDidChange(textField as! ErrorTextField)
        }
    }
    
    public func textField(textField: UITextField, didClear text: String?) {
        if textField is ErrorTextField {
            //textFieldDidChange(textField as! ErrorTextField)
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        
        return true
    }
}

