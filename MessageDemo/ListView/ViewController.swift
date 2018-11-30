//
//  ViewController.swift
//  MessageDemo
//
//  Created by 馮仰靚 on 2018/11/15.
//  Copyright © 2018 YCFeng.com.tw. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!

  var viewModel: ViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = self
    tableView.delegate = self
    // Do any additional setup after loading the view, typically from a nib.
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    viewModel = ViewModel()
    viewModel.delegate = self
  }

  func configNV() {
    self.navigationController?.navigationItem.title = "聊天室列表"
  }

  @IBAction func addChatRoom(_ sender: UIBarButtonItem) {

    let alert = UIAlertController(title: "請輸入聊天室名稱", message: "", preferredStyle: .alert)
    alert.addTextField(configurationHandler: nil)
    alert.addAction(UIAlertAction(title: "確認", style: .default, handler: { (action: UIAlertAction!) in
      guard
        let textField = alert.textFields?.first,
        let name = textField.text else {
        return
      }
      self.viewModel.isRoomNameExist(name, completion: { (isExist) in
        if isExist {
          print("存在")
        } else {
          self.viewModel.createChatRoom(roomName: name, completion: {
            isCreated in
            if isCreated {
//              self.viewModel.updateChatRooms()
            } else {
              self.showAlert(title: "建立失敗")
            }
          })
          print("不存在")
        }
      })
    }))
    self.present(alert, animated: true, completion: nil)
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

}

extension ViewController: UITableViewDelegate {


}

extension ViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.chatRooms.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath)
    if let cell = cell as? ChatRoomCell {
      cell.config(chatRoom: viewModel.chatRooms[indexPath.row])
    }
    return cell
  }

  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if (editingStyle == .delete) {

      let cell = tableView.cellForRow(at: indexPath)
      if let cell = cell as? ChatRoomCell {
        guard viewModel.isAuth(createdBy: cell.chatRoom?.createdBy ?? ""), let id = cell.chatRoom?.doucmentID else {
          self.showAlert(title: "非作者本人無法刪除")
          return
        }
        viewModel.deleteChatRoom(doucmentID: id)
      }
      // handle delete (by removing the data from your array and updating the tableview)
    }
  }

}

extension ViewController: ViewModelDelegate {
  func updateChatRoomList() {
    self.tableView.reloadData()
  }
}

class ChatRoomCell: UITableViewCell {

  @IBOutlet weak var createdBy: UILabel!
  var chatRoom: ChatRoom?
  @IBOutlet weak var title: UILabel!

  func config(chatRoom: ChatRoom) {
    self.chatRoom = chatRoom
    self.title.text = chatRoom.name
    self.createdBy.text = "createdBy: \(String(describing: chatRoom.createdBy ?? "無名氏"))"
  }

}
