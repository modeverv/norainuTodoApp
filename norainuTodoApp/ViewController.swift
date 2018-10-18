//
//  ViewController.swift
//  norainuTodoApp
//
//  Created by norainu on 2018/10/17.
//  Copyright © 2018 norainu. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

  var todoList = [MyTodo]()

  @IBOutlet weak var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    let userDefaults = UserDefaults.standard
    if let storedTodoList = userDefaults.data(forKey: "todoList") {
      do {
        if let unarchiveTodoList = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(storedTodoList) as? [MyTodo] {
          todoList.append(contentsOf: unarchiveTodoList)
        }
      }catch {
        // do nothing
      }
    }
  }

  @IBAction func tapAddButton(_ sender: Any) {
    let alertController = UIAlertController(title: "Todoの追加", message: "Todoを入力して", preferredStyle: UIAlertController.Style.alert)
    alertController.addTextField(configurationHandler: nil)
    // ok button
    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
      (action: UIAlertAction) in
      // tap ok
      if let textField = alertController.textFields?.first {
        let myTodo = MyTodo()
        myTodo.todoTitle = textField.text!
        self.todoList.insert(myTodo,at:0)
      }
      // notify to table
      self.tableView.insertRows(at: [IndexPath(row:0,section:0)], with: UITableView.RowAnimation.right)

      // save todoList
      self.saveTodoList()
    }
    alertController.addAction(okAction)

    // cancel button
    let cancelButton = UIAlertAction(title: "CANCEL",style: UIAlertAction.Style.cancel,handler: nil)
    alertController.addAction(cancelButton)

    present(alertController,animated: true,completion: nil)

  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
    let myTodo = todoList[indexPath.row]
    cell.textLabel?.text = myTodo.todoTitle
    // check mark
    if myTodo.todoDone {
      cell.accessoryType = UITableViewCell.AccessoryType.checkmark
    }else{
      cell.accessoryType = UITableViewCell.AccessoryType.none
    }
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let myTodo = todoList[indexPath.row]
    myTodo.todoDone = !myTodo.todoDone
    tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    saveTodoList()
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == UITableViewCell.EditingStyle.delete {
      todoList.remove(at: indexPath.row)
      // delete cell
      tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
      saveTodoList()
    }
  }

  func saveTodoList(){
    // save todoList
    let userDefaults = UserDefaults.standard
    let data = NSKeyedArchiver.archivedData(withRootObject: self.todoList)
    userDefaults.set(data,forKey:"todoList")
    userDefaults.synchronize()
  }
}

class MyTodo: NSObject,NSCoding {
  var todoTitle:String?
  var todoDone:Bool = false

  override init(){

  }

  required init?(coder aDecoder: NSCoder) {
    todoTitle = aDecoder.decodeObject(forKey: "todoTitle") as? String
    todoDone = aDecoder.decodeBool(forKey: "todoDone")
  }

  func encode(with aCoder: NSCoder) {
    aCoder.encode(todoTitle, forKey: "todoTitle")
    aCoder.encode(todoDone, forKey: "todoDone")
  }
}
