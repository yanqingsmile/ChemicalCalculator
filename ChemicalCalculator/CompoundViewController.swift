//
//  CompoundViewController.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 2/20/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import UIKit
import CoreData

class CompoundViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    var name: String = ""
    var formula: String?
    var molecularMass: Double = 0.0
   
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var formulaLabel: UILabel!
    
    @IBOutlet weak var molecularMassLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var formulaTextField: UITextField!
    
    @IBOutlet weak var molecularMassTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    // MARK: - IBActions
    
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func textFieldDidChange() {
        checkValidCompound()
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        formulaTextField.delegate = self
        molecularMassTextField.delegate = self
        
        // Set up views if editing an existing Compound
        navigationItem.title = name
        nameTextField.text = name
        formulaTextField.text = formula
        molecularMassTextField.text = String(molecularMass)
        
        
        
        // Enable the save button only when all the text fields have valid values.
        checkValidCompound()

    }

    
    // MARK: - Text field functions

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        navigationItem.title = nameTextField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - Methods
    private func checkValidCompound() {
        // Disable saveButton when the name or formula or molecular mass is empty.
        let name = nameTextField.text ?? ""
        let molecularMass = Double(molecularMassTextField.text ?? "")
        saveButton.isEnabled = !name.isEmpty && molecularMass != nil
    }
    

    
    // MARK: - Navigation

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let obj = sender as? UIBarButtonItem, saveButton === obj {
            name = nameTextField.text ?? ""
            formula = formulaTextField.text
            molecularMass = Double(molecularMassTextField.text!)!
        }
    }


}
