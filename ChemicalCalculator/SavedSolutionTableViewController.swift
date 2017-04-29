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
        if presentingViewController != nil {
            presentingViewController?.dismiss(animated: true, completion: nil)
        } else {
            tableView.setEditing(false, animated: true)
            updateButtonsToMatchTableState()
        }
    }
    
    
    @IBAction func addToButtonClicked(_ sender: UIBarButtonItem) {
        if presentingViewController == nil {
            performSegue(withIdentifier: "addToGroup", sender: self)
        } else {
            performSegue(withIdentifier: "addToSourceGroup", sender: self)
        }
    }
    
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
        // Set up tableview background view color
        let bgView = UIView()
        bgView.backgroundColor = UIColor.grayWhite()
        tableView.backgroundView = bgView
       
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.selectButton
        
        // Set up search controller
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        refreshPlaceholderText()
        
        // Allow bulk selection
        tableView.allowsMultipleSelectionDuringEditing = true
        
        updateButtonsToMatchTableState()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Fetech data from core data
        if let context = managedObjectContext {
            context.performAndWait({
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Solution")
                request.sortDescriptors = [NSSortDescriptor(
                    key: "createdDate",
                    ascending: false,
                    selector: nil
                    )]
                self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            })
        } else {
            fetchedResultsController = nil
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var compound: Compound?
        var conc: Double?
        var concUnit: String?
        var volume: Double?
        var volumeUnit: String?
        var mass: Double?
        var massUnit: String?
        var date: NSDate?
        var isDiluted = false
        var stockConcentrationText: String?
        var stockNeededVolume: Double?
        var stockNeededVolumeUnit: String?
        
        if let context = managedObjectContext {
            context.performAndWait({
                if let solution = self.fetchedResultsController?.object(at: indexPath) as? Solution {
                    compound = solution.solute
                    conc = solution.finalConcentration
                    concUnit = solution.concentrationUnit
                    volume = solution.finalVolume
                    volumeUnit = solution.volumeUnit
                    mass = solution.soluteMass
                    massUnit = solution.massUnit
                    date = solution.createdDate
                    isDiluted = solution.isDiluted
                    stockConcentrationText = solution.stockConcentration
                    stockNeededVolume = solution.stockNeededVolume
                    stockNeededVolumeUnit = solution.stockNeededVolumeUnit
                }
            })
            
        }

        if isDiluted {
            let cell = tableView.dequeueReusableCell(withIdentifier: "dilutionCell", for: indexPath) as! SolutionTableViewCell
            cell.nameLabel.text = compound?.name
            cell.concentrationLabel.text = String(describing: conc!) + " "
            cell.concentrationUnitLabel.text = concUnit
            cell.volumeLabel.text = String(describing: volume!) + " "
            cell.volumeUnitLabel.text = volumeUnit
            cell.stockNeededVolumeLabel.text = String(describing: stockNeededVolume!) + " "
            cell.stockNeededVolumeUnitLabel.text = stockNeededVolumeUnit
            cell.stockConcentrationLabel.text = stockConcentrationText?.components(separatedBy: " ")[0]
            cell.stockConcentrationUnitLabel.text = stockConcentrationText?.components(separatedBy: " ")[1]
                        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let result = dateFormatter.string(from: date! as Date)
            cell.createdDateLabel.text = result
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "solutionCell", for: indexPath) as! SolutionTableViewCell
            cell.nameLabel.text = compound?.name
            cell.concentrationLabel.text = String(describing: conc!) + " "
            cell.concentrationUnitLabel.text = concUnit
            cell.volumeLabel.text = String(describing: volume!) + " "
            cell.volumeUnitLabel.text = volumeUnit
            cell.massLabel.text = String(describing: mass!) + " "
            cell.massUnitLabel.text = massUnit
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let result = dateFormatter.string(from: date! as Date)
            cell.createdDateLabel.text = result
            return cell
        }
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        updateButtonsToMatchTableState()
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        updateButtonsToMatchTableState()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let solution = fetchedResultsController?.object(at: indexPath) as? Solution {
            if solution.isDiluted {
                return 200
            } else {
                return 180
            }
        }
        return 200
    }
    

 

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let context = managedObjectContext {
                context.performAndWait({
                    if let solutionToDelete = self.fetchedResultsController?.object(at: indexPath) as? Solution {
                        context.delete(solutionToDelete)
                        try? context.save()
                    }
                })
            }
            
            // Below code is not needed, because the CoreDataTVC which implements fetchedResultsController delegate will handle the change in UI.
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Override to remove section footer.
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    override func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        super.controllerDidChangeContent(controller)
        refreshPlaceholderText()
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
            addToButton.isEnabled = tableView.indexPathsForSelectedRows?.count ?? 0 > 0
            navigationItem.leftBarButtonItem = cancelButton
        } else {
            navigationItem.rightBarButtonItem = selectButton
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    fileprivate func refreshPlaceholderText() {
        searchController.searchBar.placeholder = "Search from \(solutionCount) saved solution"
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
 
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return !tableView.isEditing
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addToGroup" {
            let naVC = segue.destination as! UINavigationController
            let addToTemporaryTVC = naVC.visibleViewController as! AddToTemporaryTableViewController
            if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
                let selectedSolutions = selectedIndexPaths.map{fetchedResultsController?.object(at: $0) as! Solution}
                addToTemporaryTVC.toAddSolutions = selectedSolutions
            }
        } else if segue.identifier == "make a dilution" {
            let calculatorVC = segue.destination as! CalculatorViewController
            calculatorVC.style = .dilution
            if let selectedCell = sender as? UITableViewCell {
                let selectedIndexPath = tableView.indexPath(for: selectedCell)
                let selectedSolution = fetchedResultsController?.object(at: selectedIndexPath!) as! Solution
                calculatorVC.stockSolution = selectedSolution
                calculatorVC.compound = selectedSolution.solute
            }
        }
    }
 
    
    @IBAction func unwindToSavedSolutionTVC(sender: UIStoryboardSegue) {
    }
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


