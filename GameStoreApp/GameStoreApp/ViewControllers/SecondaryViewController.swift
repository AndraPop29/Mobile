//
//  SecondaryViewController.swift
//  GameStoreApp
//
//  Created by Andra on 01/02/2018.
//  Copyright © 2018 Andra. All rights reserved.
//

import UIKit
import Alamofire
import os.log

class SecondaryViewController: UIViewController {

    private var dataSource: [Game] = []
    var purchasedGames: [Game] = []
    var rentedGames: [Game] = []
    var emptyView: EmptyDataSourceView?
    var showBoughtGames = false
    var showRentedGames = false

    @IBOutlet weak var tableView: UITableView!

    @IBAction func seeRentals(_ sender: Any) {
        showRentedGames = true
        loadGames()
        self.dataSource = rentedGames
        self.tableView.reloadData()
    }
    
    @IBAction func seeMyGames(_ sender: Any) {
        showBoughtGames = true
        loadGames()
        self.dataSource = purchasedGames
        self.tableView.reloadData()
    }
    func loadGames() {
        if let games =  NSKeyedUnarchiver.unarchiveObject(withFile: Game.ArchiveURL.path) as? [Game] {
            purchasedGames = games
        }
        
        if let rentGames =  NSKeyedUnarchiver.unarchiveObject(withFile: Game.ArchiveURL2.path) as? [Game] {
            rentedGames = rentGames
        }
        
    }
    func saveGames() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(purchasedGames, toFile:Game.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Purchased games successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save games...", log: OSLog.default, type: .error)
        }
        
      
        let isSuccessfulSave2 = NSKeyedArchiver.archiveRootObject(rentedGames, toFile:Game.ArchiveURL2.path)
        if isSuccessfulSave2 {
            os_log("Rented games successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save games...", log: OSLog.default, type: .error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGames()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showBoughtGames = false
        showRentedGames = false
        loadGames()
        self.getItems()
    }
    
    private func getItems() {
        let endpoint = Endpoint.getAllClientItems
        
        RestApiManager.requestWithResponseData(endpoint: endpoint) { (result: Result<[Game]>)  -> Void in
            switch result {
                
            case .success(let games):
                self.dataSource = games
                self.tableView.reloadData()
                
            case .failure(let error):
                UIAlertController.show(message: error.localizedDescription, on: self)
            }
        }
        
    }
    func idExists(id: Int, list: [Game]) -> Bool {
        loadGames()
        for i in list {
            if i.id == id {
                return true
            }
        }
        return false
    }
    func updateAt(id : Int, list: [Game]) {
        for i in list {
            if i.id == id {
                i.quantity += 1
            }
        }
        saveGames()
    }
    func buyItem(index: Int, game: Game, quantity: Int) {
            let endpoint = Endpoint.buyItem(id: game.id, quantity: quantity)
    
            RestApiManager.requestWithoutResponseData(endpoint: endpoint) { (result: Result<String?>)  -> Void in
                switch result {
    
                case .success(_):
                    if self.idExists(id: game.id, list: self.purchasedGames) {
                        self.updateAt(id: game.id, list: self.purchasedGames)
                    } else {
                        let purchasedGame = Game(id: game.id, name: game.name, quantity: 1, type: game.type, status: game.status)
                        
                        self.purchasedGames.append(purchasedGame)
                    }
                    self.saveGames()
                    self.dataSource[index].quantity -= 1
                    self.tableView.reloadData()
    
                case .failure(let error):
                    UIAlertController.show(message: error.localizedDescription, on: self)
                }
            }
    }
    
    @objc func handleBuy(sender: UIButton) {

        //1. Create the alert controller.
        let alert = UIAlertController(title: "Buy games", message: "Give quantity:", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "Buy", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.buyItem(index: sender.tag, game: self.dataSource[sender.tag], quantity: Int((textField?.text)!)!)
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleReturn(sender: UIButton) {
        let endpoint = Endpoint.returnItem(id: self.dataSource[sender.tag].id)
        
        RestApiManager.requestWithoutResponseData(endpoint: endpoint) { (result: Result<String?>)  -> Void in
            switch result {
                
            case .success(_):
                self.purchasedGames[sender.tag].quantity -= 1
                if self.purchasedGames[sender.tag].quantity == 0 {
                    self.purchasedGames.remove(at: sender.tag)
                }
                self.saveGames()
                self.dataSource = self.purchasedGames
                self.tableView.reloadData()
                
            case .failure(let error):
                UIAlertController.show(message: error.localizedDescription, on: self)
            }
        }
    }
    
    @objc func handleRent(sender: UIButton) {
        let endpoint = Endpoint.rentItem(id: self.dataSource[sender.tag].id)
        RestApiManager.requestWithoutResponseData(endpoint: endpoint) { (result: Result<String?>)  -> Void in
            switch result {
                
            case .success(_):
                if self.idExists(id: self.dataSource[sender.tag].id, list: self.rentedGames) {
                    self.updateAt(id: self.dataSource[sender.tag].id, list: self.rentedGames)
                } else {
                    let game = self.dataSource[sender.tag]
                    let rentedGame = Game(id: game.id, name: game.name, quantity: 1, type: game.type, status: game.status)
                    
                    self.rentedGames.append(rentedGame)
                }
                self.saveGames()
                self.dataSource = self.rentedGames
            
                self.tableView.reloadData()
                self.showRentedGames = true
                
            case .failure(let error):
                UIAlertController.show(message: error.localizedDescription, on: self)
            }
     
        }
    }
}



extension SecondaryViewController : UITableViewDataSource {
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
        if showBoughtGames {
            cell.returnButton.removeTarget(nil, action: nil, for: .allEvents)
            cell.buyButton.isHidden = true
            cell.buyButton.isUserInteractionEnabled = false
            cell.returnButton.isHidden = false
            cell.returnButton.isUserInteractionEnabled = true
            cell.returnButton.setTitle("Return", for: .normal)
            cell.returnButton.tag = indexPath.row
            cell.returnButton.addTarget(self, action:#selector(handleReturn), for: .touchUpInside)
        }
        else if showRentedGames {
            cell.buyButton.isHidden = true
            cell.returnButton.isHidden = true
            cell.returnButton.isUserInteractionEnabled = false
            cell.buyButton.isUserInteractionEnabled = false
        }
        else {
            cell.returnButton.removeTarget(nil, action: nil, for: .allEvents)
            cell.buyButton.isHidden = false
            cell.buyButton.isUserInteractionEnabled = true
            cell.returnButton.isHidden = false
            cell.returnButton.isUserInteractionEnabled = true
            cell.returnButton.setTitle("Rent", for: .normal)
            cell.buyButton.tag = indexPath.row
            cell.buyButton.addTarget(self, action:#selector(handleBuy), for: .touchUpInside)
            cell.returnButton.tag = indexPath.row
            cell.returnButton.addTarget(self, action:#selector(handleRent), for: .touchUpInside)
        }
    
        
        return cell
    }

}


extension SecondaryViewController: UITableViewDelegate {
    
}


