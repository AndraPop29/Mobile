//
//  TouristAttractionDetailsViewController.swift
//  explore-ios
//
//  Created by Andra on 08/11/2017.
//  Copyright © 2017 andrapop. All rights reserved.
//

import UIKit
import os.log

class TouristAttractionDetailsViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
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
        cityTextField.delegate = self
        let image = UIImage(named: "trash")?.withRenderingMode(.alwaysTemplate)
        deleteButton.setImage(image, for: .normal)
        deleteButton.tintColor = UIColor.black
        deleteButton.imageView?.tintColor = .black
        editButton.setTitle("SAVE", for: .normal)
        attractionImage.isUserInteractionEnabled = true
        if let attraction = touristAttraction {
            nameTextField.text = touristAttraction?.name
            countryTextField.text = touristAttraction?.country
            cityTextField.text = touristAttraction?.city
            attractionImage.image = attraction.image
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        attractionImage.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        print("sjdhaksjdhkhasjdh")
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        let attrName = nameTextField.text ?? ""
        let country = countryTextField.text ?? ""
        let city = cityTextField.text ?? ""
        if let index = attractionIndex {
            let attraction = TouristAttraction(name: attrName, country: country, city: city, image: attractionImage.image!)
            TouristAttractions.shared.attractionsList[index] = attraction
        } else {
            let attraction = TouristAttraction(name: attrName, country: country, city: city, image: attractionImage.image!)
            TouristAttractions.shared.attractionsList.append(attraction)
        }
        navigationController?.popViewController(animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}
