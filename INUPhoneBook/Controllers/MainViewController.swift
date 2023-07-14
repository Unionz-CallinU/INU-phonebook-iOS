//
//  ViewController.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/07/14.
//

import UIKit

import SnapKit

class MainViewController: UIViewController {
  
  // MARK: - 화면구성
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "INU 전화번호부"
    label.font = UIFont.systemFont(ofSize: 44, weight: .bold)
    return label
  }()

  let searchController: UISearchBar = {
    let bar = UISearchBar()
    bar.placeholder = "입력"
    bar.backgroundImage = UIImage()   // 빈 이미지를 넣어서 주변 사각형 제거
    return bar
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white

    setupLayout()
    makeUI()
    navigationItemSetting()
  }
  
  // MARK: - view 계층 구성
  func setupLayout(){
    [
      titleLabel,
      searchController
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - UI세팅
  func makeUI() {
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.7)
      make.top.equalTo(searchController.snp.top).offset(-70)
    }
  
    searchController.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-50)
      make.width.equalToSuperview().multipliedBy(0.9)
      make.height.equalTo(60)
    }
  }
  
  // MARK: - navi 설정
  func navigationItemSetting() {
    let leftButton = UIBarButtonItem(image: UIImage(systemName: "homekit"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(homeButtonTapped(_:)))
    
    let rightButton = UIBarButtonItem(image: UIImage(systemName: "star.fill"),
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

