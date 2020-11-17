//
//  UIViewController+Ext.swift
//  CuteChat
//
//  Created by Антон on 03.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func presentAlert(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message , preferredStyle: .alert)
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            let action = UIAlertAction(title: buttonTitle, style: .default)
            alert.addAction(action)
            self.present(alert, animated: true)
        }
    }
    
    func presentAlerfForChangeData(title: String, message: String?, completed: @escaping (String?) -> Void) {
        var textField = UITextField()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle = .crossDissolve
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "enter new data"
            textField = alertTextField
        }
        let confirmAction = UIAlertAction(title: "Ok", style: .default) { action in
            completed(textField.text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentAlertForChangeAvatar(with firstAction: UIAlertAction, or secondAction: UIAlertAction) {
        let alert = UIAlertController(title: "Choose the Library", message: "Please, choose the storage to upload new avatar from", preferredStyle: .alert)
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle = .crossDissolve
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        present(alert, animated: true, completion: nil)
    }
    
    func presentAlertForDeleteAvatar(with firstAction: UIAlertAction, or secondAction: UIAlertAction) {
        let alert = UIAlertController(title: "Delete your avatar?", message: "Please, press OK to delete your avatar", preferredStyle: .alert)
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle = .crossDissolve
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}
