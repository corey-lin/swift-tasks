//
//  ViewController.swift
//  Task1-CoreData
//
//  Created by coreylin on 3/15/16.
//  Copyright © 2016 coreylin. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  var memos = [String]()

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
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  // MARK: - UITableViewDataSource
  override func tableView(tableView: UITableView, numberOfRowsInSection: Int) -> Int {
    return memos.count
  }
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("memoCell")! as UITableViewCell
    cell.textLabel?.text = self.memos[indexPath.row]
    return cell
  }

  // MARK: -
  @objc private func addItem() {
    let enterPanel = UIAlertController(title: "Memo", message: nil, preferredStyle: .Alert)
    let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: {
      (alertAction: UIAlertAction)
      in
      if let newMemo = enterPanel.textFields?[0].text {
        self.memos.append(newMemo)
        self.tableView.reloadData()
      }
    })
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { _ in
      self.dismissViewControllerAnimated(true, completion: nil)
    })
    enterPanel.addAction(saveAction)
    enterPanel.addAction(cancelAction)
    enterPanel.addTextFieldWithConfigurationHandler({
      textField in
      textField.placeholder = "Type something"
    })
    self.presentViewController(enterPanel, animated: true, completion:nil)
  }
}

