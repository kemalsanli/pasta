//
//  EditingController.swift
//  Pasta
//
//  Created by Kemal on 1.11.2021.
//

import UIKit

class EditingController: UIViewController {


    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var pastaTextView: UITextView!
    
    var selectedFav:Favorites?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFunc()
        subView.layer.cornerRadius = 15
        title = "Edit Pasta"
        
        self.hideKeyboardWhenTappedAround()
    }
    override func viewDidDisappear(_ animated: Bool) {
        print("Yep disappear")
        selectedFav?.pastaName = titleTextView.text
        selectedFav?.pasta = pastaTextView.text
        appDelegate.saveContext()
    }
    
    func setUpFunc(){
        guard let nonOptionalFav = selectedFav else { return }
        titleTextView.text = nonOptionalFav.pastaName
        pastaTextView.text = nonOptionalFav.pasta
    }
    

}
