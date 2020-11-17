//
//  RegisterViewController.swift
//  CuteChat
//
//  Created by Антон on 04.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var enterPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    weak var delegate: ActionButtonTappedProtocol!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
    }
    
    @IBAction func registerTappedButton(_ sender: UIButton) {
        guard let email = emailTextField.text,
            let password = enterPasswordTextField.text,
            email != "", password != "" else {
                presentAlert(title: AlertMesseges.titleAlert, message: AlertMesseges.emptyFields, buttonTitle: "Ok")
                return
        }
        guard enterPasswordTextField.text == confirmPasswordTextField.text else {
            presentAlert(title: AlertMesseges.titleAlert, message: AlertMesseges.missMatched, buttonTitle: "Ok")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                self.presentAlert(title: AlertMesseges.titleAlert, message: error!.localizedDescription, buttonTitle: "Ok")
                return
            }
            guard let authResult = authResult else { return }
            PersistenceManager.shared.saveUserInfo(with: authResult)
            self.user = User(avatar: nil, name: nil, email: email, password: password)
            self.delegate.passToMainVC()
        }
    }
    
    private func configureUIElements() {
        let radius: CGFloat                         = 15
        emailTextField.layer.cornerRadius           = radius
        enterPasswordTextField.layer.cornerRadius   = radius
        confirmPasswordTextField.layer.cornerRadius = radius
        registerButton.layer.cornerRadius           = radius
    }
}
