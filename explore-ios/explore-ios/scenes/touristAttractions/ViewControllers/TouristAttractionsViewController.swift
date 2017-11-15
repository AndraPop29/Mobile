//
//  TouristAttractionsViewController.swift
//  explore-ios
//
//  Created by Andra on 08/11/2017.
//  Copyright © 2017 andrapop. All rights reserved.
//

import UIKit

class TouristAttractionsViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    var pickerView: UIPickerView?
    @IBAction func addButtonAction(_ sender: Any) {
       
    }
    @IBOutlet weak var headerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "TouristAttractionCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "touristAttractionCell")
        tableView.separatorStyle = .none
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        headerView.backgroundColor = .white
        let addBtn = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(addTouristAttraction)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.rightBarButtonItem  = addBtn
        self.title = "Tourist Attractions"
        loadMockData()
        pickerView = UIPickerView()
        countryTextField.inputView = pickerView
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
    }
    @objc func addTouristAttraction() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = mainStoryboard.instantiateViewController(withIdentifier: "attractionDetailsViewController") as? TouristAttractionDetailsViewController {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        countryTextField.text = TouristAttractions.shared.getCountries()[0]
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadMockData() {
        TouristAttractions.shared.addAttraction(attraction: TouristAttraction(name: "Collosseum", country: "Italy", city: "Rome" ,image: UIImage(named: "the-colloseum-andrey-starostin")!))
        TouristAttractions.shared.addAttraction(attraction: TouristAttraction(name: "Eiffel Tower", country: "France", city: "Paris", image: UIImage(named: "eiffel")!))
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return  TouristAttractions.shared.getAttractions(fromCountry: countryTextField.text!).count
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeader = UIView()
        sectionHeader.backgroundColor = .clear
        return sectionHeader
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "touristAttractionCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TouristAttractionCell  else {
            fatalError("The dequeued cell is not an instance of TouristAttractionCell.")
        }
        cell.selectionStyle = .none
        let attraction = TouristAttractions.shared.getAttractions(fromCountry: countryTextField.text!)[indexPath.section]
        cell.nameLabel.text = attraction.name
        cell.attractionImageView.image = attraction.image
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = mainStoryboard.instantiateViewController(withIdentifier: "attractionDetailsViewController") as? TouristAttractionDetailsViewController {
            controller.touristAttraction = TouristAttractions.shared.getAttractions(fromCountry: countryTextField.text!)[indexPath.section]
            controller.attractionIndex = indexPath.section
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension TouristAttractionsViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TouristAttractions.shared.getCountries().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TouristAttractions.shared.getCountries()[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryTextField.text = TouristAttractions.shared.getCountries()[row]
        countryTextField.resignFirstResponder()
        tableView.reloadData()
    }
}
