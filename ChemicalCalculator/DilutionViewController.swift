//
//  DilutionViewController.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 4/21/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import UIKit
import Material
import CoreData

class DilutionViewController: UIViewController {
    
    // MARK: - Properties
    var compound: Compound?
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
    


    @IBOutlet weak var compoundName: UILabel!
    
    @IBOutlet weak var stockConcentration: UILabel!
    
    @IBOutlet weak var desiredConcentrationTextField: ErrorTextField!
    
    @IBOutlet weak var desiredVolumeTextField: ErrorTextField!
    
    @IBOutlet weak var resultTextField: TextField!
    
    @IBOutlet weak var concentrationUnitPickerView: UIPickerView!
    
    @IBOutlet weak var volumeUnitPickerView: UIPickerView!
    
    @IBOutlet weak var resultUnitPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
