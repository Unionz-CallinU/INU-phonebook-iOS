//
//  MyPopUpView.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/19.
//

import UIKit
import SnapKit

class MyPopupView: UIView {
  
  var leftButtonAction: (() -> Void)?
  var rightButtonAction: (() -> Void)?
  var selectButtonAction: (() -> Void)?
  
  private let popupView: UIView = {
    let view = UIView()
    let viewColor = UIColor.selectColor(lightValue: .white,
                                         darkValue: .grey4)
    view.backgroundColor = viewColor
    view.layer.cornerRadius = 12
    view.clipsToBounds = true
    return view
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    let labelColor = UIColor.selectColor(lightValue: .black,
                                         darkValue: .white)
    label.textColor = labelColor
    label.font = UIFont(name: "Pretendard", size: 24)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  private let descLabel: UILabel = {
    let label = UILabel()
    let labelColor = UIColor.selectColor(lightValue: .black,
                                         darkValue: .white)
    label.textColor = labelColor
    label.font = UIFont(name: "Pretendard", size: 16)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  lazy var selectLabel: UILabel = {
    let label = UILabel()
    label.textColor = .gray
    label.font = UIFont(name: "Pretendard", size: 20)
    label.numberOfLines = 1
    label.text = "기본"
    return label
  }()
  
  lazy var selectButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = UIColor.blueGrey
    button.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private let selectBtnImage: UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "Left")
    return view
  }()
  
  private let leftButton: UIButton = {
    let button = UIButton()
    let btnColor = UIColor.selectColor(lightValue: .white,
                                            darkValue: .grey4)
    let btnTextColor = UIColor.selectColor(lightValue: .black,
                                            darkValue: .white)
    
    button.setTitleColor(btnTextColor, for: .normal)
    button.setBackgroundImage(btnColor.asImage(), for: .normal)
    button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private let rightButton: UIButton = {
    let button = UIButton()
    let btnColor = UIColor.selectColor(lightValue: .white,
                                            darkValue: .grey4)
    let btnTextColor = UIColor.selectColor(lightValue: .black,
                                            darkValue: .white)
    
    button.setTitleColor(btnTextColor, for: .normal)
    button.setBackgroundImage(btnColor.asImage(), for: .normal)
    button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    return button
  }()
  
  init(title: String,
       desc: String,
       leftButtonTitle: String = "취소",
       rightButtonTitle: String = "확인") {
    
    self.titleLabel.text = title
    self.descLabel.text = desc
    self.leftButton.setTitle(leftButtonTitle, for: .normal)
    self.rightButton.setTitle(rightButtonTitle, for: .normal)
    
    super.init(frame: .zero)
    
    self.backgroundColor = .clear
    
    self.addSubview(self.popupView)
    self.popupView.addSubview(self.titleLabel)
    self.popupView.addSubview(self.descLabel)
    self.popupView.addSubview(self.leftButton)
    self.popupView.addSubview(self.rightButton)
    
    self.popupView.addSubview(self.selectButton)
    self.popupView.addSubview(self.selectLabel)
    self.popupView.addSubview(self.selectBtnImage)
    
    self.setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    self.popupView.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.8)
    }
    
    self.titleLabel.snp.makeConstraints { make in
      make.top.equalTo(popupView.snp.top).offset(10)
      make.left.right.equalToSuperview().inset(24)
    }
    
    self.descLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(8)
      make.left.right.equalToSuperview().inset(24)
    }
    
    self.selectButton.snp.makeConstraints { make in
      make.top.equalTo(descLabel.snp.bottom).offset(10)
      make.width.equalTo(popupView.snp.width).multipliedBy(0.7)
      make.centerX.equalTo(popupView)
    }
    
    self.selectLabel.snp.makeConstraints { make in
      make.centerX.equalTo(selectButton)
      make.centerY.equalTo(selectButton)
    }
    
    self.selectBtnImage.snp.makeConstraints { make in
      make.trailing.equalTo(selectButton.snp.trailing).offset(-10)
      make.centerY.equalTo(selectButton)
    }
    
    self.leftButton.snp.makeConstraints { make in
      make.top.equalTo(selectLabel.snp.bottom).offset(10)
      make.bottom.left.equalToSuperview()
      make.width.equalTo(self.popupView.snp.width).multipliedBy(0.5)
      make.height.equalTo(40)
    }
    
    self.rightButton.snp.makeConstraints { make in
      make.top.equalTo(selectLabel.snp.bottom).offset(10)
      make.bottom.right.equalToSuperview()
      make.width.equalTo(self.popupView.snp.width).multipliedBy(0.5)
      make.height.equalTo(40)
    }
  }

  
  @objc private func leftButtonTapped() {
    leftButtonAction?()
  }
  
  @objc private func rightButtonTapped() {
    rightButtonAction?()
  }
  
  @objc private func selectButtonTapped() {
    selectButtonAction?()
  }
}
