//
//  LoginViewController.swift
//  explore-ios
//
//  Created by Andra on 06/11/2017.
//  Copyright © 2017 andrapop. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, TextFieldNavigationDelegate{

    @IBOutlet weak var registerNowStackView: UIStackView!
    @IBOutlet weak var passwordView: RegistrationTextFieldView!
    @IBOutlet weak var emailView: RegistrationTextFieldView!
    
    var alert : UIAlertController? = nil

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //clear navigation controller bar color and border
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        //hide labels for email and password at launch (text is visible in placeholder)
        
        //add target for view tap, to dismiss keyboard
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        self.view.addGestureRecognizer(tapRecognizer)
        
        //Setting up password and email fields
        passwordView.navigationDelegate = self
        emailView.navigationDelegate = self
        passwordView.content = "PASSWORD"
        passwordView.isSecured = true
        emailView.content = "EMAIL"
    }
    
    @objc func hideKeyboard(_ sender : Any){
        emailView.textField.resignFirstResponder()
        passwordView.textField.resignFirstResponder()
    }
    
    @IBAction func registerNowPressed(_ sender: Any) {
        if let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "signUpViewControllerId") as? SignUpViewController {
            self.navigationController?.pushViewController(signUpViewController, animated: true)
        }
    }

}
