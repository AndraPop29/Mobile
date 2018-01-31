//
//  EditViewController.swift
//  GameStoreApp
//
//  Created by Andra Pop on 2018-01-31.
//  Copyright © 2018 Andra. All rights reserved.
//

import UIKit

protocol EditViewControllerProtocol: AnyObject {
    //    func didEdit(item: Idea)
    func didAdd(item: (name: String, quantity: Int, type: String, status: String))
}

final class EditViewController: UIViewController {
    
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    
    var item: Game!
    
    weak var delegate: EditViewControllerProtocol?
    
    static func instantiate() -> EditViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(gesture)
        
        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let name = tf1.text ?? ""
        let quantity = Int(tf2.text!)!
        let type = tf3.text ?? ""
        let status = "available"
        
        self.delegate?.didAdd(item: (name, quantity, type, status))
    }
    
    
    @objc func hideKeyboard() {
        self.tf1.resignFirstResponder()
        self.tf2.resignFirstResponder()
        self.tf3.resignFirstResponder()
    }
}
