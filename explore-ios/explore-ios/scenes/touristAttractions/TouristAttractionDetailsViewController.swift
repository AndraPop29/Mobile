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
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var attractionImage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    var touristAttraction: TouristAttraction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        if let attraction = touristAttraction {
            nameTextField.text = touristAttraction?.name
            countryTextField.text = touristAttraction?.country
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
        guard let button = sender as? UIButton, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let attrName = nameTextField.text ?? ""
        let country = countryTextField.text ?? ""
        touristAttraction = TouristAttraction(name: attrName, country: country, imageName: (touristAttraction?.imageName)!)
    }

}
