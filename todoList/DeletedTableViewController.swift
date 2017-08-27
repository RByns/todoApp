import UIKit
import CoreData

class DeletedTableViewController: UITableViewController {
    
    var delItems = [NSManagedObject]()
    var filteredItems = [NSManagedObject]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = UITextAutocapitalizationType.none
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.barStyle = UIBarStyle.blackTranslucent
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
 
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func getCoreData(){
        let context = getContext()
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DelList")
        
        do{
            let results = try context.fetch(fetchRequest)
            delItems = results as! [NSManagedObject]
        }catch{
            print ("Error fetching data")
        }
    }
    
    func filterContentForSearchText(searchText: String, scope:String = "All"){
        let context = getContext()
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "DelList")
        fetchRequest.predicate = NSPredicate(format: "item contains %@", searchText)
        
        do{
            let results = try context.fetch(fetchRequest)
            filteredItems = results as! [NSManagedObject]
        }catch{
            print ("Error fetching data")
        }
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        getCoreData()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = getContext()
        
        if editingStyle == .delete{
            let item = delItems[indexPath.row]
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
        return delItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        
        if searchController.isActive && searchController.searchBar.text != "" {
            let item = filteredItems[indexPath.row]
            cell.textLabel?.text = item.value(forKey: "item") as? String
        }else {
            let item = delItems[indexPath.row]
            cell.textLabel?.text = item.value(forKey: "item") as? String
        }
        return cell
    }
}

extension DeletedTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
}
