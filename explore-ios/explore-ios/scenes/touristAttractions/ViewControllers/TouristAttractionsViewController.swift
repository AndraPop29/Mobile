//
//  TouristAttractionsViewController.swift
//  explore-ios
//
//  Created by Andra on 08/11/2017.
//  Copyright © 2017 andrapop. All rights reserved.
//

import UIKit

class TouristAttractionsViewController: UITableViewController {
    
    @IBOutlet weak var addButton: UIButton!
    @IBAction func addButtonAction(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = mainStoryboard.instantiateViewController(withIdentifier: "attractionDetailsViewController") as? TouristAttractionDetailsViewController {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    @IBOutlet weak var headerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let nibName = UINib(nibName: "TouristAttractionCell", bundle:nil)
        tableView.register(nibName, forCellReuseIdentifier: "touristAttractionCell")
        tableView.separatorStyle = .none
        headerView.backgroundColor = .white
        let image = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(image, for: .normal)
        addButton.tintColor = UIColor.black
        addButton.imageView?.tintColor = .black
        loadMockData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadMockData() {
        TouristAttractions.shared.attractionsList += [TouristAttraction(name: "Collosseum", country: "Italy", city: "Rome" ,imageName: "the-colloseum-andrey-starostin"), TouristAttraction(name: "Eiffel Tower", country: "France", city: "Paris", imageName: "eiffel")]
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
            return TouristAttractions.shared.attractionsList.count
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
        let attraction =  TouristAttractions.shared.attractionsList[indexPath.section]
        cell.nameLabel.text = attraction.name
        cell.attractionImageView.image = UIImage(named: attraction.imageName)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = mainStoryboard.instantiateViewController(withIdentifier: "attractionDetailsViewController") as? TouristAttractionDetailsViewController {
            controller.touristAttraction = TouristAttractions.shared.attractionsList[indexPath.section]
            controller.attractionIndex = indexPath.section
            navigationController?.pushViewController(controller, animated: true)
        }
    }

}
