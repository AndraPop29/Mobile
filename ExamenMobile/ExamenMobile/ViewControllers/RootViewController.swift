//
//  RootViewController.swift
//  ExamenMobile
//
//  Created by Andra Pop on 2018-02-02.
//  Copyright © 2018 Andra. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tab1 = Tab1ViewController()
        let tab2 = Tab2ViewController()
        
        let nav1 = UINavigationController(rootViewController: tab2)
        let nav2 = UINavigationController(rootViewController: tab1)

        
        self.viewControllers = [nav2, nav1]
        
        self.tabBar.items?[0].title = "Manager"
        self.tabBar.items?[1].title = "Employee"

        // Do any additional setup after loading the view.
    }

   

}
