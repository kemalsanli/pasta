//
//  HistoryController.swift
//  Pasta
//
//  Created by Kemal on 20.10.2021.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class HistoryController: UITableViewController {
    let context = appDelegate.persistentContainer.viewContext
    var pastaHistory = [History]()
    override func viewDidLoad() {
        super.viewDidLoad()
        readDb()
    }

    func readDb() {
        do{
            pastaHistory = try context.fetch(History.fetchRequest())
            pastaHistory.reverse()
            
            
        }catch{
            print("Havin some issues")
            }
            
        tableView.reloadData()
        }

    @IBAction func wipeButton(_ sender: Any) {
        alertControllerFunc("Are you sure ?", "This operation will wipe your history", "Cancel","Wipe", entityWiper(_:))
    }
    
    
    
    func entityWiper( _ action:UIAlertAction! = nil){
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
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 10, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.30){
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let silAction = UIContextualAction(style: .destructive, title: "Sil"){ [weak self] (UIContextualAction, view, boolValue) in
            
            if let pasta = self?.pastaHistory[indexPath.row]{
                self?.context.delete(pasta)
                appDelegate.saveContext()
                self?.pastaHistory.remove(at: indexPath.row)
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
        return UISwipeActionsConfiguration(actions: [silAction])
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastaHistory.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.pastaLabel.text = pastaHistory[indexPath.row].pasta
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        cell.hourLabel.text = dateFormatter.string(from: pastaHistory[indexPath.row].date ?? Date())
        dateFormatter.dateFormat = "dd.MM.YYYY"
        cell.dateLabel.text = dateFormatter.string(from: pastaHistory[indexPath.row].date ?? Date())
        
        cell.HistoryCellProtocol = self
        cell.indexPath = indexPath


        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIPasteboard.general.string = pastaHistory[indexPath.row].pasta
    }
    
    func buttonClicked(indexPath: IndexPath) {
        let ac = UIAlertController(title: "Add To Favorites", message: "This action will add this pasta to your favourites", preferredStyle: .alert)
        ac.addTextField{ textField in textField.placeholder = "Add a title for your favourite"}
        
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            if let textField = ac.textFields![0].text{
                if textField != "" {
                    self?.addToFavorites(self?.pastaHistory[indexPath.row].pasta, self?.pastaHistory[indexPath.row].date, textField)
                        
                    }
                }
            }
        ))
        ac.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        
        
        present(ac, animated: true)
    }
    func addToFavorites(_ pastaO:String?,_ dateO:Date?,_ pastaNameO:String?){
        guard let pastaName = pastaNameO else {return}
        guard let pasta = pastaO else {return}
        guard let date = dateO else {return}
        
        let fav = Favorites(context: context)
        fav.pastaName = pastaName
        fav.pasta = pasta
        fav.date = date
        appDelegate.saveContext()
    }
}

