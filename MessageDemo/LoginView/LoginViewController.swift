//
//  LoginViewController.swift
//  MessageDemo
//
//  Created by 馮仰靚 on 2018/11/29.
//  Copyright © 2018 YCFeng.com.tw. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

  @IBOutlet weak var email: UITextField!
  @IBOutlet weak var password: UITextField!
  @IBOutlet weak var nickname: UITextField!

  var viewModel: LoginViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.viewModel = LoginViewModel()

  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    
  }


  @IBAction func login(_ sender: UIButton) {

    guard let email = self.email.text else {
      showAlert(title: "請輸入email")
      return
    }

    guard let password = self.password.text else {
      showAlert(title: "請輸入password")
      return
    }

    SVProgressHUD.show(withStatus: "登入中")
    if nickname.text == nil, nickname.text == "" {
      nickname.text = email.components(separatedBy: "@").first
    }

    viewModel.logIn(email: email, password: password, nickName: self.nickname.text) { isSuccess in
      if isSuccess {
        self.showAlert(title: "登入成功", completion: {
          self.viewModel.changeRootView()
        })
      } else {
        self.showAlert(title: "登入失敗")
      }
      SVProgressHUD.dismiss()
    }
  }

  @IBAction func signup(_ sender: UIButton) {

    guard let email = self.email.text else {
      showAlert(title: "請輸入email")
      return
    }

    guard let password = self.password.text else {
      showAlert(title: "請輸入password")
      return
    }

    SVProgressHUD.show(withStatus: "註冊中")
    if nickname.text == nil, nickname.text == "" {
      nickname.text = email.components(separatedBy: "@").first
    }

    viewModel.signup(email: email, password: password, nickName: self.nickname.text) { isSuccess in
      if isSuccess {
        self.showAlert(title: "註冊成功", completion: {
          self.viewModel.changeRootView()
        })
      } else {
         self.showAlert(title: "註冊失敗")
      }
      SVProgressHUD.dismiss()
    }

  }

  func showAlert(title: String, completion: (() -> ())? = nil) {
    let alert = UIAlertController(title: "\(title)", message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "確認", style: .default, handler: { (action: UIAlertAction!) in
      if let completion = completion {
        completion()
      }
    }))
    self.present(alert, animated: true, completion: nil)
  }

  deinit {
    print("login deinit")
  }

}
