import UIKit
import CoreData

class SettingsViewController: UIViewController {
       
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func deletePressed(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete everything", message: "This action cannot be reversed", preferredStyle: UIAlertControllerStyle.alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: {action in self.pressedAll()})
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)

    }
    
    @IBAction func deleteNotes(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete notes", message: "This action cannot be reversed", preferredStyle: UIAlertControllerStyle.alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: {action in self.pressedNotes()})
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func emptyTrash(_ sender: Any) {
        let alertController = UIAlertController(title: "Empty trash", message: "This action cannot be reversed", preferredStyle: UIAlertControllerStyle.alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: {action in self.pressedTrash()})
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func pressedAll(){
        resetAll()
    }
    
    func pressedNotes(){
        resetNotes()
    }
    
    func pressedTrash(){
        resetTrash()
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func resetAll(){
        let context = getContext()
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
        let deleteDelFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "DelList")

        let deleteDelRequest = NSBatchDeleteRequest(fetchRequest: deleteDelFetch)
        let deleteNotesRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do{
            try context.execute(deleteNotesRequest)
            try context.execute(deleteDelRequest)
            try context.save()
        }
        catch{
            print ("Couldn't delete everything")
        }
    }
    
    func resetNotes(){
        let context = getContext()
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoList")
        
        let deleteNotesRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do{
            try context.execute(deleteNotesRequest)
            try context.save()
        }
        catch{
            print ("Couldn't delete all notes")
        }
    }
    
    func resetTrash(){
        let context = getContext()
        let deleteDelFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "DelList")
        
        let deleteDelRequest = NSBatchDeleteRequest(fetchRequest: deleteDelFetch)
        do{
            try context.execute(deleteDelRequest)
            try context.save()
        }
        catch{
            print ("Couldn't delete the trash")
        }
    }

}
