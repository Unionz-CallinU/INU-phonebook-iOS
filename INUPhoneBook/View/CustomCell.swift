import UIKit

import SnapKit

// 직원번호, 소속, 상세소속, 이름, 직위,담당업무, 전화번호, 이메일, 사진
struct User {
  let employeeNum: String
  let college: String
  let department: String
  let name: String
  let position: String
  let role: String
  let phonNum: String
  let email: String
  let image: UIImage
  var isSaved: Bool
}

final class CustomCell: UITableViewCell {
  static let cellId = "CellId"
 
  var user: User? {
    didSet {
      guard let user = user else { return }
      
      profile.image = user.image
      name.text = user.name
      college.text = user.college
      phoneNum.text = user.phonNum
      email.text = user.email
    }
  }
  
  let profile: UIImageView = {
    let img = UIImageView()
    return img
  }()
  
  let name: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let college: UILabel = {
    let label = UILabel()
    label.textColor = .gray
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  
  let phoneNum: UILabel = {
    let label = UILabel()
    return label
  }()
  
  let email: UILabel = {
    let label = UILabel()
    return label
  }()
  
  
  let star: UIButton = {
    let btn = UIButton()
    let img = UIImage(named: "Star")
    btn.setImage(img, for: .normal)
    btn.addTarget(self, action: #selector(likeBtnPressed), for: .touchUpInside)
    return btn
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLayout()
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupLayout(){
    [
      profile,
      name,
      college,
      phoneNum,
      email,
      star
    ].forEach {
      self.addSubview($0)
    }
  }
  
  func makeUI() {
    profile.snp.makeConstraints { make in
      make.size.equalTo(CGSize(width: 80, height: 80))
      make.leading.equalToSuperview().offset(-8)
      make.top.equalToSuperview().offset(8)
    }
    name.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalTo(profile.snp.trailing).offset(-10)
    }
    college.snp.makeConstraints { make in
      make.leading.equalTo(name.snp.leading).offset(50)
      make.top.equalToSuperview().offset(12)
    }
    phoneNum.snp.makeConstraints { make in
      make.leading.equalTo(name.snp.leading)
      make.top.equalTo(name.snp.bottom).offset(5)
    }
    email.snp.makeConstraints { make in
      make.leading.equalTo(name.snp.leading)
      make.top.equalTo(phoneNum.snp.bottom).offset(5)
      make.bottom.equalToSuperview().offset(-10)
    }
    star.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-10)
      make.centerY.equalToSuperview()
    }
  }
  
  @objc func likeBtnPressed() {
    print("hello \(user?.isSaved)")

    let emptyStarImg = UIImage(named: "Star")
    let checkedStarImg = UIImage(named: "StarChecked")
    
    if user?.isSaved == false {
      user?.isSaved = true
      star.setImage(checkedStarImg, for: .normal)
      print("\(user?.isSaved)")
    } else {
      user?.isSaved = false
      star.setImage(emptyStarImg, for: .normal)
    }
    
  }
  
}

