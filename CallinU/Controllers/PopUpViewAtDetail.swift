//
//  PopUpViewAtDetail.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/29.
//


import UIKit

import SnapKit
import DropDown

class PopUpViewAtDetail: UIViewController {
  private let userManager = UserManager.shared
  private let categoryManager = CategoryManager.shared
  private let popupView: MyPopupView
  private var user: User?
  private let sections: [String] = []
  var saveAction: (() -> Void)?
  var check: Bool?
  
  init(title: String, desc: String, user: User? , senderVC: DetailViewController) {
    self.popupView = MyPopupView(title: title, desc: desc)
    super.init(nibName: nil, bundle: nil)
    
    self.user = user
    self.view.backgroundColor = .lightGray.withAlphaComponent(0.8)

    self.view.addSubview(self.popupView)
    self.setupConstraints()
    
    self.popupView.leftButtonAction = { [weak self] in
      guard let self = self else { return }
      
      self.dismiss(animated: true, completion: nil)
    }
    
    self.popupView.rightButtonAction = { [weak self] in
      if self?.check != true {
        var nonCheck = self?.categoryManager.fetchCategories().first?.cellCategory ?? ""
        
        self?.user?.category = nonCheck
        senderVC.self.labelText = nonCheck
      } else {
        senderVC.self.labelText = self?.user?.category
      }
      
      guard let user = self?.user else { return }
      self?.userManager.saveUserData(with: user) {
        self?.user?.isSaved = true
        
        self?.dismiss(animated: true, completion: nil)
        senderVC.self.addUI()
        senderVC.self.makeStatus = true
        senderVC.self.setNavigationbar()
        
        self?.saveAction!()
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
                                            darkValue: .grey4)
    dropDown.anchorView = sender
    dropDown.backgroundColor = dropDownColor
    dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
    dropDown.dataSource = categoryNames
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
      self.check = true
    }
  
    dropDown.show()
  }
}
