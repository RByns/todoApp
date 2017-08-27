import UIKit
import CoreData

class AddNoteViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var tfNotition: ShakeTf!
    @IBOutlet weak var tapImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfNotition.delegate = self
        tapImage.isUserInteractionEnabled = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector(AddNoteViewController.addPulse))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func btnPressed(_ sender: Any) {
        if tfNotition?.text != "" && (tfNotition.text?.characters.count)! > 5 && (tfNotition.text?.characters.count)! < 42{
            saveItem(itemToSave: tfNotition.text!)
            navigationController!.popViewController(animated: true)
        }else{
            tfNotition.shake()
        }
    }
    
    func saveItem(itemToSave : String){
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "TodoList", in: context)
        let item = NSManagedObject(entity: entity!, insertInto: context)
        
        item.setValue(itemToSave, forKey: "item")
        
        do{
            try context.save()
        }catch{
            print("Saving failed")
        }
    }
    
    func addPulse(){
        let pulse = Pulse(numberOfPulses: 2, radius: 150, position: tapImage.center)
        pulse.animationDuration = 1
        pulse.backgroundColor = UIColor.red.cgColor
        self.view.layer.insertSublayer(pulse, below: tapImage.layer)
    }
    
}
