//
//  ViewController.swift
//  Task1-CoreData
//
//  Created by coreylin on 3/15/16.
//  Copyright © 2016 coreylin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
  var memos = [NSManagedObject]()

  // MARK: - Life Cycle

  override func loadView() {
    super.loadView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.rightBarButtonItem =
      UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: Selector("addItem"))
    self.tableView.dataSource = self
    self.tableView.delegate = self
    self.loadSavedMemos()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - UITableViewDelegate

  override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    let deleteAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {
      _, indexPathForAction in
      let confirmBox = UIAlertController(title: "Delete this memo?",
                                       message: self.memos[indexPathForAction.row].valueForKey("title") as? String,
                                preferredStyle: .Alert)
      let confirmDelete = UIAlertAction(title: "Yes", style: .Default, handler: {
        _ in
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        managedContext.deleteObject(self.memos[indexPathForAction.row])
        do {
          try managedContext.save()
          self.memos.removeAtIndex(indexPathForAction.row)
          self.tableView.reloadData()
        } catch {
          print("Error: delete a memo")
        }
      })
      let cancelDelete = UIAlertAction(title: "No", style: .Default, handler: {
        _ in
        tableView.setEditing(false, animated: false)
      })
      confirmBox.addAction(confirmDelete)
      confirmBox.addAction(cancelDelete)
      self.presentViewController(confirmBox, animated: true, completion: nil)
    })

    let editAction = UITableViewRowAction(style: .Default, title: "Edit", handler: {
      _, indexPathForAction in
      let editBox = UIAlertController(title: "Edit this memo?",
                                    message: self.memos[indexPathForAction.row].valueForKey("title") as? String,
                             preferredStyle: .Alert)
      let confirmEdit = UIAlertAction(title: "Update", style: .Default, handler: {
        _ in
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        self.memos[indexPathForAction.row].setValue(editBox.textFields?[0].text, forKey: "title")
        do {
          try managedContext.save()
          self.tableView.reloadData()
        } catch {
          let updateError = error as NSError
          print(updateError)
        }
        tableView.setEditing(false, animated: false)
      })
      let cancelEdit = UIAlertAction(title: "Cancel", style: .Default, handler: {
        _ in
        tableView.setEditing(false, animated: false)
      })
      editBox.addAction(confirmEdit)
      editBox.addAction(cancelEdit)
      editBox.addTextFieldWithConfigurationHandler({
        textField in
        textField.text = self.memos[indexPathForAction.row].valueForKey("title") as? String
      })
      self.presentViewController(editBox, animated: true, completion: nil)
    })
    editAction.backgroundColor = UIColor.blueColor()
    return [deleteAction, editAction]
  }

  // MARK: - UITableViewDataSource

  override func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int {
    return memos.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("memoCell")! as UITableViewCell
    cell.textLabel?.text = self.memos[indexPath.row].valueForKey("title") as? String
    return cell
  }

  // MARK: -

  private func loadSavedMemos() {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    let fetchRequest = NSFetchRequest(entityName: "MemoEntity")
    do {
      let result = try managedContext.executeFetchRequest(fetchRequest)
      self.memos = result as! [NSManagedObject]
    } catch {
      print("Error: loadSavedMemos")
    }
  }

  @objc private func addItem() {
    let enterPanel = UIAlertController(title: "Memo", message: nil, preferredStyle: .Alert)
    let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: {
      (alertAction: UIAlertAction)
      in
      if let newMemo = enterPanel.textFields?[0].text {
        self.saveItem(newMemo)
        self.tableView.reloadData()
      }
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
    enterPanel.addAction(saveAction)
    enterPanel.addAction(cancelAction)
    enterPanel.addTextFieldWithConfigurationHandler({
      textField in
      textField.placeholder = "Type something"
    })
    self.presentViewController(enterPanel, animated: true, completion: nil)
  }

  private func saveItem(memo: String) {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedContext = appDelegate.managedObjectContext
    let memoEntity = NSEntityDescription.entityForName("MemoEntity", inManagedObjectContext: managedContext)
    let memoManagedObject = NSManagedObject(entity: memoEntity!, insertIntoManagedObjectContext: managedContext)

    memoManagedObject.setValue(memo, forKey: "title")
    do {
      try managedContext.save()
      self.memos.append(memoManagedObject)
    } catch {
      print("Error: unable to save a new memo")
    }
  }
}

