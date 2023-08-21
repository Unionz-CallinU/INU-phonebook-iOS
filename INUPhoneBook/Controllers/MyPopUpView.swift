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
    view.backgroundColor = .white
    view.layer.cornerRadius = 12
    view.clipsToBounds = true
    return view
  }()
  
  private let bodyStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 8
    return stackView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .black
    label.font = .systemFont(ofSize: 24)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  private let descLabel: UILabel = {
    let label = UILabel()
    label.textColor = .gray
    label.font = .systemFont(ofSize: 16)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  private let separatorLineView: UIView = {
    let view = UIView()
    view.backgroundColor = .gray
    return view
  }()
  
  private let selectView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 4
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.gray.cgColor
    view.backgroundColor = .clear
    return view
  }()
  
  private let selectLabel: UILabel = {
    let label = UILabel()
    label.textColor = .gray
    label.font = .systemFont(ofSize: 16)
    label.numberOfLines = 1
    label.text = "기본"
    return label
  }()
  
  lazy var selectButton: UIButton = {
    let button = UIButton()
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
    button.setTitleColor(.white, for: .normal)
    button.setBackgroundImage(UIColor.systemBlue.withAlphaComponent(0.5).asImage(), for: .normal)
    button.setBackgroundImage(UIColor.systemBlue.asImage(), for: .highlighted)
    button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private let rightButton: UIButton = {
    let button = UIButton()
    button.setTitleColor(.white, for: .normal)
    button.setBackgroundImage(UIColor.systemBlue.asImage(), for: .normal)
    button.setBackgroundImage(UIColor.blue.asImage(), for: .highlighted)
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
    
    self.backgroundColor = .black.withAlphaComponent(0.3)
    self.addSubview(self.popupView)
    self.popupView.addSubview(self.bodyStackView)
    self.popupView.addSubview(self.separatorLineView)
    self.popupView.addSubview(self.leftButton)
    self.popupView.addSubview(self.rightButton)
    
    self.bodyStackView.addArrangedSubview(self.titleLabel)
    self.bodyStackView.addArrangedSubview(self.descLabel)

    self.selectView.addSubview(self.selectBtnImage)
    self.selectView.addSubview(self.selectButton)
    self.selectView.addSubview(self.selectLabel)
    
    self.bodyStackView.addArrangedSubview(self.selectView)
    
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
    
    self.bodyStackView.snp.makeConstraints { make in
      make.top.left.right.equalToSuperview().inset(24)
      make.bottom.equalTo(self.separatorLineView.snp.top).inset(-24)
    }
    
    self.selectView.snp.makeConstraints { make in
      make.height.equalTo(36)
      make.width.equalTo(descLabel.snp.width)
    }
    
    self.selectButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.width.equalTo(descLabel.snp.width)
    }
    
    self.selectBtnImage.snp.makeConstraints { make in
      make.trailing.equalTo(selectButton.snp.trailing).offset(-20)
      make.centerY.equalToSuperview()
    }
    
    self.selectLabel.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.centerX.equalTo(selectButton)
    }
    
    self.separatorLineView.snp.makeConstraints { make in
      make.left.right.equalToSuperview()
      make.bottom.equalTo(self.leftButton.snp.top)
      make.height.equalTo(1)
    }
    
    self.leftButton.snp.makeConstraints { make in
      make.bottom.left.equalToSuperview()
      make.width.equalTo(self.popupView.snp.width).multipliedBy(0.5)
      make.height.equalTo(56)
    }
    
    self.rightButton.snp.makeConstraints { make in
      make.bottom.right.equalToSuperview()
      make.width.equalTo(self.popupView.snp.width).multipliedBy(0.5)
      make.height.equalTo(56)
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

extension UIColor {
  func asImage(_ width: CGFloat = UIScreen.main.bounds.width, _ height: CGFloat = 1.0) -> UIImage {
    let size: CGSize = CGSize(width: width, height: height)
    let image: UIImage = UIGraphicsImageRenderer(size: size).image { context in
      setFill()
      context.fill(CGRect(origin: .zero, size: size))
    }
    return image
  }
}
