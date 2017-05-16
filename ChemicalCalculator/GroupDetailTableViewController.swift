//
//  GroupDetailTableViewController.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 3/29/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import UIKit
import CoreData
import Mixpanel

class GroupDetailTableViewController: CoreDataTableViewController {
    
    // MARK: - Properties
    var group: Group?
    
    // MARK: - View life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = group?.title
        
        // Set up tableview background view color
        let bgView = UIView()
        bgView.backgroundColor = UIColor.grayWhite()
        tableView.backgroundView = bgView
        
        // hide empty cells
        tableView.tableFooterView = UIView()
        
        // disable row selections
        tableView.allowsSelection = false
        
        // set up table view top distance to navigation bar
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 50, right: 0)
        
        Mixpanel.mainInstance().track(event: "View group detail")
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return group == nil ? 0 : 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group?.ingredients?.count ?? 0
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let ingredients = group?.ingredients {
            let ingredient = ingredients.object(at: indexPath.row) as! Solution
            if ingredient.isDiluted {
                let cell = tableView.dequeueReusableCell(withIdentifier: "dilutionCell", for: indexPath) as! SolutionTableViewCell
                cell.nameLabel.text = ingredient.solute?.name
                cell.concentrationLabel.text = String(describing: ingredient.finalConcentration) + " "
                cell.concentrationUnitLabel.text = ingredient.concentrationUnit
                cell.volumeLabel.text = String(describing: ingredient.finalVolume) + " "
                cell.volumeUnitLabel.text = ingredient.volumeUnit
                cell.stockNeededVolumeLabel.text = String(describing: ingredient.stockNeededVolume) + " "
                cell.stockNeededVolumeUnitLabel.text = ingredient.stockNeededVolumeUnit
                cell.stockConcentrationLabel.text = ingredient.stockConcentration?.components(separatedBy: " ")[0]
                cell.stockConcentrationUnitLabel.text = ingredient.stockConcentration?.components(separatedBy: " ")[1]
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let result = dateFormatter.string(from:ingredient.createdDate! as Date)
                cell.createdDateLabel.text = result
                cell.countLabel.text = String(describing: indexPath.row + 1)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "solutionCell", for: indexPath) as! SolutionTableViewCell
                cell.nameLabel.text = ingredient.solute?.name
                cell.massLabel.text = String(describing: ingredient.soluteMass)
                cell.massUnitLabel.text = ingredient.massUnit
                cell.concentrationLabel.text = String(describing: ingredient.finalConcentration)
                cell.concentrationUnitLabel.text = ingredient.concentrationUnit
                cell.volumeLabel.text = String(describing: ingredient.finalVolume)
                cell.volumeUnitLabel.text = ingredient.volumeUnit
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let result = dateFormatter.string(from: ingredient.createdDate! as Date)
                cell.createdDateLabel.text = result
                cell.countLabel.text = String(describing: indexPath.row + 1)
                return cell
            }
        }
        return UITableViewCell()
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let solution = group?.ingredients?[indexPath.row] as? Solution {
            if solution.isDiluted {
                return 200
            }
            return 180
        }
        return 200
    }
    
    

    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewIngredientToGroup" {
            
            if let navcon = segue.destination as? UINavigationController, let solutionListTVC = navcon.visibleViewController as? SavedSolutionTableViewController {
                solutionListTVC.isEditing = true
            }
        }
    }
    
    @IBAction func unwindToGroupDetailTableViewController(sender: UIStoryboardSegue) {
        
        Mixpanel.mainInstance().track(event: "Add button in GroupDetail VC clicked")
        
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
