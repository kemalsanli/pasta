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
        alertControllerFunc("Are you sure ?", "This operation will", "Cancel","Wipe", entityWiper(_:))
    }
    func entityWiper( _ action:UIAlertAction! = nil){
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
        ac.addAction(UIAlertAction(title: buttonLabel, style: .default, handler: nil))
        if let cancelTitle = cancelButton{
            ac.addAction(UIAlertAction(title: cancelTitle, style: .destructive, handler: action))
        }
        present(ac, animated: true)
    }
    // MARK: - Table view data source

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
        dateFormatter.dateFormat = "hh:mm"
        cell.hourLabel.text = dateFormatter.string(from: pastaHistory[indexPath.row].date)
        dateFormatter.dateFormat = "MMM d, yyyy"
        cell.dateLabel.text = dateFormatter.string(from: pastaHistory[indexPath.row].date)


        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIPasteboard.general.string = pastaHistory[indexPath.row].pasta
        tableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
