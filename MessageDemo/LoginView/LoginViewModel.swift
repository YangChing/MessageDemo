//
//  LoginViewModel.swift
//  MessageDemo
//
//  Created by 馮仰靚 on 2018/11/29.
//  Copyright © 2018 YCFeng.com.tw. All rights reserved.
//

import Foundation
import Firebase

class LoginViewModel {

  func signup(email: String, password: String, nickName: String?, completion: @escaping (Bool) -> ()) {
    Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
      if let user = result?.user {
        self.saveToUserDefault(user: user, nickName: nickName)
        completion(true)
      } else {
        completion(false)
      }
    }
  }

  func logIn(email: String, password: String, nickName: String? ,completion: @escaping (Bool) -> ()) {
    Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
      if let user = result?.user {
        self.saveToUserDefault(user: user, nickName: nickName)
        completion(true)
      } else {
        completion(false)
      }
    }
  }

  func saveToUserDefault(user: User, nickName: String?) {
    let member = Member.init(email: user.email ?? "", nickname: nickName ?? user.displayName ?? "")
    myUserDefaults.setValue(member.email, forKey: "email")
    myUserDefaults.setValue(member.nickname, forKey: "nickname")
    myUserDefaults.synchronize()
  }



  func changeRootView() {
    if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    if let nvc = storyboard.instantiateViewController(withIdentifier: "ListNVC") as? UINavigationController {
      appDelegate.window?.rootViewController = nvc
      }
    }
  }

}

