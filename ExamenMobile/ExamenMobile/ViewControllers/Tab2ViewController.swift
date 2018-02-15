//
//  Tab2ViewController.swift
//  ExamenMobile
//
//  Created by Andra Pop on 2018-02-02.
//  Copyright © 2018 Andra. All rights reserved.
//

import UIKit
import Alamofire
import Starscream
import SwiftyJSON
import MBProgressHUD

class Tab2ViewController: UITableViewController, WebSocketDelegate {

    var dataSource: [Car] = []
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocket is connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocket is disconnected: \(error?.localizedDescription)")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        if let data = text.data(using: .utf8) {
            if let json = try? JSON(data: data) {
                let game = Car(id: Int(String(describing: json["id"]))!, name: String(describing: json["name"]), model: String(describing: json["model"]), year: Int(String(describing: json["year"]))!, km: Int(String(describing: json["km"]))!)
                self.dataSource.append(game)
                LocalStorage.store(items: self.dataSource)
                
                
                self.tableView.reloadData()
            }
        }
    }
    var socket : WebSocket?
    
    var hasCurrentCar: Bool {
        return LocalStorage.getCurrentCar() != nil
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("got some data: \(data.count)")
    }


    override func viewDidLoad() {

        super.viewDidLoad()
        
        
        socket = WebSocket(url: URL(string: "http://192.168.8.102:4024")!)
        socket?.delegate = self
        socket?.connect()
        
        let nib = UINib(nibName: "TableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "cellId")
        
        self.setupButtons()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name(rawValue: "name"), object: nil)
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if self.hasCurrentUser {
//            self.fetchRecords()
//        } else {
            if reachability?.networkReachabilityStatus == .some(.notReachable) {
                let localItems = LocalStorage.retrieveItems()
                self.dataSource = localItems
                self.tableView.reloadData()
                
                UIAlertController.show(message: "You have no internet connection. Please retry later by tapping the refresh button.", on: self)
                
            } else {
                self.fetchCars()
                //self.addKm()
            }
        
    }
    
    
    private func setupButtons() {
        
        let leftBtn = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearBtn))
        let rightBtn = UIBarButtonItem(title: "Refresh", style: .plain, target: self, action: #selector(refresh))
        
        self.navigationItem.leftBarButtonItem = leftBtn
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    @objc func clearBtn() {
        LocalStorage.cleanup()

    }
    
    @objc private func refresh() {
        if reachability?.networkReachabilityStatus == .some(.notReachable) {
            let localItems = LocalStorage.retrieveItems()
            self.dataSource = localItems
            self.tableView.reloadData()
            
            
            UIAlertController.show(message: "You have no internet connection. Please retry later by tapping the refresh button.", on: self)
            
        } else {
            self.updateAll()

            self.fetchCars()
            //self.addKm()
        }
    }
    func updateAll() {
        for i in self.dataSource {
            didUpdate(item: (i.id, i.name, "", i.year), index: 0)
        }
    }

    
    

    

    private func fetchCars() {
        let endpoint = Endpoint.cars
        MBProgressHUD.showAdded(to: self.view, animated: true)

        
        APIClient.request(endpoint: endpoint) { (result: Result<[Car]>) -> Void in
            
            switch result {
            case .success(let cars):
                self.dataSource = cars
                LocalStorage.store(items: cars)
                self.tableView.reloadData()
                
            case .failure(let error):
                UIAlertController.show(message: error.localizedDescription, on: self)
                
                self.tableView.reloadData()
            }
            MBProgressHUD.hide(for: self.view, animated: true)

        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TableViewCell
        

            let car = self.dataSource[indexPath.row]
            
            cell.lbl1.text = car.name
            cell.lbl2.isHidden = true

        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            let car = self.dataSource[indexPath.row]
        let editVC = EditViewController.instantiate()
        
        
        editVC.item = car
        editVC.indexOfCar = indexPath.row
        
        editVC.delegate = self
        
        self.navigationController?.pushViewController(editVC, animated: true)
    }

    

    


}

extension Tab2ViewController : EditViewControllerProtocol {
    func didAdd(item: (name: String, model: String, year: Int)) {
        //
    }
    
    func didUpdate(item: (id: Int, name: String, status: String, year: Int), index: Int) {
        MBProgressHUD.showAdded(to: self.view, animated: true)

        if reachability?.networkReachabilityStatus == .some(.notReachable) {
            self.dataSource[index].id = item.id
            self.dataSource[index].name = item.name
            self.dataSource[index].year = item.year
            LocalStorage.store(items: self.dataSource)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(5)) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "name"), object: nil)
            }
            
        }else {
            let endpoint = Endpoint.updateItem(id: item.id, name: item.name, status: item.status, year: item.year)
            
            APIClient.requestData(endpoint: endpoint) { (result: Result<String>) -> Void in
                
                switch result {
                case .success(_):
                    self.tableView.reloadData()
                    LocalStorage.store(items: self.dataSource)
                    
                case .failure(let error):
                    UIAlertController.show(message: error.localizedDescription, on: self)
                }
            }
        }
        MBProgressHUD.hide(for: self.view, animated: true)

        self.navigationController?.popViewController(animated: true)

        
      

    }
    func addMiles(id: Int, km: Int) {
        let endpoint = Endpoint.km(id: id, km: km)
        MBProgressHUD.showAdded(to: self.view, animated: true)

        APIClient.request(endpoint: endpoint) { (result: Result<Car>) -> Void in
            
            switch result {
            case .success(let car):
                self.fetchCars()
                let string = "Total miles: "+"\(car.km)"+", for car "+car.name
                UIAlertController.show(message: string, on: self)
                self.fetchCars()
                LocalStorage.store(items: self.dataSource)
                self.tableView.reloadData()
                
            case .failure(let error):
                UIAlertController.show(message: error.localizedDescription, on: self)
            }
            MBProgressHUD.hide(for: self.view, animated: true)

        }
        self.navigationController?.popViewController(animated: true)
        
    }


}
