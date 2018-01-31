//
//  ViewController.swift
//  GameStoreApp
//
//  Created by Andra Pop on 2018-01-31.
//  Copyright © 2018 Andra. All rights reserved.
//

import UIKit
import Alamofire

class MainViewController: UIViewController {
    
    private var dataSource: [Game] = []
    var emptyView: EmptyDataSourceView?


    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addButton(_ sender: Any) {
        let editVC = EditViewController.instantiate()
        editVC.delegate = self
        
        self.navigationController?.pushViewController(editVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getItems()
    }

    private func getItems() {
        let endpoint = Endpoint.getAllItems
        
        RestApiManager.request(endpoint: endpoint) { (result: Result<[Game]>)  -> Void in
            switch result {
                
            case .success(let games):
                self.dataSource = games
                self.tableView.reloadData()
                
            case .failure(let error):
                UIAlertController.show(message: error.localizedDescription, on: self)
            }
        }
        
    }
    
    private func delete(item id: Int, rowIndex: IndexPath) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        let endpoint = Endpoint.deleteItem(id: id)
        RestApiManager.request(endpoint: endpoint) { (result: Result<Game>) -> Void in
            switch result {
            case .success(_):
                self.dataSource.remove(at: rowIndex.row)
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error.localizedDescription)
                UIAlertController.show(message: error.localizedDescription, on: self)
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

}

extension MainViewController: EditViewControllerProtocol {
    
    func didAdd(item: (name: String, quantity: Int, type: String, status: String)) {
        let endpoint = Endpoint.addItem(name: item.name, quantity: item.quantity, type: item.type, status: item.status)
        
        RestApiManager.request(endpoint: endpoint) { (result: Result<Game>)  -> Void in
            switch result {
                
            case .success(let idea):
                self.dataSource.append(idea)
                self.tableView.reloadData()
                
            case .failure(let error):
                UIAlertController.show(message: error.localizedDescription, on: self)
            }
            
            self.navigationController?.popViewController(animated: true)
        }
    }
}


extension MainViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = self.dataSource.count
        
        if rows == 0 && tableView.backgroundView == nil {
            if self.emptyView == nil {
                self.emptyView = EmptyDataSourceView(frame: self.tableView.bounds)
                self.emptyView?.onTap = { [weak self] in
                    self?.getItems()
                }
            }
            
            tableView.backgroundView = self.emptyView
        } else if rows > 0 && tableView.backgroundView != nil {
            tableView.backgroundView = nil
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        let item = self.dataSource[indexPath.row]
        
        cell.label1.text = item.name
        cell.label2.text = item.type.rawValue
        cell.label3.text = "\(item.quantity)"
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let item = self.dataSource[indexPath.row]
        
        self.delete(item: item.id, rowIndex: indexPath)
    }
}


extension MainViewController: UITableViewDelegate {
    
    
}

