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
    let homeImageName = String.modeDependentString("Home", "Home_dark")
    let homeImage = UIImage(named: homeImageName)?.withRenderingMode(.alwaysOriginal)

    let leftButton = UIBarButtonItem(image: homeImage,
                                     style: .plain,
                                     target: self,
                                     action: #selector(homeButtonTapped(_:)))
    
    let rightButton = UIBarButtonItem(image: UIImage(named: "Star"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(likeButtonTapped(_:)))
    
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
