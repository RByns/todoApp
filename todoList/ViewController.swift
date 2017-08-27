import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var listItems = [NSManagedObject]()
    var filteredItems = [NSManagedObject]()
    var delItems = [NSManagedObject]()
    
    let searchController = UISearchController(searchResultsController: nil)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        searchController.searchBar.barStyle = UIBarStyle.blackTranslucent
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func filterContentForSearchText(searchText: String){
        let context = getContext()
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TodoList")
        fetchRequest.predicate = NSPredicate(format: "item contains %@", searchText)
        
        do{
            let results = try context.fetch(fetchRequest)
            filteredItems = results as! [NSManagedObject]
        }catch{	
            print ("Error fetching data")
        }
        tableView.reloadData()
    }

    func saveItem(itemToSave : String){
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "DelList", in: context)
        let item = NSManagedObject(entity: entity!, insertInto: context)
        
        item.setValue(itemToSave, forKey: "item")
        
        do{
            try context.save()
            delItems.append(item)
        }catch{
            print("Saving failed")
        }
        
    }
    
    func getCoreData(){
        let context = getContext()
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "TodoList")
        
        do{
            let results = try context.fetch(fetchRequest)
            listItems = results as! [NSManagedObject]
        }catch{
            print ("Error fetching data")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getCoreData()
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = getContext()
        
        if editingStyle == .delete{
            let item = listItems[indexPath.row]
            let itemContent = item.value(forKey: "item") as? String

            saveItem(itemToSave: itemContent!)
            
            context.delete(item)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            getCoreData()
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredItems.count
        }
        return listItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
                
        if searchController.isActive && searchController.searchBar.text != "" {
            let item = filteredItems[indexPath.row]
            cell.textLabel?.text = item.value(forKey: "item") as? String
        }else {
            let item = listItems[indexPath.row]
            cell.textLabel?.text = item.value(forKey: "item") as? String
        }
        return cell
    }
}

extension TableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}

