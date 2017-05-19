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
    
    var toAddSolutions: [Solution]?
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath) as! GroupTableViewCell
            let indexPathForExistedGroup = IndexPath(row: indexPath.row - 1, section: indexPath.section)
            if let group = fetchedResultsController?.object(at: indexPathForExistedGroup) as? Group {
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
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let context = managedObjectContext {
            if indexPath.row == 0 {
                var inputTextField: UITextField?
                let groupNamePrompt = UIAlertController(title: "New Group", message: "Enter a name for this group", preferredStyle: .alert)
                groupNamePrompt.addTextField { (textField: UITextField) in
                    textField.placeholder = "Title"
                    inputTextField = textField
                }
                groupNamePrompt.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                groupNamePrompt.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action: UIAlertAction) in context.performAndWait({
                        let newGroup = NSEntityDescription.insertNewObject(forEntityName: "Group", into: context) as! Group
                        newGroup.title = inputTextField!.text
                        newGroup.modifiedDate = NSDate()
                        newGroup.addToIngredients(NSOrderedSet(array: self.toAddSolutions!))
                        try? context.save()
                    })
                    self.dismiss(animated: true, completion: nil)
                    
                }))
                present(groupNamePrompt, animated: true, completion: nil)
            } else {
                let indexPathForselectedGroup = IndexPath(row: indexPath.row - 1, section: indexPath.section)
                if let selectedGroup = fetchedResultsController?.object(at: indexPathForselectedGroup) as? Group {
                    context.performAndWait(
                        {let mutableIngredients = selectedGroup.ingredients!.mutableCopy() as! NSMutableOrderedSet
                            mutableIngredients.addObjects(from: self.toAddSolutions!)
                            selectedGroup.ingredients = mutableIngredients.copy() as? NSOrderedSet
                        try? context.save()
                        }
                    )
                }
                if presentingViewController is UITabBarController {
                    dismiss(animated: true, completion: nil)
                } else {
                    performSegue(withIdentifier: "unwindToGroupDetail", sender: self)
                }
            }
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
