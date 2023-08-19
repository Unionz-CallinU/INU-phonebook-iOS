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
    label.font = .systemFont(ofSize: 30)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  private let descLabel: UILabel = {
    let label = UILabel()
    label.textColor = .gray
    label.font = .systemFont(ofSize: 24)
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
  
  private let separatorLineView: UIView = {
    let view = UIView()
    view.backgroundColor = .gray
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
       leftButtonTitle: String = "Cancel",
       rightButtonTitle: String = "Submit") {
    
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
    
    self.setupConstraints()
    
    self.bodyStackView.addArrangedSubview(self.titleLabel)
    self.bodyStackView.addArrangedSubview(self.descLabel)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupConstraints() {
    self.popupView.snp.makeConstraints { make in
      make.left.right.equalToSuperview().inset(32)
      make.centerY.equalToSuperview()
    }
    
    self.bodyStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(32)
      make.left.right.equalToSuperview().inset(24)
    }
    
    self.separatorLineView.snp.makeConstraints { make in
      make.top.equalTo(self.bodyStackView.snp.bottom).offset(24)
      make.left.right.equalToSuperview()
      make.height.equalTo(1)
    }
    
    self.leftButton.snp.makeConstraints { make in
      make.top.equalTo(self.separatorLineView.snp.bottom)
      make.bottom.left.equalToSuperview()
      make.width.equalToSuperview().dividedBy(2)
      make.height.equalTo(56)
    }
    
    self.rightButton.snp.makeConstraints { make in
      make.top.equalTo(self.separatorLineView.snp.bottom)
      make.bottom.right.equalToSuperview()
      make.width.equalToSuperview().dividedBy(2)
      make.height.equalTo(56)
    }
  }
  
  @objc private func leftButtonTapped() {
    leftButtonAction?()
  }
  
  @objc private func rightButtonTapped() {
    rightButtonAction?()
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
