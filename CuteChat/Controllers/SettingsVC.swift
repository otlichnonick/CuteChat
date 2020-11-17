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
    var imagesArray: [UIImage]  = []
    var avatarImageView: UIImageView?
    var avatarLabel: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
    }
    
    @IBAction func changeUsernameAction(_ sender: UIButton) {
        presentAlerfForChangeData(title: "Change username", message: nil) { text in
            guard let name = text, UIHelper.checkUsername(with: name) else {
                self.presentAlert(title: AlertMesseges.titleAlert, message: AlertMesseges.wrongUsername, buttonTitle: "Ok")
                return
            }
            self.changeRequest?.displayName = name
            self.saveSomeChanges()
            self.presentAlert(title: "Success!", message: AlertMesseges.updateUsername, buttonTitle: "Cool")
        }
    }
    
    @IBAction func changePasswordAction(_ sender: UIButton) {
        presentAlerfForChangeData(title: "Change password", message: nil) { text in
            guard let newPassword = text else {
                self.presentAlert(title: AlertMesseges.titleAlert, message: AlertMesseges.emptyField, buttonTitle: "Ok")
                return
            }
            self.currentUser?.updatePassword(to: newPassword, completion: { error in
                if error != nil {
                    self.presentAlert(title: AlertMesseges.titleAlert, message: error!.localizedDescription, buttonTitle: "Ok")
                }
                self.presentAlert(title: "Success!", message: AlertMesseges.updatePassord, buttonTitle: "Cool")
            })
        }
    }
    
    @IBAction func changeAvatarAction(_ sender: UIButton) {
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default) { action in
            self.getImageFromPhotoLibrary()
        }
        let fireStorage = UIAlertAction(title: "Storage Library", style: .default) { action in
            self.getImageFromStorageLibrary()
        }
        presentAlertForChangeAvatar(with: photoLibrary, or: fireStorage)
    }
    
    @IBAction func deleteAvatarAction(_ sender: UIButton) {
        guard avatarImageView != nil else {
            presentAlert(title: AlertMesseges.titleAlert, message: "Avatar doesn't set", buttonTitle: "Ok")
            return }
        let confirm = UIAlertAction(title: "Ok", style: .default) { action in
            UIHelper.addAvatarLabel(on: self.avatarView, fontSize: 80)
            self.deleteAvatarImage()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        presentAlertForDeleteAvatar(with: confirm, or: cancel)
    }
    
    func configureUIElements() {
        arrayUIViews = [changeButton, deleteButton, changeUsernameButton, changePasswordButton, emailLabel]
        for view in arrayUIViews {
            view.layer.cornerRadius = view.frame.size.height / 5
            view.layer.borderWidth  = 2
            view.layer.borderColor  = UIColor.systemGray2.cgColor
        }
        emailLabel.text = currentUser?.email
        currentUser?.photoURL == nil ? UIHelper.addAvatarLabel(on: avatarView, fontSize: 80) : UIHelper.addAvatarImage(on: avatarView)
    }
    
    func saveSomeChanges() {
        self.changeRequest?.commitChanges { (error) in
            if error != nil {
                self.presentAlert(title: AlertMesseges.titleAlert, message: AlertMesseges.notChanged, buttonTitle: "Ok")
            }
        }
    }
    
    func deleteAvatarImage() {
        avatarImageView?.removeFromSuperview()
        avatarImageView = nil
        changeRequest?.photoURL = nil
        saveSomeChanges()
    }
    
    func getImageFromPhotoLibrary() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func getImageFromStorageLibrary() {
        guard let userFolder = Auth.auth().currentUser?.email else { return }
        FirebaseManager.shared.downloadImages(userFolder: userFolder) { (result) in
            switch result {
            case .success(let images):
                print(images.count)
            case .failure(let error):
                self.presentAlert(title: AlertMesseges.titleAlert, message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
}

extension SettingsVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        let avatarImageView = UIHelper.addImageView(on: avatarView)
        avatarImageView.image = image
        let uuid = UUID().uuidString
        FirebaseManager.shared.uploadImage(imageName: uuid, photo: image) { (result) in
            switch result {
            case .success(let url):
                self.changeRequest?.photoURL = url
                self.saveSomeChanges()
            case .failure(let error):
                self.presentAlert(title: AlertMesseges.titleAlert, message: error.localizedDescription, buttonTitle: "Ok")
            }
        }
    }
}
