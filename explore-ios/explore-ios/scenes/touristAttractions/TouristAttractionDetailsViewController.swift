//
//  TouristAttractionDetailsViewController.swift
//  explore-ios
//
//  Created by Andra on 08/11/2017.
//  Copyright © 2017 andrapop. All rights reserved.
//

import UIKit
import os.log

class TouristAttractionDetailsViewController: UIViewController, UITextFieldDelegate{
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var attractionImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    var touristAttraction: TouristAttraction?
    var attractionIndex: Int?
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        TouristAttractions.shared.attractionsList.remove(at: attractionIndex!)
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        countryTextField.delegate = self
        let image = UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate)
        deleteButton.setImage(image, for: .normal)
        deleteButton.tintColor = UIColor.black
        deleteButton.imageView?.tintColor = .black
        editButton.setTitle("SAVE", for: .normal)
        if let attraction = touristAttraction {
            nameTextField.text = touristAttraction?.name
            countryTextField.text = touristAttraction?.country
            cityTextField.text = touristAttraction?.city
            attractionImage.image = UIImage(named: attraction.imageName)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIButton, button === editButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let attrName = nameTextField.text ?? ""
        let country = countryTextField.text ?? ""
        let city = cityTextField.text ?? ""
        touristAttraction = TouristAttraction(name: attrName, country: country, city: city, imageName: (touristAttraction?.imageName)!)
    }

}
