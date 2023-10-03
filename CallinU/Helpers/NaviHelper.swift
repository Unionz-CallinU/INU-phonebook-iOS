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
    let homeImgName = String.selectImgMode("Home", "Home_dark")
    let homeImg = UIImage(named: homeImgName)?.withRenderingMode(.alwaysOriginal)
    let leftButton = UIBarButtonItem(image: homeImg,
                                     style: .plain,
                                     target: self,
                                     action: #selector(homeButtonTapped(_:)))
    
    let starImgName = String.selectImgMode("Star", "Star_dark")
    let starImg = UIImage(named: starImgName)?.withRenderingMode(.alwaysOriginal)
    let rightButton = UIBarButtonItem(image: starImg,
                                      style: .plain,
                                      target: self,
                                      action: #selector(likeButtonTapped(_:)))
    
    self.navigationItem.rightBarButtonItem = rightButton
    self.navigationItem.leftBarButtonItem = leftButton
  }

  @objc func homeButtonTapped(_ sender: UIBarButtonItem) {
      // 현재 화면이 MainViewController인지 확인
      if let currentViewController = self.navigationController?.visibleViewController,
         currentViewController is MainViewController {
       
        let customPopupVC = CustomPopupViewController()
        
        customPopupVC.titleLabel.text = "Home"
        customPopupVC.descriptionLabel.text = "이미 Home 화면입니다."
        
        customPopupVC.modalPresentationStyle = .overFullScreen
        self.present(customPopupVC, animated: false, completion: nil)
        return
      }
      
      // MainViewController로 이동
      let mainView = MainViewController()
      self.navigationController?.pushViewController(mainView, animated: true)
  }

  
  @objc func likeButtonTapped(_ sender: UIBarButtonItem) {
    let likeView = LikeViewController()
    self.navigationController?.pushViewController(likeView, animated: true)
  }
}
