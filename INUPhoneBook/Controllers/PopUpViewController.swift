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
  
  init(title: String, desc: String, user: User?, senderCell: CustomCell?) {
    self.popupView = MyPopupView(title: title, desc: desc)
    super.init(nibName: nil, bundle: nil)
    
    self.user = user
    self.senderCell = senderCell
    
    let backGroundColor = UIColor.selectColor(lightValue: .black,
                                              darkValue: .grey4)
    
    self.view.backgroundColor = backGroundColor
    self.view.addSubview(self.popupView)
    self.setupConstraints()
    
    self.popupView.leftButtonAction = { [weak self] in
      guard let self = self else { return }
      
      self.dismiss(animated: true, completion: nil)
    }
    
    self.popupView.rightButtonAction = { [unowned self] in
      guard let user = self.user else { return }
      self.userManager.saveUserData(with: user) {

        DispatchQueue.main.async { [weak self] in
          guard let self = self, let senderCell = self.senderCell else { return }
      
          senderCell.user?.isSaved = true
          senderCell.setButtonStatus()
        }
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
    let categories = CategoryManager.shared.fetchCategories()
    var categoryNames: [String] = []
    
    for category in categories {
      if let categoryName = category.cellCategory {
        categoryNames.append(categoryName)
      }
    }
    
    let dropDown = DropDown()
    let dropDownColor = UIColor.selectColor(lightValue: .white,
                                            darkValue: .grey2)
    dropDown.anchorView = sender
    dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
    dropDown.dataSource = categoryNames
    dropDown.backgroundColor = dropDownColor
    dropDown.textColor = UIColor.grey3
    
    dropDown.customCellConfiguration = { (index, item, cell) in
      let separator = UIView()
      separator.backgroundColor = .lightGray
      cell.addSubview(separator)
      separator.snp.makeConstraints { make in
        make.leading.trailing.equalToSuperview()
        make.bottom.equalToSuperview()
        make.height.equalTo(1)
      }
      cell.optionLabel.textAlignment = .center
    }
    
    dropDown.selectionAction = { [weak self] (index, item) in
      guard let self = self else { return }
      self.user?.category = item
      self.popupView.selectLabel.text = item
    }
    
    dropDown.show()
    
  }
}
