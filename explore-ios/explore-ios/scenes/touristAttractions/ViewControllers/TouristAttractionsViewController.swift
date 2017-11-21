//
//  TouristAttractionsViewController.swift
//  explore-ios
//
//  Created by Andra on 08/11/2017.
//  Copyright © 2017 andrapop. All rights reserved.
//

import UIKit
import os.log

class TouristAttractionsViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    var pickerView: UIPickerView?
    @IBAction func addButtonAction(_ sender: Any) {
       
    }
    @IBOutlet weak var headerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil
        let nibName = UINib(nibName: "TouristAttractionCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "touristAttractionCell")
        tableView.separatorStyle = .none
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        headerView.backgroundColor = .white
        let addBtn = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(addTouristAttraction))
        self.navigationItem.rightBarButtonItem  = addBtn
        let button = UIButton(type: .system)
        button.setTitle("Statistics", for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(self.seeStatistics), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        self.title = "Tourist Attractions"
        if let savedAttractions = TouristAttractions.shared.loadAttractions() {
            TouristAttractions.shared.attractionsList += savedAttractions
        }
        else {
            loadMockData()
        }
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
    @objc func seeStatistics() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = mainStoryboard.instantiateViewController(withIdentifier: "touristAttractionStatisticsViewController") as? TouristAttractionStatisticsViewController {
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
        TouristAttractions.shared.addAttraction(attraction: TouristAttraction(name: "Venice Canals", country: "Italy", city: "Venice", image: UIImage(named: "venice")!))
         TouristAttractions.shared.addAttraction(attraction: TouristAttraction(name: "Pompeii", country: "Italy", city: "Pompei", image: UIImage(named: "pompeii")!))
         TouristAttractions.shared.addAttraction(attraction: TouristAttraction(name: "Leaning Tower of Pisa", country: "Italy", city: "Pisa", image: UIImage(named: "towerPisa")!))
         TouristAttractions.shared.addAttraction(attraction: TouristAttraction(name: "Amalfi Coast", country: "Italy", city: "Campania", image: UIImage(named: "amalfi")!))
         TouristAttractions.shared.addAttraction(attraction: TouristAttraction(name: "Vatican City", country: "Italy", city: "Vatican", image: UIImage(named: "vatican")!))
        TouristAttractions.shared.addAttraction(attraction: TouristAttraction(name: "Palace of Versailles", country: "France", city: "Versailles", image: UIImage(named: "versailles")!))
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
        cell.touristAttraction = attraction
        cell.nameLabel.text = attraction.name
        cell.attractionImageView.image = attraction.image
        cell.ratingControl.rating = Int(attraction.ratingAverage)
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


