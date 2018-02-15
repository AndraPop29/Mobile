//
//  MainViewController.swift
//  ExamenMobile
//
//  Created by Andra Pop on 2018-02-02.
//  Copyright © 2018 Andra. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Starscream
import SwiftyJSON

class Tab1ViewController: UITableViewController {
    
    var dataSource : [Car] = []
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

            
            self.fetchData()
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cellId")
        
         let leftBtn = UIBarButtonItem(title: "add", style: .plain, target: self, action: #selector(adddBtn))
        self.navigationItem.leftBarButtonItem = leftBtn
  

        }
 
    
    @objc func adddBtn() {
        let editVC = EditViewController.instantiate()
        
        editVC.delegate = self
        
        self.navigationController?.pushViewController(editVC, animated: true)

    }
    

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.dataSource.count
        

        return rows
    }


private func delete(car id: Int, rowIndex: IndexPath) {
    
    let endpoint = Endpoint.deleteCar(id: id)
    MBProgressHUD.showAdded(to: self.view, animated: true)

    APIClient.requestData(endpoint: endpoint) { (result: Result<String>) -> Void in
        
        switch result {
        case .success(_):
            self.dataSource.remove(at: rowIndex.row)
            self.tableView.reloadData()
            
        case .failure(let error):
            UIAlertController.show(message: error.localizedDescription, on: self)
        }
        MBProgressHUD.hide(for: self.view, animated: true)

    }
}
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TableViewCell
        
        let car = self.dataSource[indexPath.row]
        
        
            cell.lbl1.text = car.name
            cell.lbl2.text = "\(car.km)"
            
        
        
        return cell
    }


    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let car = self.dataSource[indexPath.row]
        
        self.delete(car: car.id, rowIndex: indexPath)
    }

    func fetchData() {
        let endpoint = Endpoint.cars
        MBProgressHUD.showAdded(to: self.view, animated: true)

        APIClient.request(endpoint: endpoint) { (result: Result<[Car]>) -> Void in
            
            switch result {
            case .success(let cars):
                self.dataSource = cars
                self.dataSource = self.dataSource.sorted(by: {lhs, rhs in
                    return lhs.km < rhs.km
                })
                self.tableView.reloadData()
                
            case .failure(let error):
                UIAlertController.show(message: error.localizedDescription, on: self)
                
                self.tableView.reloadData()
            }
            
        }
        MBProgressHUD.hide(for: self.view, animated: true)

    }


}

extension Tab1ViewController: EditViewControllerProtocol {
    func didUpdate(item: (id: Int, name: String, status: String, year: Int), index: Int) {
        
    }
    
    func didAdd(item: (name: String, model: String, year: Int)) {
        let endpoint = Endpoint.add(name: item.name, model: item.model, year: item.year)
        MBProgressHUD.showAdded(to: self.view, animated: true)

        
        APIClient.requestData(endpoint: endpoint) { (result: Result<String>) -> Void in
            switch result {
                
            case .success(_):
                self.fetchData()
                self.tableView.reloadData()
                print("successfully added car")
                
            case .failure(let error):
                UIAlertController.show(message: error.localizedDescription, on: self)
            }
            MBProgressHUD.hide(for: self.view, animated: true)

            
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    

    
    func didUpdate(item: (id: Int, name: String, status: String, year: Int)) {
        
    }
    
    func addMiles(id: Int, km: Int) {
        
    }
    
    
    

}


