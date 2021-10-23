//
//  ViewController.swift
//  Pasta
//
//  Created by Kemal on 19.10.2021.
//

import UIKit
import CoreData

struct pastaBody {
    var date:Date
    var pasta:String
}

class MainController: UIViewController{
    var fontNames = ["Prata-Regular","CraftyGirls-Regular"]
    @IBOutlet weak var PastaTableView: UITableView!
    var pastaBodies = [pastaBody]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setOptions()
        PastaTableView.delegate = self
        PastaTableView.dataSource = self
    }

    @IBAction func copyClipboardButton(_ sender: Any) {
        if let freshPasta = UIPasteboard.general.string {
            if freshPasta != " " && freshPasta != ""{
                pastaBodies.insert(pastaBody.init(date: Date(), pasta: "\(freshPasta)"), at: 0)
                PastaTableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .left)
                newHistoryPasta(freshPasta, Date())
            }
        }
    }
    func setOptions(){
        self.navigationItem.title = "Pasta"
        let navBar = UINavigationBarAppearance()
        navBar.backgroundColor = UIColor(named: "NavBarColors")
        
        navBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont(name: fontNames.randomElement()!, size: 30)!]
        //Şeffaflık kapat // rgb doğru kullan
        navigationController?.navigationBar.isTranslucent = false
        
        navigationController?.navigationBar.standardAppearance = navBar
        navigationController?.navigationBar.compactAppearance = navBar
        navigationController?.navigationBar.scrollEdgeAppearance = navBar
    }
    
    @IBAction func historyButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "HistoryController") as? HistoryController {
        navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    func newHistoryPasta(_ pastaM:String,_ date:Date){

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        let db = appDelegate.persistentContainer.viewContext

        let newPasta = NSEntityDescription.entity(forEntityName: "History", in: db)!

            let pasta = NSManagedObject(entity: newPasta, insertInto: db)
            pasta.setValue("\(pastaM)", forKey: "pasta")
            pasta.setValue(date, forKey: "date")

        
        do {
            try db.save()
           
        } catch let error as NSError {
            print("havin some issues \(error), \(error.userInfo)")
        }
    }



}

//Tableview
extension MainController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastaBodies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PastaTableView.dequeueReusableCell(withIdentifier: "PastaCell", for: indexPath) as! PastaCell
        cell.selectionStyle = .none
        cell.pastaLabel.text = pastaBodies[indexPath.row].pasta
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        cell.hourLabel.text = dateFormatter.string(from: pastaBodies[indexPath.row].date)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIPasteboard.general.string = pastaBodies[indexPath.row].pasta
    }
}
