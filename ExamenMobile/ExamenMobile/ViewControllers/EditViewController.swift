//
//  EditViewController.swift
//  ExamenMobile
//
//  Created by Andra Pop on 2018-02-02.
//  Copyright © 2018 Andra. All rights reserved.
//

import UIKit

protocol EditViewControllerProtocol: AnyObject {
    
    func didAdd(item: (name: String, model: String, year: Int))
    
    func didUpdate(item: (id: Int, name: String, status: String, year: Int), index: Int)
    
    func addMiles(id: Int, km: Int)
}

class EditViewController: UIViewController {
    
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var button: UIButton!

    @IBOutlet weak var label: UILabel!
    var item: Car?
    var indexOfCar: Int?
    
    


    weak var delegate: EditViewControllerProtocol?
    
    static func instantiate() -> EditViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(gesture)
        setupTextFields()


    }
    @IBOutlet weak var labelMiles: UILabel!
    
    @IBOutlet weak var addmiles: UIButton!
    
    @IBAction func addMiles(_ sender: Any) {
        self.delegate?.addMiles(id: item!.id, km: Int(tf4.text!)!)
    }
    func setupTextFields() {
        if let entity = item {
            tf1.text = item?.name
            tf2.text = ""
            tf3.text = "\((item?.year)!)"
        } else {
            label.text = "Model"
            labelMiles.isHidden = true
            tf4.isHidden = true
            addmiles.isHidden = true
        }
    }

    @objc func hideKeyboard() {
        self.tf1.resignFirstResponder()
        self.tf2.resignFirstResponder()
        self.tf3.resignFirstResponder()
        self.tf4.resignFirstResponder()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let name = tf1.text ?? ""
        let year = Int(tf3.text!)!
        let status = tf2.text ?? ""
        if let item = item {

            self.delegate?.didUpdate(item: (id: item.id, name: name, status: status, year: year ), index: indexOfCar!)
            
        } else {
          //  let status = "available"
            self.delegate?.didAdd(item: (name: name, model: status, year: year ))
        }
        
    }

}
