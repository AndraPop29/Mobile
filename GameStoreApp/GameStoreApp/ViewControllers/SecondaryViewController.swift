//
//  SecondaryViewController.swift
//  GameStoreApp
//
//  Created by Andra on 01/02/2018.
//  Copyright © 2018 Andra. All rights reserved.
//

import UIKit
import Alamofire

class SecondaryViewController: UIViewController {

    private var dataSource: [Game] = []
    var emptyView: EmptyDataSourceView?
    @IBOutlet weak var tableView: UITableView!
    
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
        let endpoint = Endpoint.getAllClientItems
        
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
    
    func buyItem(index: Int, id: Int, quantity: Int) {
            let endpoint = Endpoint.buyItem(id: id, quantity: quantity)
    
            RestApiManager.request(endpoint: endpoint) { (result: Result<Game>)  -> Void in
                switch result {
    
                case .success(_):
                    self.dataSource[index].quantity -= quantity
                    self.tableView.reloadData()
    
                case .failure(let error):
                    self.dataSource[index].quantity -= quantity
                    self.tableView.reloadData()
                    //UIAlertController.show(message: error.localizedDescription, on: self)
                }
            }
    }
    
    @objc func handleBuy(sender: UIButton) {

        //1. Create the alert controller.
        let alert = UIAlertController(title: "Some Title", message: "Enter a text", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "Some default text"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            self.buyItem(index: sender.tag, id: self.dataSource[sender.tag].id, quantity: Int((textField?.text)!)!)
//            print("Text field: \(textField?.text)")
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
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
        cell.buyButton.tag = indexPath.row
        cell.buyButton.addTarget(self, action:#selector(handleBuy), for: .touchUpInside)
        
        return cell
    }

}


extension SecondaryViewController: UITableViewDelegate {
    
}

extension SecondaryViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}
