//
//  NewCompoundViewController.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 2/20/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import UIKit

class NewCompoundViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    var compound: Compound?
    
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
        if let editedCompound = compound {
            navigationItem.title = editedCompound.name
            nameTextField.text = editedCompound.name
            formulaTextField.text = editedCompound.formula
            molecularMassTextField.text = String(editedCompound.molecularMass)
        }
        
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
        let formula = formulaTextField.text ?? ""
        let molecularMass = Double(molecularMassTextField.text ?? "")
        saveButton.isEnabled = !name.isEmpty && !formula.isEmpty && molecularMass != nil
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
