//
//  CalculatorViewController.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 3/5/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import UIKit
import CoreData
import Material

enum CalculatorViewControllerStyle {
    case weight, dilution
}

class CalculatorViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    // MARK: - Properties
    var compound: Compound?
    var stockSolution: Solution?
    var style: CalculatorViewControllerStyle = .weight
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var result: Double {
        get {
           return Double(resultTextField.text!)!
        }
        set {
            resultTextField.text = newValue != 0 ? String(describing: newValue) : ""
        }
    }
    
    let concentrationUnits = ["nmol/L", "mmol/L", "mol/L", "g/L", "g/mL", "mg/L", "kg/L"]
    let volumeUnits = ["uL", "mL", "L"]
    let massUnits = ["mg", "g", "kg"]
    
    
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var finalConcTextField: ErrorTextField!
    
    @IBOutlet weak var finalVolumeTextField: ErrorTextField!
    
    @IBOutlet weak var resultTextField: TextField!
    
    @IBOutlet weak var concentrationUnitPickerView: UIPickerView!
    
    @IBOutlet weak var volumeUnitPickerView: UIPickerView!
    
    @IBOutlet weak var resultUnitPickerView: UIPickerView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: - IBActions
    @IBAction func textFieldDidChange(_ sender: ErrorTextField) {
        sender.isErrorRevealed = checkValidInput(in: sender)
        if sender.isErrorRevealed {
            sender.detail = "Invalid number"
        }
        checkValidSolution()
        performCalculation()
    }
    
    fileprivate func checkValidInput(in textField: ErrorTextField) -> Bool{
        return (!textField.text!.isEmpty) && (Double(textField.text!) == nil)
    }
    
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        if let volume = Double(finalVolumeTextField.text!),
            let conc = Double(finalConcTextField.text!),
            let mass = Double(resultTextField.text!)
        {
            let volumeUnit = volumeUnits[volumeUnitPickerView.selectedRow(inComponent: 0)]
            let concUnit = concentrationUnits[concentrationUnitPickerView.selectedRow(inComponent: 0)]
            let massUnit = massUnits[resultUnitPickerView.selectedRow(inComponent: 0)]
            
            if let context = managedObjectContext {
                context.performAndWait({
                    if let newSolution = NSEntityDescription.insertNewObject(forEntityName: "Solution", into: context) as? Solution {
                        newSolution.solute = self.compound
                        newSolution.soluteMass = mass
                        newSolution.massUnit = massUnit
                        newSolution.finalConcentration = conc
                        newSolution.concentrationUnit = concUnit
                        newSolution.finalVolume = volume
                        newSolution.volumeUnit = volumeUnit
                        newSolution.createdDate = NSDate()
                    }
                    try? context.save()
                })
            }
            saveButton.isEnabled = false
        }
        
    }
    
    // MARK: - View set up
    override func viewDidLoad() {
        super.viewDidLoad()
        // change navigation bar backItem title
        let backItem = UIBarButtonItem()
        switch style {
        case .weight:
            backItem.title = "Library"
            if let compound = compound {
                nameLabel.text = compound.name
                detailLabel.text = String(compound.molecularMass) + " g/mol"
            }
        case .dilution:
            backItem.title = "Stock Solution"
            if let stockSolution = stockSolution {
                nameLabel.text = stockSolution.solute?.name
                detailLabel.text = String(describing: stockSolution.finalConcentration) + " " + String(describing: stockSolution.concentrationUnit)
            }
        }
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = backItem
    

        concentrationUnitPickerView.selectRow(3, inComponent: 0, animated: true)
        volumeUnitPickerView.selectRow(1, inComponent: 0, animated: true)
        resultUnitPickerView.selectRow(1, inComponent: 0, animated: true)
        
        checkValidSolution()
        
        removeSelectionIndicator(in: concentrationUnitPickerView)
        removeSelectionIndicator(in: volumeUnitPickerView)
        removeSelectionIndicator(in: resultUnitPickerView)
    }
    
    // remove pickerView seperator line
    fileprivate func removeSelectionIndicator(in pickerView: UIPickerView) {
        pickerView.subviews[1].isHidden = true
        pickerView.subviews[2].isHidden = true
    }
    
    // MARK: - UIPickerView delegate and data source
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case concentrationUnitPickerView: return concentrationUnits[row]
        case volumeUnitPickerView: return volumeUnits[row]
        case resultUnitPickerView:
            switch style {
            case .weight:
                return massUnits[row]
            case .dilution:
                return volumeUnits[row]
            }
        default: return nil
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case concentrationUnitPickerView: return concentrationUnits.count
        case volumeUnitPickerView: return volumeUnits.count
        case resultUnitPickerView:
            switch style {
            case .weight:
                return massUnits.count
            case .dilution:
                return volumeUnits.count
            }
        default: return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        performCalculation()
    }
    // MARK: - Constants

    // MARK: - Private methods
    
    
    // convert user input conc unit to g/L
    fileprivate func convertToStandardConc(fromInputConc conc: String?, withUnit unit: String) -> Double? {
        if let molecularMass = compound?.molecularMass {
            let inputConcentration = Double(conc ?? "0") ?? 0
            switch unit {
            case "nmol/L":
                return inputConcentration * molecularMass / 1000000
            case "mmol/L":
                return inputConcentration * molecularMass/1000
            case "mol/L":
                return inputConcentration * molecularMass
            case "g/L":
                return inputConcentration
            case "mg/L":
                return inputConcentration / 1000
            case "g/mL":
                return inputConcentration * 1000
            case "kg/L":
                return inputConcentration * 1000
            default:
                return nil
            }
        }
        return nil
    }
    
    // convert user input volume unit to L
    fileprivate func convertToStandardVolume(fromInputVolume volume: String?, withUnit unit: UIPickerView) -> Double? {
        let inputVolume = Double(volume ?? "0") ?? 0
        switch volumeUnits[unit.selectedRow(inComponent: 0)] {
        case "uL":
            return inputVolume / 1000000
        case "mL":
            return inputVolume / 1000
        case "L":
            return inputVolume
        default:
            return nil
        }
    }
    
    //convert computed mass result from g to user choosed unit
    fileprivate func convertToUserChoosedMassUnit(fromComputedMass mass: Double, toUnit unit: UIPickerView) -> Double? {
        switch massUnits[unit.selectedRow(inComponent: 0)] {
        case "mg":
            return mass * 1000
        case "g":
            return mass
        case "kg":
            return mass / 1000
        default:
            return nil
        }
    }
    
    //convert computed volume result from L to user choosed unit
    fileprivate func convertToUserChoosedVolumeUnit(fromComputedVolume volume: Double, toUnit unit: UIPickerView) -> Double? {
        switch  volumeUnits[unit.selectedRow(inComponent: 0)] {
        case "uL":
            return volume * 1000000
        case "mL":
            return volume * 1000
        case "L":
            return volume
        default:
            return nil
        }
    }
    
    // perform calculation
    fileprivate func performCalculation() {
        if let conc = convertToStandardConc(fromInputConc: finalConcTextField.text, withUnit: concentrationUnits[concentrationUnitPickerView.selectedRow(inComponent: 0)]), let volume = convertToStandardVolume(fromInputVolume: finalVolumeTextField.text, withUnit: volumeUnitPickerView) {
            switch style {
            case .weight:
                let mass = conc * volume
                result = convertToUserChoosedMassUnit(fromComputedMass: mass, toUnit: resultUnitPickerView)!
            case .dilution:
                if let stockConcentration = convertToStandardConc(fromInputConc: String(describing:stockSolution!.finalConcentration), withUnit: stockSolution!.concentrationUnit!) {
                    let stockVolume = conc * volume / stockConcentration
                    result = convertToUserChoosedVolumeUnit(fromComputedVolume: stockVolume, toUnit: resultUnitPickerView)!
                }
                
            }
        }
    }
        
    
    fileprivate func checkValidSolution() {
        let volume = Double(finalVolumeTextField.text!)
        let conc = Double(finalConcTextField.text!)
        saveButton.isEnabled = (volume != nil && conc != nil)
    
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

// MARK: - TextFieldDelegate
extension CalculatorViewController: TextFieldDelegate {
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField is ErrorTextField {
            textFieldDidChange(textField as! ErrorTextField)
        }
    }
    
    public func textField(textField: UITextField, didClear text: String?) {
        if textField is ErrorTextField {
            textFieldDidChange(textField as! ErrorTextField)
        }
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        performCalculation()
        return true
    }
}

