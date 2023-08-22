//
//  PopUpViewController.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/19.
//

import UIKit

import SnapKit
import DropDown

class MyPopupViewController: UIViewController {
  private let userManager = UserManager.shared
  private let popupView: MyPopupView
  private var user: User?
  private var senderCell: CustomCell?
  
  private let sections: [String] = ["기본"]

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
    
    self.popupView.selectButtonAction = { [weak self] in
      self?.showCategoryList(sender: self?.popupView.selectButton ?? UIButton())
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
  
  @objc func showCategoryList(sender: UIButton) {
    let dropDown = DropDown()
    dropDown.anchorView = sender
    dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
    dropDown.dataSource = sections
    dropDown.selectionAction = { [weak self] (index, item) in
      // DropDown의 항목 선택 시의 동작을 구현합니다.
      guard let self = self else { return }
      // 선택된 항목(item)을 사용하여 원하는 동작을 수행합니다.
      self.user?.category = item
      print("선택된 카테고리: \(self.user?.category)")
    }
    dropDown.show()
  }
}
