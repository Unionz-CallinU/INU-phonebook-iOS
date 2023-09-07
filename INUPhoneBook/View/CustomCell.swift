import UIKit

import SnapKit

final class CustomCell: UITableViewCell {
  static let cellId = "CellId"
  
  var buttonAction: (() -> Void) = {}
  let userManager = UserManager.shared
  var saveButtonPressed: ((CustomCell, Bool) -> ()) = { (sender, pressed) in }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLayout()
    makeUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var user: User? {
    didSet {
      configureUIwithData()
    }
  }
  
  lazy var profile: UIImageView = {
    let img = UIImageView()
    return img
  }()
  
  lazy var name: UILabel = {
    let label = UILabel()
    return label
  }()
  
  lazy var college: UILabel = {
    let label = UILabel()
    label.textColor = .gray
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  
  lazy var phoneNum: UILabel = {
    let label = UILabel()
    return label
  }()
  
  lazy var email: UILabel = {
    let label = UILabel()
    return label
  }()
  
  lazy var star: UIButton = {
    let btn = UIButton()
    let img = UIImage(named: "Star")
    btn.setImage(img, for: .normal)
    btn.addTarget(self, action: #selector(requestTapped), for: .touchUpInside)
    return btn
  }()
  
  func setupLayout() {
    [
      name,
      college,
      phoneNum,
      star
    ].forEach {
      self.contentView.addSubview($0)
    }
  }
  
  func makeUI() {
    name.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(10)
      make.leading.equalToSuperview().offset(20)
    }
    college.snp.makeConstraints { make in
      make.leading.equalTo(name.snp.leading).offset(50)
      make.top.equalToSuperview().offset(12)
    }
    phoneNum.snp.makeConstraints { make in
      make.leading.equalTo(name.snp.leading)
      make.top.equalTo(name.snp.bottom).offset(5)
    }

    star.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-10)
      make.centerY.equalToSuperview()
      make.size.equalTo(CGSize(width: 30, height: 30))
    }
  }
  
  func configureUIwithData() {
    guard let user = user else { return }
    
    name.text = user.name
    college.text = user.college
    phoneNum.text = user.phoneNumber
    email.text = user.email
  }
  
  @objc func requestTapped() {
    guard let user = user else { return }
    saveButtonPressed(self, user.isSaved!)
  }
  
  func setButtonStatus() {
    let starImage = user?.isSaved == true ? UIImage(named: "StarChecked") : UIImage(named: "Star")
    guard let isSaved = self.user?.isSaved else { return }
    if !isSaved {
      star.setImage(starImage, for: .normal)
    } else{
      star.setImage(starImage, for: .normal)
    }
  }
  
  func starBtnTapped(_ sender: UIButton){
    guard let isSaved = user?.isSaved else { return }
    
    saveButtonPressed(self, isSaved)
    setButtonStatus()
  }
}


