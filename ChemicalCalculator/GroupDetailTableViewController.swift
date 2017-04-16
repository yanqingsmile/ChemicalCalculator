//
//  GroupDetailTableViewController.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 3/29/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import UIKit
import CoreData

class GroupDetailTableViewController: CoreDataTableViewController {
    
    // MARK: - Properties
    var group: Group?
    
    
    
    
    // MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return group == nil ? 0 : 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group?.ingredients?.count ?? 0
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "solutionCell", for: indexPath) as! SolutionTableViewCell
        if let ingredients = group?.ingredients {
                            let ingredient = ingredients.object(at: indexPath.row) as! Solution
                cell.nameLabel.text = ingredient.solute?.name
                cell.massLabel.text = String(describing: ingredient.soluteMass)
                cell.massUnitLabel.text = ingredient.massUnit
                cell.concentrationLabel.text = String(describing: ingredient.finalConcentration)
                cell.concentrationUnitLabel.text = ingredient.concentrationUnit
                cell.volumeLabel.text = String(describing: ingredient.finalVolume)
                cell.volumeUnitLabel.text = ingredient.volumeUnit
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let result = dateFormatter.string(from: ingredient.createdDate as! Date)
                cell.createdDateLabel.text = result
                cell.countLabel.text = String(describing: indexPath.row + 1)
            
            
        }
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let ingredientToDelete = self.group?.ingredients?[indexPath.row] as? Solution, let context = group?.managedObjectContext {
                context.performAndWait({
                    let mutableIngredients = self.group!.ingredients!.mutableCopy() as! NSMutableOrderedSet
                    mutableIngredients.remove(ingredientToDelete)
                    self.group!.ingredients = mutableIngredients.copy() as? NSOrderedSet
                    try? context.save()
                })
                tableView.reloadData()
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewIngredientToGroup" {
            
            if let navcon = segue.destination as? UINavigationController, let solutionListTVC = navcon.visibleViewController as? SavedSolutionTableViewController {
                solutionListTVC.isEditing = true
            }
        }
    }
    
    @IBAction func unwindToGroupDetailTableViewController(sender: UIStoryboardSegue) {
        if let sourceTVC = sender.source as? SavedSolutionTableViewController, let selectedIndexPaths = sourceTVC.tableView.indexPathsForSelectedRows {
            let selectedSolutions = selectedIndexPaths.map{sourceTVC.fetchedResultsController?.object(at: $0) as! Solution}
            group!.managedObjectContext?.performAndWait({
                let mutableIngredients = self.group!.ingredients!.mutableCopy() as! NSMutableOrderedSet
                mutableIngredients.addObjects(from: selectedSolutions)
                self.group!.ingredients = mutableIngredients.copy() as? NSOrderedSet
                try? self.group!.managedObjectContext?.save()
                
            })
        }
        tableView.reloadData()
    }
}
