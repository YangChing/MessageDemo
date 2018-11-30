//
//  ViewModel.swift
//  MessageDemo
//
//  Created by 馮仰靚 on 2018/11/29.
//  Copyright © 2018 YCFeng.com.tw. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol ViewModelDelegate: class {
  func updateChatRoomList()
}

class ViewModel {

  var chatRooms = [ChatRoom]() {
    didSet {
      delegate.updateChatRoomList()
    }
  }

  var db: Firestore!
  var chatRoomRef: CollectionReference!
  weak var delegate: ViewModelDelegate!

  init() {
    db = Firestore.firestore()
    chatRoomRef = db.collection("chatRoom")
    autoUpdate()
  }

  func autoUpdate() {
    chatRoomRef.addSnapshotListener { (querySnapshot, err) in
      if let err = err {
        print("getChatRooms error: \(err)")
      } else {
        if let snapshot = querySnapshot {
          self.chatRooms.removeAll()
          let doucments = snapshot.documents.sorted(by: { (snapshotOld, snapshopNew) -> Bool in
            if let newDate = snapshopNew.data()["updateDate"] as? Date,
              let oldDate = snapshotOld.data()["updateDate"] as? Date
            {
              return newDate.compare(oldDate) == .orderedAscending
            }
            return false
          })
          for doucment in doucments {
            let chatroom = ChatRoom(createDate: doucment.data()["createDate"] as? Timestamp ??  Timestamp(date: Date()))
            chatroom.name = doucment.data()["name"] as? String
            chatroom.createdBy = doucment.data()["createdBy"] as? String
            chatroom.updateDate = doucment.data()["updateDate"] as? Timestamp ??  Timestamp(date: Date())
            chatroom.doucmentID = doucment.documentID
            self.chatRooms.append(chatroom)
          }
        }
      }
    }
  }

  func dataMaker(roomName: String) -> [String: Any]{
    let chatRoom = ChatRoom(createDate:  Timestamp(date: Date()))
    chatRoom.createdBy = myUserDefaults.value(forKey: "email") as? String ?? ""
    chatRoom.name = roomName
    return [ "name" : "\(roomName)", "createdBy" : "\(chatRoom.createdBy ?? "")", "createDate" : chatRoom.createDate, "updateDate" : chatRoom.updateDate]
  }

  func createChatRoom(roomName: String, completion: @escaping (Bool) -> ()) {
    chatRoomRef.addDocument(data: self.dataMaker(roomName: roomName)) { (err) in
      if let err = err {
        print(err)
        completion(false)
      } else {
        completion(true)
      }
    }
  }

  func deleteChatRoom(doucmentID: String) {
    chatRoomRef.document("\(doucmentID)").delete() { err in
      if let err = err {
        print("Error removing document: \(err)")
      } else {
        print("Document successfully removed!")
      }
    }
  }

  func isAuth(createdBy: String) -> Bool {
    if let email = myUserDefaults.value(forKey: "email") as? String{
      return createdBy == email
    }
    return false
  }


  func isRoomNameExist(_ roomName: String, completion: @escaping (Bool) -> ()) {
    chatRoomRef.getDocuments { (querySnapshot, err) in
      if let err = err {
        print("isRoomNameExist error: \(err)")
        completion(false)
      } else {
        if let snapshot = querySnapshot {
          if snapshot.documents.filter({ (document) -> Bool in
            guard let name = document.data()["name"] as? String else {
              return false
            }
            return name == roomName
          }).count > 0 {
            completion(true)
          } else {
            completion(false)
          }
        }
      }
    }
  }
}
