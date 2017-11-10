//
//  TouristAttractionsViewController.swift
//  explore-ios
//
//  Created by Andra on 08/11/2017.
//  Copyright © 2017 andrapop. All rights reserved.
//

import UIKit

class TouristAttractionsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMockData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var attractionsList = [TouristAttraction]()
    
    func loadMockData() {
        attractionsList += [TouristAttraction(name: "Collosseum", country: "Italy", imageName: "the-colloseum-andrey-starostin"), TouristAttraction(name: "Eiffel Tower", country: "France", imageName: "eiffel")]
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attractionsList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TouristAttractionTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TouristAttractionTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        let attraction = attractionsList[indexPath.row]
        cell.nameLabel.text = attraction.name

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowDetail" {
            guard let attractionDetailViewController = segue.destination as? TouristAttractionDetailsViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }

            guard let selectedAttractionCell = sender as? TouristAttractionTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }

            guard let indexPath = tableView.indexPath(for: selectedAttractionCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            let selectedAttraction = attractionsList[indexPath.row]
            attractionDetailViewController.touristAttraction = selectedAttraction
        } else {
             fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }


    }

    @IBAction func unwindToAttractionList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? TouristAttractionDetailsViewController, let attraction = sourceViewController.touristAttraction {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                attractionsList[selectedIndexPath.row] = attraction
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
        }
    }

}
