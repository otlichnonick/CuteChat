//
//  LoginViewController.swift
//  CuteChat
//
//  Created by Антон on 04.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    weak var delegate: ActionButtonTappedProtocol!
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
    }
    
    @IBAction func loginTappedButton(_ sender: UIButton) {

        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return }
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            guard error == nil else {
                self.presentAlert(title: "Something went wrong", message: error!.localizedDescription, buttonTitle: "Ok")
                return
            }
            guard let authResult = authResult else { return }
            PersistenceManager.shared.saveUserInfo(with: authResult)
            self.delegate.passToMainVC()
        }
    }
    
    func configureUIElements() {
        emailTextField.layer.cornerRadius       = 12
        passwordTextField.layer.cornerRadius    = 12
        loginButton.layer.cornerRadius          = 12
    }
    
}
