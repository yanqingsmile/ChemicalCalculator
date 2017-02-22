//
//  SearchTableViewController.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 2/17/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: CoreDataTableViewController {
    
    //MARK: - Properties
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    //    private var filtedCompounds = [Compound]()
    
    //let searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // fetch data from database
        if let context = managedObjectContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Compound")
            request.sortDescriptors = [NSSortDescriptor(
                key: "name",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
        
        
        
        
        // Set up searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        let count = (UIApplication.shared.delegate as! AppDelegate).compoundCount
        searchController.searchBar.placeholder = "Search from \(count) compounds"
        searchController.searchBar.delegate = self
        searchController.searchBar.scopeButtonTitles = ["name", "formula"]
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
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
    
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let compoundVC = segue.destination as! NewCompoundViewController
                if let selectedCell = sender as? UITableViewCell {
                   let indexPath = tableView.indexPath(for: selectedCell)
                    let selectedCompound = fetchedResultsController?.object(at: indexPath!) as! Compound
                    compoundVC.compound = selectedCompound
                }
        } else if segue.identifier == "addNewCompound" {
        }
     }
    
    
    // MARK: - Methods
    func filterContentForSearchText(searchText: String?, scope: String){
        if let context = managedObjectContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Compound")
            if let searchText = searchText, searchText != "" {
                if scope == "name" {
                    request.predicate = NSPredicate(format: "any name contains[c] %@", searchText)
                } else if scope == "formula" {
                    request.predicate = NSPredicate(format: "any formula contains[c] %@", searchText)
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
    
    func unwindToSearchTVC(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewCompoundViewController, let compound = sourceViewController.compound {
            // update an exiting meal
            
        }
    }
    
    
    
}

// MARK: - Delegation Methods
extension SearchTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchText: searchController.searchBar.text, scope: scope)
    }
    
}


extension SearchTableViewController: UISearchBarDelegate {
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



