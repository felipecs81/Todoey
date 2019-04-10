//
//  ViewController.swift
//  Todoey
//
//  Created by Felipe on 19/3/19.
//  Copyright © 2019 Felipe. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        title = selectedCategory?.name
        updateNavBar(withHexCode: selectedCategory?.color)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "1D9BF6")
    }
    
    //MARK: - Nav Bar Setup Methods
    
    func updateNavBar(withHexCode colourHexCode : String?){
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColour = UIColor(hexString: colourHexCode ?? "1D9BF6") else {fatalError()}
        
        searchBar.barTintColor = navBarColour
        navBar.barTintColor = navBarColour
        navBar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = itemArray?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(itemArray!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
            
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
            cell.textLabel?.text = "No Items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status\(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("Error saving items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert,animated: true, completion: nil)
        
    }
    
    override func updateModel(at indexPath: IndexPath) {
        // handle action by updating model with deletion
        if let itemForDeletion = self.itemArray?[indexPath.row]{
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }catch{
                print("Error deleting category \(error)")
            }
        }
    }
    
    func loadItems(){
        
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //itemArray = itemArray!.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}

