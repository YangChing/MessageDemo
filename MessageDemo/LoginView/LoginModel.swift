//
//  LoginModel.swift
//  MessageDemo
//
//  Created by 馮仰靚 on 2018/11/29.
//  Copyright © 2018 YCFeng.com.tw. All rights reserved.
//

import Foundation


class Member {

  var nickname: String?
  var email: String?

  init(email: String, nickname: String) {
    self.email = email
    self.nickname = nickname
  }

}
