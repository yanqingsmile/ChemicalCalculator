//
//  CalculatorViewController.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 3/5/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    var compound: Compound?
    var mass: Double = 0.0
    
    // MARK: - IBOutlets
    @IBOutlet weak var finalConcTextField: UITextField!
    
    @IBOutlet weak var finalVolumeTextField: UITextField!
    
    @IBOutlet weak var massTextField: UITextField!
    
    // MARK: - IBActions
    
    @IBAction func chooseConcUnit(_ sender: UIButton) {
    }
    
    @IBAction func chooseVolUnit(_ sender: UIButton) {
    }
    
    
    @IBAction func calculateButtonClicked(_ sender: Any) {
    }
    
    
    @IBAction func chooseMassUnit(_ sender: UIButton) {
    }
    
    // MARK: - View set up
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
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
