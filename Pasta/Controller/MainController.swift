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
    let context = appDelegate.persistentContainer.viewContext
    var fontNames = ["Prata-Regular","CraftyGirls-Regular"]
    @IBOutlet weak var PastaTableView: UITableView!
    var pastaBodies = [pastaBody]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setOptions()
        PastaTableView.delegate = self
        PastaTableView.dataSource = self
        addRefreshControl()
    }
    func addRefreshControl(){
        PastaTableView.refreshControl = UIRefreshControl()
        PastaTableView.refreshControl?.addTarget(self, action: #selector(pullToWipe), for: .valueChanged)
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
        let attributedTitle = NSAttributedString(string: "Pull To Clear", attributes: attributes)
        PastaTableView.refreshControl?.attributedTitle = attributedTitle
    }
    @objc func pullToWipe(){
        PastaTableView.refreshControl?.endRefreshing()
        for _ in 0..<pastaBodies.count{
                self.pastaBodies.remove(at: 0)
                self.PastaTableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        }
        
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
    
    @IBAction func historyButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "HistoryController") as? HistoryController {
        navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func favoritesButton(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "FavController") as? FavoritesController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    func newHistoryPasta(_ pastaM:String,_ date:Date){
        let history = History(context: context)
        history.pasta = pastaM
        history.date = date
        appDelegate.saveContext()
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
        PastaTableView.reloadRows(at: [indexPath], with: .fade)
    }
}

//first use options
extension MainController {
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
}
