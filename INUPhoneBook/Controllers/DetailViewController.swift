//
//  DetailViewcontroller.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2523/07/19.
//

import UIKit

import SnapKit

class DetailViewController: UIViewController {
  let userManager = UserManager.shared
  var userData: [User]?
  
  private let likeButton: UIButton = {
    let btn = UIButton()
    btn.setImage(UIImage(named: "Plus"), for: .normal)
    btn.setTitleColor(.black, for: .normal)
    btn.addTarget(self, action: #selector(addToLike), for: .touchUpInside)
    return btn
  }()
  
  private let circleImage: UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "backGround")
    view.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
    return view
  }()
  
  private let professorImage: UIImageView = {
    let view = UIImageView()
    let image = UIImage(named: "mainimage")?.withRenderingMode(.alwaysOriginal)
    view.image = image
    view.frame = CGRect(x: 0, y: 0, width: 62, height: 81)
    return view
  }()
  
  // MARK: - 바뀌는 label
  private let nameTextLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard", size: 40)
    return label
  }()
  
  private let collegeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard", size: 25)
    label.textColor = .lightGray
    return label
  }()
  
  private let departmentLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard", size: 25)
    label.textColor = .lightGray
    return label
  }()
  
  private let dividerView: UIView = {
    let view = UIView()
    view.backgroundColor = .lightGray
    return view
  }()
  
  private let roleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard", size: 25)
    label.textColor = .lightGray
    return label
  }()
  
  private let phoneNumLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard", size: 25)
    return label
  }()
  
  private let emailLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard", size: 25)
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    self.navigationController?.navigationBar.topItem?.title = ""
    self.navigationController?.navigationBar.tintColor = .black
    
    setupLayout()
    makeUI()
    cellToDetail()
  }
  
  func cellToDetail() {
    guard let data = userData?.first else { return }
    nameTextLabel.text = data.name
    collegeLabel.text = data.college
    departmentLabel.text = data.department
    phoneNumLabel.text = data.phoneNumber
    roleLabel.text = data.role
    emailLabel.text = data.email
  }
  
  // MARK: - view 계층 구성
  func setupLayout(){
    [
      likeButton,
      circleImage,
      professorImage,
      phoneNumLabel,
      emailLabel,
      nameTextLabel,
      collegeLabel,
      departmentLabel,
      roleLabel,
      dividerView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - UI세팅
  func makeUI() {
    likeButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(65)
      make.trailing.equalToSuperview().offset(-20)
    }
    
    professorImage.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(163)
      make.top.equalToSuperview().offset(171)
//      make.trailing.equalTo(circleImage.snp.trailing).offset(-35)
    }
    
    circleImage.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(138)
      make.top.equalToSuperview().offset(155)
    }
    
    nameTextLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(circleImage.snp.bottom).offset(50)
    }
    
    collegeLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(nameTextLabel.snp.bottom).offset(10)
    }
    
    departmentLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview().offset(-20)
      make.top.equalTo(collegeLabel.snp.bottom).offset(10)
    }
    
    dividerView.snp.makeConstraints { make in
      make.leading.equalTo(departmentLabel.snp.trailing).offset(5)
      make.width.equalTo(1)
      make.height.equalTo(departmentLabel)
      make.top.equalTo(departmentLabel)
    }
    
    roleLabel.snp.makeConstraints { make in
      make.leading.equalTo(dividerView.snp.trailing).offset(5)
      make.top.equalTo(departmentLabel)
    }
    
    phoneNumLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(departmentLabel.snp.bottom).offset(30)
    }
    
    emailLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(phoneNumLabel.snp.bottom).offset(10)
    }
  }
  
  @objc func addToLike(){
    print("hh")
  }
}
