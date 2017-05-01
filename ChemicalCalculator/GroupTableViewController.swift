//
//  GroupTableViewController.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 3/29/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import UIKit
import CoreData
import Mixpanel

class GroupTableViewController: CoreDataTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch data from database
        if let context = managedObjectContext {
            context.performAndWait({ 
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Group")
                request.sortDescriptors = [NSSortDescriptor(key: "modifiedDate", ascending: false, selector: nil),NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
                self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            })
        } else {
            fetchedResultsController = nil
        }
        
        Mixpanel.mainInstance().track(event: "Group view controller loaded")
        
        // hide empty cells
        tableView.tableFooterView = UIView()
        
        // Set up tableview background view color
        let bgView = UIView()
        bgView.backgroundColor = UIColor.grayWhite()
        tableView.backgroundView = bgView
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupTableViewCell
        
        if let group = fetchedResultsController?.object(at: indexPath) as? Group {
            var title: String?
            var date: NSDate?
            group.managedObjectContext?.performAndWait({
                title = group.title
                date = group.modifiedDate
            })
            cell.groupNameLabel.text = title
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let result = dateFormatter.string(from: date! as Date)
            cell.modifiedDateLabel.text = result
            
            // set up custom disclosure indicator
            let chevron = UIImage(named: "chevron_grey")?.withRenderingMode(.alwaysTemplate)
            cell.accessoryType = .disclosureIndicator
            cell.accessoryView = UIImageView(image: chevron!)
            cell.accessoryView?.tintColor = UIColor.warmOrange()
            
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
            if let context = managedObjectContext {
                context.perform({ 
                    if let groupToDelete = self.fetchedResultsController?.object(at: indexPath) as? Group {
                        context.delete(groupToDelete)
                        try? context.save()
                    }
                })
            }
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGroupDetail" {
            let groupDetailTVC = segue.destination as! GroupDetailTableViewController
            if let selectedCell = sender as? GroupTableViewCell {
                let selectedIndexPath = tableView.indexPath(for: selectedCell)
                groupDetailTVC.group = fetchedResultsController?.object(at: selectedIndexPath!) as? Group
            }
        }
    }
}
