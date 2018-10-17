//
//  ViewController.swift
//  norainuTodoApp
//
//  Created by norainu on 2018/10/17.
//  Copyright © 2018 norainu. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

  var todoList = [String]()

  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  @IBAction func tapAddButton(_ sender: Any) {
    let alertController = UIAlertController(title: "Todoの追加", message: "Todoを入力して", preferredStyle: UIAlertController.Style.alert)
    alertController.addTextField(configurationHandler: nil)
    // ok button
    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
      (action: UIAlertAction) in
      // tap ok
      if let textField = alertController.textFields?.first {
        self.todoList.insert(textField.text!,at:0)
      }
      // notify to table
      self.tableView.insertRows(at: [IndexPath(row:0,section:0)], with: UITableView.RowAnimation.right)
    }
    alertController.addAction(okAction)

    // cancel button
    let cancelButton = UIAlertAction(title: "CANCEL",style: UIAlertAction.Style.cancel,handler: nil)
    alertController.addAction(cancelButton)

    present(alertController,animated: true,completion: nil)

  }



}

