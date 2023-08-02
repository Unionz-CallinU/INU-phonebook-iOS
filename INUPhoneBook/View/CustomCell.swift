import UIKit

import SnapKit

// 직원번호, 소속, 상세소속, 이름, 직위,담당업무, 전화번호, 이메일, 사진
struct User {
  let profile: UIImage
  let name: String
  let major: String
  let phoneNum: String
  let email: String
  let star: UIImage
}

final class CustomCell: UITableViewCell {
  static let cellId = "CellId"
  
  let profile = UIImageView()
  let name = UILabel()
  let major = UILabel()
  let phoneNum = UILabel()
  let email = UILabel()
  let star = UIImageView()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func layout() {
      self.addSubview(profile)
      self.addSubview(name)
      self.addSubview(major)
      self.addSubview(phoneNum)
      self.addSubview(email)
      self.addSubview(star)
      
      profile.translatesAutoresizingMaskIntoConstraints = false
      profile.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
      profile.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
      profile.widthAnchor.constraint(equalToConstant: 60).isActive = true
      profile.heightAnchor.constraint(equalToConstant: 60).isActive = true
      
      name.translatesAutoresizingMaskIntoConstraints = false
      name.leadingAnchor.constraint(equalTo: profile.trailingAnchor, constant: 10).isActive = true
      name.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10).isActive = true
      
      major.translatesAutoresizingMaskIntoConstraints = false
      major.leadingAnchor.constraint(equalTo: name.leadingAnchor).isActive = true
      major.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 5).isActive = true
      
      email.translatesAutoresizingMaskIntoConstraints = false
      email.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
      email.topAnchor.constraint(equalTo: major.bottomAnchor, constant: 5).isActive = true
      
      phoneNum.translatesAutoresizingMaskIntoConstraints = false
      phoneNum.leadingAnchor.constraint(equalTo: name.leadingAnchor).isActive = true
      phoneNum.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 5).isActive = true
      
      star.translatesAutoresizingMaskIntoConstraints = false
      star.widthAnchor.constraint(equalToConstant: 20).isActive = true
      star.heightAnchor.constraint(equalToConstant: 20).isActive = true
      star.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
      star.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
      star.contentMode = .center
      
      
      // 셀 높이 조절
      let stackView = UIStackView(arrangedSubviews: [name, major, phoneNum, email])
      stackView.translatesAutoresizingMaskIntoConstraints = false
      stackView.axis = .vertical
      stackView.spacing = 5
      
      contentView.addSubview(stackView)
      stackView.leadingAnchor.constraint(equalTo: profile.trailingAnchor, constant: 10).isActive = true
      stackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
      stackView.centerYAnchor.constraint(equalTo: profile.centerYAnchor).isActive = true
      
      // 높이 조절
      NSLayoutConstraint.activate([
        contentView.heightAnchor.constraint(equalTo: stackView.heightAnchor, constant: 20)
      ])
    }

  
}
