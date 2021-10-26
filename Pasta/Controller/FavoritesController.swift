//
//  FavoritesController.swift
//  Pasta
//
//  Created by Kemal on 23.10.2021.
//

import UIKit
import CoreData

class FavoritesController: UITableViewController {
    
    let context = appDelegate.persistentContainer.viewContext
    var favList = [Favorites]()
    override func viewDidLoad() {
        super.viewDidLoad()
        readDb()

    }
    override func viewDidAppear(_ animated: Bool) {
        print("Read DB")
    }

    func readDb(){
        do{
            favList = try context.fetch(Favorites.fetchRequest())
            favList.reverse()
        }catch{
            print("Havin some issues")
            }
            
        tableView.reloadData()
    }
}


extension FavoritesController {
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 5, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.20){
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favList.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIPasteboard.general.string = favList[indexPath.row].pasta
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell", for: indexPath) as! FavCell
        cell.titleLabel.text = favList[indexPath.row].pastaName
        cell.informationLabel.text = favList[indexPath.row].pasta
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        cell.hourLabel.text = dateFormatter.string(from: favList[indexPath.row].date ?? Date())
        dateFormatter.dateFormat = "dd.MM.YYYY"
        cell.dateLabel.text = dateFormatter.string(from: favList[indexPath.row].date ?? Date())
        cell.selectionStyle = .none
        return cell
    }
}
