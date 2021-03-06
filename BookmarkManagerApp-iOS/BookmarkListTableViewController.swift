//
//  BookmarkListTableViewController.swift
//  BookmarkManagerApp-iOS
//
//  Created by Pavel Palancica on 6/6/22.
//

import UIKit
import CoreData

class BookmarkListTableViewController: UITableViewController {

    var managedObjectContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<BookmarkList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        populateBookmarkList()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultsController.sections else {
            return 0
        }
        return sections[section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookmarkListCell", for: indexPath)
        
        // Configure the cell...
        let bookmarkList = self.fetchedResultsController.object(at: indexPath)
        cell.textLabel?.text = bookmarkList.title

        return cell
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerViewFrame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44)
        let headerView = UIView(frame: headerViewFrame)
        headerView.backgroundColor = .lightText
        
        let textField = UITextField(frame: headerViewFrame)
        textField.delegate = self
        textField.placeholder = "Enter BookmarkList title"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.rightViewMode = .always
        headerView.addSubview(textField)
        
        return headerView
    }

}

extension BookmarkListTableViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any, at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == .insert {
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        } else if type == .delete {
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bookmarkList = self.fetchedResultsController.object(at: indexPath)
        
            self.managedObjectContext.delete(bookmarkList)
            try! self.managedObjectContext.save()
        }
        
        self.tableView.isEditing = false
    }
}

extension BookmarkListTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let bookmarkList = NSEntityDescription.insertNewObject(forEntityName: "BookmarkList", into: self.managedObjectContext) as! BookmarkList
        
        bookmarkList.title = textField.text
        try! self.managedObjectContext.save()
        
        return textField.resignFirstResponder()
    }
}

private extension BookmarkListTableViewController {
    func populateBookmarkList() {
        let fetchRequest = NSFetchRequest<BookmarkList>(entityName: "BookmarkList")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        self.fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: self.managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        self.fetchedResultsController.delegate = self
        
        try! self.fetchedResultsController.performFetch()
    }
}
