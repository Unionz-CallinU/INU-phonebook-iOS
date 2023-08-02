//
//  NaviHelper.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/02.
//

import UIKit

class NaviHelper: UIViewController {
  // MARK: - navi 설정
  func navigationItemSetting() {
    let leftButton = UIBarButtonItem(image: UIImage(named: "home"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(homeButtonTapped(_:)))
    
    let rightButton = UIBarButtonItem(image: UIImage(named: "Star"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(likeButtonTapped(_:)))
    leftButton.tintColor = .black
    rightButton.tintColor = .black
    
    self.navigationItem.rightBarButtonItem = rightButton
    self.navigationItem.leftBarButtonItem = leftButton
  }
  
  @objc func homeButtonTapped(_ sender: UIBarButtonItem) {
    let mainView = MainViewController()
    self.navigationController?.pushViewController(mainView, animated: true)
  }
  
  @objc func likeButtonTapped(_ sender: UIBarButtonItem) {
    let likeView = LikeViewController()
    self.navigationController?.pushViewController(likeView, animated: true)
  }
}
