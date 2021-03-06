//
//  FirebaseManager.swift
//  CuteChat
//
//  Created by Антон on 05.11.2020.
//  Copyright © 2020 Anton Agafonov. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    
    static let shared = FirebaseManager()
    private let db    = Firestore.firestore()
    
    func createNewMessage(with sender: String, and body: String, completed: @escaping (Error?) -> Void) {
        db.collection(FStore.collectionName).addDocument(data: [
            FStore.senderField: sender,
            FStore.bodyField: body,
            FStore.dateField: Date().timeIntervalSince1970
        ]) { error in
            if error != nil {
                completed(error)
            }
        }
    }
    
    func loadMessages(completed: @escaping (Result<[Message], Error>) -> Void) {
        db.collection(FStore.collectionName)
            .order(by: FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
                var messages: [Message] = []
                guard error == nil else {
                    completed(.failure(error!))
                    return
                }
                guard let snapshotDocuments = querySnapshot?.documents else { return }
                for document in snapshotDocuments {
                    let data = document.data()
                    guard let messageSender = data[FStore.senderField] as? String,
                        let messageBody = data[FStore.bodyField] as? String,
                        let messageDate = data[FStore.dateField] as? Double else { return }
                    let newMessage = Message(sender: messageSender, body: messageBody, date: messageDate.convertDateFromWebToApp())
                    messages.append(newMessage)
                }
                completed(.success(messages))
        }
    }
    
    func uploadImage(imageName: String, photo: UIImage, completed: @escaping (Result<URL, Error>) -> Void) {
        guard let userFolder = Auth.auth().currentUser?.email else { return }
        let ref = Storage.storage().reference().child("avatars").child(userFolder).child(imageName)
        guard let imageData = photo.jpegData(compressionQuality: 0.5) else { return }
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        ref.putData(imageData, metadata: metaData) { (metaData, error) in
            guard let _ = metaData else {
                completed(.failure(error!))
                return
            }
            ref.downloadURL { (url, error) in
                guard let url = url else {
                    completed(.failure(error!))
                    return
                }
                completed(.success(url))
            }
        }
    }
    
    func downloadImages(userFolder: String, completed: @escaping (Result<[UIImage], Error>) -> Void) {
        let storageRef = Storage.storage().reference().child("avatars").child(userFolder)
        var imagesArray: [UIImage] = []
        storageRef.listAll { (result, error) in
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            for item in result.items {
                item.getData(maxSize: 2 * 1024 * 1024) { (data, error) in
                    guard let data = data else {
                        completed(.failure(error!))
                        return
                    }
                    guard let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        imagesArray.append(image)
                        print(imagesArray.count)
                    }
                }
            }
            completed(.success(imagesArray))
        }
    }
    
    func getPhoto(from url: URL, completed: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil,
                let response = response as? HTTPURLResponse, response.statusCode == 200,
                let imageData = data,
                let image = UIImage(data: imageData) else {
                    completed(nil)
                    return
            }
            completed(image)
        }
        task.resume()
    }
}
