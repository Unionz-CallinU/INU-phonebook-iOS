//
//  DetailViewcontroller.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2523/07/19.
//

import UIKit

import SnapKit

class DetailViewController: UIViewController {
  private let professorImage: UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "bottomImage")
    view.layer.cornerRadius = 75
    view.clipsToBounds = true
    view.backgroundColor = .lightGray
    return view
  }()
  
  // MARK: - 고정되는 label
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "이름"
    label.font = UIFont.systemFont(ofSize: 25)

    return label
  }()
  
  private let majorLabel: UILabel = {
    let label = UILabel()
    label.text = "주전공"
    label.font = UIFont.systemFont(ofSize: 25)
    return label
  }()
  
  private let subjectLabel: UILabel = {
    let label = UILabel()
    label.text = "담당과목"
    label.font = UIFont.systemFont(ofSize: 25)
    return label
  }()
  
  private let labLabel: UILabel = {
    let label = UILabel()
    label.text = "연구실"
    label.font = UIFont.systemFont(ofSize: 25)
    return label
  }()
  
  private let phoneNumLabel: UILabel = {
    let label = UILabel()
    label.text = "전화번호"
    label.font = UIFont.systemFont(ofSize: 25)
    return label
  }()
  
  private let emailLabel: UILabel = {
    let label = UILabel()
    label.text = "이메일"
    label.font = UIFont.systemFont(ofSize: 25)
    return label
  }()
  
  private let homepageLabel: UILabel = {
    let label = UILabel()
    label.text = "홈페이지"
    label.font = UIFont.systemFont(ofSize: 25)
    return label
  }()
  
  // MARK: - 바뀌는 label
  private let nameTextLabel: UILabel = {
    let label = UILabel()
    label.text = "뚱이"
    label.font = UIFont.systemFont(ofSize: 25)
    return label
  }()
  private let majorTextLabel: UILabel = {
    let label = UILabel()
    label.text = "SWIFT"
    label.font = UIFont.systemFont(ofSize: 25)
    return label
  }()
  private let subjectTextLabel: UILabel = {
    let label = UILabel()
    label.text = "iOS"
    label.font = UIFont.systemFont(ofSize: 25)
    return label
  }()
  private let labTextLabel: UILabel = {
    let label = UILabel()
    label.text = "406"
    label.font = UIFont.systemFont(ofSize: 25)
    return label
  }()
  private let phoneNumTextLabel: UILabel = {
    let label = UILabel()
    label.text = "010-1111-1111"
    label.font = UIFont.systemFont(ofSize: 25)
    label.backgroundColor = .lightGray
    return label
  }()
  private let emailTextLabel: UILabel = {
    let label = UILabel()
    label.text = "abg@abc.com"
    label.font = UIFont.systemFont(ofSize: 20)
    return label
  }()
  private let homepageTextLabel: UILabel = {
    let label = UILabel()
    label.text = "www.home.com"
    label.font = UIFont.systemFont(ofSize: 20)
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    self.title = "상세페이지"
    
    setupLayout()
    makeUI()
  }
  
  // MARK: - view 계층 구성
  func setupLayout(){
    [
      professorImage,
      nameLabel,
      majorLabel,
      subjectLabel,
      labLabel,
      phoneNumLabel,
      emailLabel,
      homepageLabel,
      nameTextLabel,
      majorTextLabel,
      subjectTextLabel,
      labTextLabel,
      phoneNumTextLabel,
      emailTextLabel,
      homepageTextLabel,
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - UI세팅
  func makeUI() {
    professorImage.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(25)
      make.width.height.equalTo(150)
    }
    nameLabel.snp.makeConstraints { make in
      make.top.equalTo(professorImage.snp.bottom).offset(80)
      make.left.equalToSuperview().offset(50)
    }
    majorLabel.snp.makeConstraints { make in
      make.top.equalTo(nameLabel.snp.bottom).offset(20)
      make.left.equalTo(nameLabel)
    }
    subjectLabel.snp.makeConstraints { make in
      make.top.equalTo(majorLabel.snp.bottom).offset(20)
      make.left.equalTo(majorLabel)
    }
    labLabel.snp.makeConstraints { make in
      make.top.equalTo(subjectLabel.snp.bottom).offset(20)
      make.left.equalTo(subjectLabel)
    }
    phoneNumLabel.snp.makeConstraints { make in
      make.top.equalTo(labLabel.snp.bottom).offset(20)
      make.left.equalTo(labLabel)
    }
    emailLabel.snp.makeConstraints { make in
      make.top.equalTo(phoneNumLabel.snp.bottom).offset(20)
      make.left.equalTo(phoneNumLabel)
    }
    homepageLabel.snp.makeConstraints { make in
      make.top.equalTo(emailLabel.snp.bottom).offset(20)
      make.left.equalTo(emailLabel)
    }
    
    nameTextLabel.snp.makeConstraints { make in
      make.top.equalTo(nameLabel)
      make.trailing.equalToSuperview().offset(-100)
    }
    majorTextLabel.snp.makeConstraints { make in
      make.top.equalTo(majorLabel)
      make.trailing.equalToSuperview().offset(-100)
    }
    subjectTextLabel.snp.makeConstraints { make in
      make.top.equalTo(subjectLabel)
      make.trailing.equalToSuperview().offset(-100)
    }
    labTextLabel.snp.makeConstraints { make in
      make.top.equalTo(labLabel)
      make.trailing.equalToSuperview().offset(-100)
    }
    phoneNumTextLabel.snp.makeConstraints { make in
      make.top.equalTo(phoneNumLabel)
      make.trailing.equalToSuperview().offset(-100)
    }
    emailTextLabel.snp.makeConstraints { make in
      make.top.equalTo(emailLabel)
      make.trailing.equalToSuperview().offset(-80)
    }
    homepageTextLabel.snp.makeConstraints { make in
      make.top.equalTo(homepageLabel)
      make.trailing.equalToSuperview().offset(-80)
    }
  }
}

// MARK: - Preview
#if DEBUG
import SwiftUI
struct ViewControllerRepresentable: UIViewControllerRepresentable {
  
  func updateUIViewController(_ uiView: UIViewController,context: Context) {
    // leave this empty
  }
  @available(iOS 13.0.0, *)
  func makeUIViewController(context: Context) -> UIViewController{
    DetailViewController()
  }
}
@available(iOS 13.0, *)
struct ViewControllerRepresentable_PreviewProvider: PreviewProvider {
  static var previews: some View {
    Group {
      if #available(iOS 14.0, *) {
        ViewControllerRepresentable()
          .ignoresSafeArea()
          .previewDisplayName(/*@START_MENU_TOKEN@*/"Preview"/*@END_MENU_TOKEN@*/)
          .previewDevice(PreviewDevice(rawValue: "iPhone 11"))
      } else {
        // Fallback on earlier versions
      }
    }
    
  }
} #endif

