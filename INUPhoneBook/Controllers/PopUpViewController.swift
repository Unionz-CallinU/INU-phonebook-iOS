//
//  PopUpViewController.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/19.
//

import UIKit

import SnapKit

class MyPopupViewController: UIViewController {
  private let userManager = UserManager.shared
  private let popupView: MyPopupView
  private var user: User?
  private var senderCell: CustomCell?
  
  
  init(title: String, desc: String, user: User?, senderCell: CustomCell?) {
    self.popupView = MyPopupView(title: title, desc: desc)
    super.init(nibName: nil, bundle: nil)
    
    self.user = user
    self.senderCell = senderCell
    
    self.view.backgroundColor = .clear
    self.view.addSubview(self.popupView)
    self.setupConstraints()
    
    self.popupView.leftButtonAction = { [weak self] in
      guard let self = self else { return }
      
      self.dismiss(animated: true, completion: nil)
    }
    
    self.popupView.rightButtonAction = { [weak self] in
      guard let self = self, let user = self.user else { return }
      
      self.userManager.saveUserData(with: user) {
        user.isSaved = true
        self.senderCell?.setButtonStatus()
        
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    self.popupView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
}
