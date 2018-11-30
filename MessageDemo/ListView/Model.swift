//
//  Model.swift
//  MessageDemo
//
//  Created by 馮仰靚 on 2018/11/29.
//  Copyright © 2018 YCFeng.com.tw. All rights reserved.
//

import Foundation
import Firebase

class ChatRoom {

  var name: String?
  var createDate = Timestamp(date: Date())
  var updateDate = Timestamp(date: Date())
  var createdBy: String?
  var doucmentID: String?

  init(createDate: Timestamp = Timestamp(date: Date())) {
    self.createDate = createDate
  }

}


