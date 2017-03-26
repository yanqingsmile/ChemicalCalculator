//
//  SavedSolutionTableViewController.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 3/18/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import UIKit
import CoreData

class SavedSolutionTableViewController: CoreDataTableViewController {
    
    var managedObjectContext: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    fileprivate var solutionCount: Int {
        get {
            var count: Int?
            if let context = managedObjectContext {
                context.performAndWait({
                    count = try? context.count(for: NSFetchRequest(entityName: "Solution"))
                })
            }
            return count ?? 0
        }
    }
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - IBOutlets
    
    @IBOutlet var addToButton: UIBarButtonItem!
    
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    @IBOutlet var selectButton: UIBarButtonItem!
    
    // MARK: - IBActions
    
    @IBAction func selectButtonClicked(_ sender: UIBarButtonItem) {
        tableView.setEditing(true, animated: true)
        tableView.allowsSelectionDuringEditing = true
        updateButtonsToMatchTableState()
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        tableView.setEditing(false, animated: true)
        updateButtonsToMatchTableState()
    }
    
        
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetech data from core data
        if let context = managedObjectContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Solution")
            request.sortDescriptors = [NSSortDescriptor(
                key: "createdDate",
                ascending: false,
                selector: nil
                )]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "solute.uppercaseFirstLetterOfName", cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.selectButton
        
        // Set up search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search from \(solutionCount) saved solutions"
        
        // Allow bulk selection
        tableView.allowsMultipleSelectionDuringEditing = true
        
        updateButtonsToMatchTableState()
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "solutionCell", for: indexPath) as! SolutionTableViewCell
        if let solution = fetchedResultsController?.object(at: indexPath) as? Solution {
            var compound: Compound?
            var conc: Double?
            var concUnit: String?
            var volume: Double?
            var volumeUnit: String?
            var mass: Double?
            var massUnit: String?
            var date: NSDate?
            solution.managedObjectContext?.performAndWait({
                compound = solution.solute
                conc = solution.finalConcentration
                concUnit = solution.concentrationUnit
                volume = solution.finalVolume
                volumeUnit = solution.volumeUnit
                mass = solution.soluteMass
                massUnit = solution.massUnit
                date = solution.createdDate
            })
            cell.nameLabel.text = compound?.name
            cell.concentrationLabel.text = String(describing: conc!) + " "
            cell.concentrationUnitLabel.text = concUnit
            cell.volumeLabel.text = String(describing: volume!) + " "
            cell.volumeUnitLabel.text = volumeUnit
            cell.massLabel.text = String(describing: mass!) + " "
            cell.massUnitLabel.text = massUnit
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let result = dateFormatter.string(from: date as! Date)
            cell.createdDateLabel.text = result
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
            // Delete the row from the data source
            if let solutionToDelete = fetchedResultsController?.object(at: indexPath) as? Solution {
                managedObjectContext?.delete(solutionToDelete)
                try? managedObjectContext?.save()
            }
            // Below code is not needed, because the CoreDataTVC which implements fetchedResultsController delegate will handle the change in UI.
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Override to remove section footer.
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    // MARK: - Methods
    func filterContentForSearchText(searchText: String?) {
        if let context = managedObjectContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Solution")
            if let searchText = searchText, searchText != "" {
                request.predicate = NSPredicate(format: "any solute.name contains[c] %@", searchText)
            }
            request.sortDescriptors = [NSSortDescriptor(
                key: "solute.name",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                ), NSSortDescriptor(
                    key: "createdDate",
                    ascending: false,
                    selector: nil)
            ]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
    }
    
    fileprivate func updateButtonsToMatchTableState() {
        if tableView.isEditing {
            navigationItem.rightBarButtonItem = addToButton
            navigationItem.leftBarButtonItem = cancelButton
        } else {
            navigationItem.rightBarButtonItem = selectButton
            navigationItem.leftBarButtonItem = nil
        }
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

// MARK: - Delegation Methods
extension SavedSolutionTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchText: searchBar.text)
    }
}

extension SavedSolutionTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchText: searchBar.text)
    }
}


