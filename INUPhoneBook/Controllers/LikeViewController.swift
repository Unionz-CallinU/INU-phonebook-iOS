//
//  LikeViewController.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/07/14.
//

import UIKit

import SnapKit

final class LikeViewController: NaviHelper {
  private let mainTitle: UILabel = {
    let label = UILabel()
    label.text = "즐겨찾기목록"
    label.font = UIFont.systemFont(ofSize: 24)
    return label
  }()
  
  private let mainImage: UIImageView = {
    let img = UIImageView()
    img.image = UIImage(named: "mainImage2")
    return img
  }()
  
  private let bottomTitle: UILabel = {
    let label = UILabel()
    label.text = "즐겨찾기목록에 추가된\n   연락처가 없습니다"
    label.numberOfLines = 2
    label.textColor = .gray
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    
    setupLayout()
    makeUI()
    
    navigationItemSetting()
    self.navigationItem.rightBarButtonItem = .none
  }
  
  func setupLayout(){
    [
      mainTitle,
      mainImage,
      bottomTitle
    ].forEach {
      view.addSubview($0)
    }
  }
  
  func makeUI(){
    mainTitle.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.bottom.equalTo(mainImage.snp.top).offset(30)
      make.centerX.equalToSuperview()
    }
    
    mainImage.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-100)
    }
    
    bottomTitle.snp.makeConstraints { make in
      make.top.equalTo(mainImage.snp.bottom).offset(50)
      make.centerX.equalToSuperview()
    }
  }
}



