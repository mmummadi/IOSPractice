//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var  itemArray = [Item]()
    
    var selectedCategory : Categ? {
        didSet {
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

   let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(dataFilePath)
         
    }
    
    //MARK: - TableView DataSource Methods

   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
       }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
       let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
       
       // Configure the cell’s contents.
        
        let item = itemArray[indexPath.row]
        cell.textLabel!.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
       
       return cell
    }
    //MARK: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        tableView.deselectRow(at: indexPath, animated: true)
        
       //update Core Cata
      //  itemArray[indexPath.row].setValue("Completed", forKey: "title")
       /*remove data
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)*/
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        saveItems()
       
    }
    

    @IBAction func barButtonSelected(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let newItem = textField.text{
                
                let newItems = Item(context : self.context)
                newItems.title = newItem
                newItems.done = false
                newItems.categoryItem = self.selectedCategory
                self.itemArray.append(newItems)
                self.saveItems()
                
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a New Todoey"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems(){
        
        do{
            try context.save()
        }catch {
            print(error)
        }
        self.tableView.reloadData()
        
    }
    
    
    //MARK: - loadItems()
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "categoryItem.name MATCHES %@", selectedCategory!.name!)
        if let newPredicate = predicate{
            let compountPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [newPredicate,categoryPredicate])
            request.predicate = compountPredicate
        }else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        }catch {
            print(error)
        }
            tableView.reloadData()
          }

}
//MARK: - UISearchBar Delegate
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        loadItems(with: request,predicate : predicate)
              
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

