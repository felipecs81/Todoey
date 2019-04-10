//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Felipe on 4/4/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 80.0
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories added yet"
        
        if let color = categoryArray?[indexPath.row].color {
            
            guard let categoryColour = UIColor(hexString: color) else {fatalError()}
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
    
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true, completion: nil)
        
    }
    
    //MARK: - Datasource
    func loadCategories(){
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delegate
    
    //MARK: - Manipulation
    
    override func updateModel(at indexPath: IndexPath) {
        // handle action by updating model with deletion
        if let categoryForDeletion = self.categoryArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch{
                print("Error deleting category \(error)")
            }
        }
    }
    
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
}
