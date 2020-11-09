//
//  WelcomeController.swift
//  CuteChat
//
//  Created by Антон on 03.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit
import Firebase

class WelcomeController: UIViewController {
    
    @IBOutlet weak var authSegmentControl: UISegmentedControl!
    @IBOutlet weak var authContainerView: UIView!
    
    var registerVC = RegisterViewController()
    var loginVC = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        add(childVC: registerVC)
        registerVC.delegate = self
        loginVC.delegate    = self
        if UserDefaults.standard.value(forKey: "userID") as? String == Auth.auth().currentUser?.uid {
            passToMainVC()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    @IBAction func tappedSegmentControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            remove(childVC: loginVC)
            add(childVC: registerVC)
        case 1:
            remove(childVC: registerVC)
            add(childVC: loginVC)
        default:
            break
        }
    }
    
    func add(childVC: UIViewController) {
        addChild(childVC)
        authContainerView.addSubview(childVC.view)
        childVC.view.frame = authContainerView.bounds
        childVC.didMove(toParent: self)
    }
    
    func remove(childVC: UIViewController) {
        childVC.removeFromParent()
        childVC.view.removeFromSuperview()
    }
}

extension WelcomeController: ActionButtonTappedProtocol {
    func passToMainVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
        navigationController?.pushViewController(destVC, animated: true)
    }
}
