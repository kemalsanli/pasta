//
//  HistoryController.swift
//  Pasta
//
//  Created by Kemal on 20.10.2021.
//

import UIKit
import CoreData

class HistoryController: UITableViewController {

    
    
    var pastaHistory = [pastaBody]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setOptions()
        readDb()
        print("selamma")
    }
    func setOptions(){
        self.navigationItem.title = "History"
        let navBar = UINavigationBarAppearance()
        navBar.backgroundColor = UIColor(named: "NavBarColors")
        navBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont(name: "Prata-Regular", size: 30)!]
        
        
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.standardAppearance = navBar
        navigationController?.navigationBar.compactAppearance = navBar
        navigationController?.navigationBar.scrollEdgeAppearance = navBar
    }
    func readDb() {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

            let db = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")

            do {
                let result = try db.fetch(fetchRequest)
                pastaHistory.removeAll()
                for data in result as! [NSManagedObject] {
                    
                   pastaHistory.insert(pastaBody.init(date: data.value(forKey: "date") as! Date, pasta: data.value(forKey: "pasta") as! String), at: 0)
                }
                tableView.reloadData()
                
            } catch {
                
                print("Failed")
            }
        }

    @IBAction func wipeButton(_ sender: Any) {
        alertControllerFunc("Are you sure ?", "This operation will wipe your history", "Cancel","Wipe", entityWiper(_:))
    }
    
    func deleteEntry(_ date:Date){
        //As we know that container is set up in the AppDelegates so we need to refer that container.
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                
                //We need to create a context from this container
                let managedContext = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
        fetchRequest.predicate = NSPredicate(format: "date = %@", date as CVarArg)
               
                do
                {
                    let test = try managedContext.fetch(fetchRequest)
                    
                    let objectToDelete = test[0] as! NSManagedObject
                    managedContext.delete(objectToDelete)
                    
                    do{
                        try managedContext.save()
                        readDb()
                    }
                    catch
                    {
                        print(error)
                    }
                    
                }
                catch
                {
                    print(error)
                }
    }
    
    func entityWiper( _ action:UIAlertAction! = nil){
        //Actually swift forces me to write "History" manually because of the idiotic uialertaction requirement....
        let appDel:AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
            let context:NSManagedObjectContext = appDel.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "History")
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try context.fetch(fetchRequest)
                for managedObject in results {
                    if let managedObjectData: NSManagedObject = managedObject as? NSManagedObject {
                        context.delete(managedObjectData)
                        if let _ = try? context.save(){
                            readDb()
                            }
                    }
                }
            } catch let error as NSError {
                print("Deleted all my data in history error : \(error) \(error.userInfo)")
            }
    }
    func alertControllerFunc( _ title:String, _ message:String, _ buttonLabel: String,_ cancelButton:String? = nil, _ action: ((UIAlertAction) -> Void)? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let cancelTitle = cancelButton{
            ac.addAction(UIAlertAction(title: cancelTitle, style: .destructive, handler: action))
        }
        ac.addAction(UIAlertAction(title: buttonLabel, style: .default, handler: nil))
        
        present(ac, animated: true)
    }
    // MARK: - Table view data source

}

extension HistoryController: HistoryCellProtocol {
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let silAction = UIContextualAction(style: .destructive, title: "Sil"){ [weak self] (UIContextualAction, view, boolValue) in
            self?.pastaHistory.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return UISwipeActionsConfiguration(actions: [silAction])
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return pastaHistory.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.pastaLabel.text = pastaHistory[indexPath.row].pasta
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        cell.hourLabel.text = dateFormatter.string(from: pastaHistory[indexPath.row].date)
        dateFormatter.dateFormat = "MMM d, yyyy"
        cell.dateLabel.text = dateFormatter.string(from: pastaHistory[indexPath.row].date)
        
        cell.HistoryCellProtocol = self
        cell.indexPath = indexPath


        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIPasteboard.general.string = pastaHistory[indexPath.row].pasta
        tableView.reloadData()
    }
    
    func buttonClicked(indexPath: IndexPath) {
        let ac = UIAlertController(title: "Add To Favorites", message: "This action will add this pasta to your favourites", preferredStyle: .alert)
        ac.addTextField{ textField in textField.placeholder = "Add a title for your favourite"}
        
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            if let textField = ac.textFields![0].text{
                if textField != ""{
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

                    let db = appDelegate.persistentContainer.viewContext

                    let newPasta = NSEntityDescription.entity(forEntityName: "Favorites", in: db)!

                        let pasta = NSManagedObject(entity: newPasta, insertInto: db)
                    pasta.setValue(self?.pastaHistory[indexPath.row].pasta, forKey: "pasta")
                    pasta.setValue(self?.pastaHistory[indexPath.row].date, forKey: "date")
                    pasta.setValue(textField, forKey: "pastaName")

                    
                    do {
                        try db.save()
                       
                    } catch let error as NSError {
                        print("havin some issues \(error), \(error.userInfo)")
                    }
                }
            }
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        
        
        present(ac, animated: true)
    }
}
