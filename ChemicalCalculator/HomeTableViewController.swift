//
//  HomeTableViewController.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 2/17/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import UIKit
import CoreData
import Mixpanel

class HomeTableViewController: CoreDataTableViewController {
    
    //MARK: - Properties
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate var indexPathOfTappedAccessoryButton: IndexPath?
    
    
    //    private var filtedCompounds = [Compound]()
    
    //let searchController = UISearchController(searchResultsController: nil)
    
    override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        super.controllerDidChangeContent(controller)
        refreshPlaceholderText()
    }
    
    fileprivate func refreshPlaceholderText() {
        let count = (UIApplication.shared.delegate as! AppDelegate).compoundCount
        searchController.searchBar.placeholder = "Search from \(count) compounds"
    }
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // fetch data from database
        if let context = managedObjectContext {
            context.performAndWait({ 
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Compound")
                request.sortDescriptors = [NSSortDescriptor(
                    key: "name",
                    ascending: true,
                    selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                    )]
                self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
                })
        } else {
            fetchedResultsController = nil
        }
        
        
        // Set up searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        refreshPlaceholderText()
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["name", "formula"]
        
        // Set up tableview background view color
        let bgView = UIView()
        bgView.backgroundColor = UIColor.grayWhite()
        tableView.backgroundView = bgView
        
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompoundCell", for: indexPath)
        if let compound = fetchedResultsController?.object(at: indexPath) as? Compound {
            var name: String?
            var formula: String?
            compound.managedObjectContext?.performAndWait({
                name = compound.name
                formula = compound.formula
            })
            cell.textLabel?.text = name
            cell.detailTextLabel?.text = formula
        }
        return cell
    }
    

     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
        return true
     }
    
    
    
     // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let compoundToDelete = fetchedResultsController?.object(at: indexPath) as? Compound {
                if let context = managedObjectContext {
                    context.performAndWait({
                        context.delete(compoundToDelete)
                        try? context.save()
                    })
                }
                               // Below code is not needed, because the CoreDataTVC which implements fetchedResultsController delegate will handle the change in UI.
                //tableView.deleteRows(at: [indexPath], with: .fade)
            }  
        }
    }
    
    // Override to remove section footer.
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    
    
    
    // MARK: - Methods
    func filterContentForSearchText(searchText: String?, scope: String){
        if let context = managedObjectContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Compound")
            if let searchText = searchText, searchText != "" {
                if scope == "name" {
                    request.predicate = NSPredicate(format: "name contains[c] %@", searchText)
                } else if scope == "formula" {
                    request.predicate = NSPredicate(format: "formula contains[c] %@", searchText)
                }
            }
            request.sortDescriptors = [NSSortDescriptor(
                key: "name",
                ascending: true,
                selector:#selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            Mixpanel.mainInstance().track(event: "View compound detail")
            let compoundVC = segue.destination as! CompoundViewController
            if let cellForTappedAccessory = sender as? UITableViewCell {
                indexPathOfTappedAccessoryButton = tableView.indexPath(for: cellForTappedAccessory)
                let selectedCompound = fetchedResultsController?.object(at: indexPathOfTappedAccessoryButton!) as! Compound
                compoundVC.name = selectedCompound.name!
                compoundVC.formula = selectedCompound.formula
                compoundVC.molecularMass = selectedCompound.molecularMass
            }
        } else if segue.identifier == "calculate" {
            Mixpanel.mainInstance().track(event: "Mass calculator")
            
            let calculatorVC = segue.destination as! CalculatorViewController
            calculatorVC.style = .weight
            if let selectedCell = sender as? UITableViewCell {
                let selectedIndexPath = tableView.indexPath(for: selectedCell)
                let selectedCompound = fetchedResultsController?.object(at: selectedIndexPath!) as! Compound
                calculatorVC.compound = selectedCompound
            }
            
        } else if segue.identifier == "addNewCompound" {
            Mixpanel.mainInstance().track(event: "Add New Compound")
        }
    }

    
    @IBAction func unwindToSearchTVC(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CompoundViewController {
            let name = sourceViewController.name
            let molecularMass = sourceViewController.molecularMass
            let formula = sourceViewController.formula
            let purity = sourceViewController.purity
            // update an exiting compound
            if let context = managedObjectContext {
                context.performAndWait({
                    if let selectedIndexPath = self.indexPathOfTappedAccessoryButton {
                        let selectedCompound = self.fetchedResultsController?.object(at: selectedIndexPath) as! Compound
                        selectedCompound.setValue(name, forKey: "name")
                        selectedCompound.setValue(formula, forKey: "formula")
                        selectedCompound.setValue(molecularMass, forKey: "molecularMass")
                        selectedCompound.setValue(purity, forKey: "purity")
                        self.indexPathOfTappedAccessoryButton = nil
                    } else {
                        // add a new compound
                        if let newCompound = NSEntityDescription.insertNewObject(forEntityName: "Compound", into: context) as? Compound {
                            newCompound.name = name
                            newCompound.formula = formula
                            newCompound.molecularMass = molecularMass
                            newCompound.purity = purity
                        }
                    }
                    try? context.save()
                })
                
            }
        }
    }
    
    
    
    
}

// MARK: - Delegation Methods
extension HomeTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text, scope: scope)
    }
    
}


extension HomeTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text, scope: scope)
    }
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text, scope: scope)
    }
}



