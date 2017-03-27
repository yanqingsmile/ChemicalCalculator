//
//  AddToTemporaryTableViewController.swift
//  ChemicalCalculator
//
//  Created by Vivian Liu on 3/26/17.
//  Copyright © 2017 Vivian Liu. All rights reserved.
//

import UIKit
import CoreData

class AddToTemporaryTableViewController: CoreDataTableViewController {
    
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch data from database
        if let context = managedObjectContext {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Group")
            request.sortDescriptors = [NSSortDescriptor(key: "modifiedDate", ascending: false, selector: nil),NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))]
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        } else {
            fetchedResultsController = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.tableView(tableView, numberOfRowsInSection: section) + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewGroupCell", for: indexPath) as! NewGroupTableViewCell
            cell.newGroupLabel.text = "New Group"
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as!GroupTableViewCell
            let indexPathForExistedGroup = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if let group = fetchedResultsController?.object(at: indexPathForExistedGroup) as? Group {
                var title: String?
                var date: NSDate?
                group.managedObjectContext?.performAndWait({
                    title = group.title
                    date = group.modifiedDate
                })
                cell.groupNameLabel.text = title
                cell.modifiedDateLabel.text = String(describing: date)
            }
            return cell
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
