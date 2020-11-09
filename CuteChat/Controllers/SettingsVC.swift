//
//  SettingsVC.swift
//  CuteChat
//
//  Created by Антон on 03.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit
import Firebase

class SettingsVC: UIViewController {
    
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var changeUsernameButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    let currentUser             = Auth.auth().currentUser
    let changeRequest           = Auth.auth().currentUser?.createProfileChangeRequest()
    let defaults                = UserDefaults.standard
    var arrayUIViews: [UIView]  = []
    var avatarImageView: UIImageView?
    var avatarLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
    }
    
    @IBAction func changeUsernameAction(_ sender: UIButton) {
        presentAlerfForChangeData(title: "Change username", message: nil) { text in
            guard let name = text,
                !name.isEmpty,
                name.first!.isUppercase,
                name.isCyrillic
                else {
                    self.presentMessageAlert(title: AlertMesseges.titleAlert, message: AlertMesseges.wrongUsername, buttonTitle: "Ok")
                    return
            }
            self.changeRequest?.displayName = name
            self.saveSomeChanges()
            self.presentMessageAlert(title: "Success!", message: AlertMesseges.updateUsername, buttonTitle: "Cool")
        }
    }
    
    @IBAction func changePasswordAction(_ sender: UIButton) {
        presentAlerfForChangeData(title: "Change password", message: nil) { text in
            guard let newPassword = text else {
                self.presentMessageAlert(title: AlertMesseges.titleAlert, message: AlertMesseges.emptyField, buttonTitle: "Ok")
                return
            }
            self.currentUser?.updatePassword(to: newPassword, completion: { error in
                if error != nil {
                    self.presentMessageAlert(title: AlertMesseges.titleAlert, message: error!.localizedDescription, buttonTitle: "Ok")
                }
                self.presentMessageAlert(title: "Success!", message: AlertMesseges.updatePassord, buttonTitle: "Cool")
            })
        }
    }
    
    @IBAction func changeAvatarAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose the Library", message: "Please, choose the storage to upload new avatar from", preferredStyle: .alert)
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle = .crossDissolve
        let fromPhotoLibrary = UIAlertAction(title: "Photo Library", style: .default) { action in
            self.getImageFromPhotoLibrary()
        }
        let fromFireStorage = UIAlertAction(title: "Storage Library", style: .default) { action in
            self.getImageFromStorageLibrary()
        }
        alert.addAction(fromPhotoLibrary)
        alert.addAction(fromFireStorage)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteAvatarAction(_ sender: UIButton) {
        guard avatarImageView != nil else {
            presentMessageAlert(title: AlertMesseges.titleAlert, message: "Avatar doesn't set", buttonTitle: "Ok")
            return }
        let alert = UIAlertController(title: "Delete your avatar?", message: "Please, press OK to delete your avatar", preferredStyle: .alert)
        alert.modalPresentationStyle = .overFullScreen
        alert.modalTransitionStyle = .crossDissolve
        let confirm = UIAlertAction(title: "Ok", style: .default) { action in
            self.addAvatarLabel()
            self.avatarImageView?.removeFromSuperview()
            self.avatarImageView = nil
            let ref = Storage.storage().reference().child("avatars").child(self.currentUser!.uid)
            ref.delete { (error) in
                if error != nil {
                    self.presentMessageAlert(title: AlertMesseges.titleAlert, message: error!.localizedDescription, buttonTitle: "Ok")
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(confirm)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureUIElements() {
        arrayUIViews = [changeButton, deleteButton, changeUsernameButton, changePasswordButton, emailLabel]
        for view in arrayUIViews {
            view.layer.cornerRadius = view.frame.size.height / 5
            view.layer.borderWidth  = 2
            view.layer.borderColor  = UIColor.systemGray2.cgColor
        }
        emailLabel.text = currentUser?.email
        configureAvatarView()
    }
    
    func configureAvatarView() {
        if currentUser?.photoURL == nil {
            addAvatarLabel()
        } else {
            addAvatarImage()
        }
    }
    
    func saveSomeChanges() {
        self.changeRequest?.commitChanges(completion: { (error) in
            if error != nil {
                self.presentMessageAlert(title: AlertMesseges.titleAlert, message: error!.localizedDescription, buttonTitle: "Ok")
            }
        })
    }
    
    func addAvatarLabel() {
        avatarLabel = UIHelper.addLabel(on: avatarView)
        avatarLabel?.text = currentUser?.email?.prefix(2).uppercased()
        avatarLabel?.backgroundColor = UserDefaults.standard.colorForKey(key: "color")
        avatarLabel?.font = .systemFont(ofSize: 80)
    }
    
    func addAvatarImage() {
        FirebaseManager.shared.getPhoto(from: (currentUser?.photoURL)!) { (image) in
            DispatchQueue.main.async {
                self.avatarImageView = UIHelper.addImageView(on: self.avatarView)
                self.avatarImageView?.image = image
            }
        }
    }
    
    func getImageFromPhotoLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func getImageFromStorageLibrary() {
        
    }
}

extension SettingsVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let avatarImageView = UIHelper.addImageView(on: avatarView)
        avatarImageView.image = image
        FirebaseManager.shared.uploadImage(currentUserID: currentUser!.uid, photo: image) { (result) in
            switch result {
            case .success(let url):
                self.changeRequest?.photoURL = url
                self.saveSomeChanges()
            case .failure(let error):
                self.presentMessageAlert(title: AlertMesseges.titleAlert, message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
}
