//
//  MainVC.swift
//  CuteChat
//
//  Created by Антон on 03.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import UIKit
import Firebase

class MainVC: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var messages: [Message] = []
    let currentUser         = Auth.auth().currentUser
    let defaults            = UserDefaults.standard
    
    var username            = ""
    var avatarLabel: UILabel?
    var avatarImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
        createDismissKeyboardTapGesture()
        keyboardMovesScreen()
        getMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUsername()
        configureAvatarView()
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyboard.instantiateViewController(withIdentifier: "SettingsVC") as! SettingsVC
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let error {
            presentMessageAlert(title: AlertMesseges.titleAlert, message: error.localizedDescription, buttonTitle: "Ok")
        }
        UserDefaults.standard.removeObject(forKey: "userID")
    }
    
    @IBAction func sendPressedButton(_ sender: UIButton) {
        guard messageTextField.text != "",
            let messageBody = messageTextField.text,
            let messageSender = Auth.auth().currentUser?.email else { return }
        
        FirebaseManager.shared.createNewMessage(with: messageSender, and: messageBody) { (alertMessage) in
            if alertMessage != nil {
                self.presentMessageAlert(title: AlertMesseges.titleAlert, message: alertMessage!.localizedDescription, buttonTitle: "Ok")
            }
        }
        DispatchQueue.main.async { self.messageTextField.text = "" }
    }
    
    func getMessages() {
        FirebaseManager.shared.loadMessages { (result) in
            switch result {
            case .failure(let error):
                self.presentMessageAlert(title: AlertMesseges.titleAlert, message: error.localizedDescription, buttonTitle: "Ok")
            case .success(let messages):
                self.updateTableView(with: messages)
            }
        }
    }
    
    func updateTableView(with messages: [Message]) {
        self.messages = messages
        DispatchQueue.main.async {
            self.tableView.reloadData()
            let indexPath = IndexPath(row: self.messages.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func keyboardMovesScreen() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func configureUIElements() {
        title                           = "CuteChat"
        navigationItem.hidesBackButton  = true
        tableView.dataSource            = self
        tableView.separatorStyle        = .none
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        configureAvatarView()
        configureUsername()
    }
    
    func configureUsername() {
        guard let user = currentUser else { return }
        username            = user.displayName ?? "user № \(user.uid)"
        usernameLabel.text  = username
    }
    
    func configureAvatarView() {
        if currentUser?.photoURL == nil {
            addAvatarLabel()
        } else {
            addAvatarImage()
        }
    }
    
    func addAvatarLabel() {
        avatarLabel = UIHelper.addLabel(on: avatarView)
        avatarLabel?.text = currentUser?.email?.prefix(2).uppercased()
        avatarLabel?.backgroundColor = UserDefaults.standard.colorForKey(key: "color")
    }
    
    func addAvatarImage() {
        FirebaseManager.shared.getPhoto(from: (currentUser?.photoURL)!) { (image) in
            DispatchQueue.main.async {
                self.avatarImageView = UIHelper.addImageView(on: self.avatarView)
                self.avatarImageView?.image = image
            }
        }
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if view.frame.origin.y != 0 {
            view.frame.origin.y += keyboardSize.height
        }
    }
}

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.setupCell(with: message)
        switch message.sender {
        case Auth.auth().currentUser?.email:
            cell.leftUsernameLabel.isHidden  = true
            cell.rightUsernameLabel.isHidden = false
        default:
            cell.leftUsernameLabel.isHidden  = false
            cell.rightUsernameLabel.isHidden = true
        }
        return cell
    }
}
