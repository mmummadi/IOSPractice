//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Madhavi Mummadireddy on 5/17/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoryArray = [Categ]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        loadCategories()
    }
   
    
    //MARK: - DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
               
        return cell
    }
      
         
    //MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }
    //MARK: - Data Manipulation Methods
    func saveCategories() {
        do{
            try context.save()
        }catch {
            print("error saving categories\(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories(){
        let request : NSFetchRequest<Categ> = Categ.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    
    
    //MARK: - Add Categories
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let newCategory = textField.text {
                let newCateg = Categ(context : self.context)
                newCateg.name = newCategory
                self.categoryArray.append(newCateg)
                self.saveCategories()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
   

}
