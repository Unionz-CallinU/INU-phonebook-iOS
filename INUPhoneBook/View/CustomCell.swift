import UIKit

import SnapKit

final class CustomCell: UITableViewCell {
  static let cellId = "CellId"
  
  var buttonAction: (() -> Void) = {}
  let userManager = UserManager.shared

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupLayout()
    makeUI()
    
    star.addTarget(self, action: #selector(requestTapped), for: .touchUpInside)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var user: User? {
    didSet {
      configureUIwithData()
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
    return btn
  }()
  
  func setupLayout() {
    [
      profile,
      name,
      college,
      phoneNum,
      email,
      star
    ].forEach {
      self.contentView.addSubview($0)
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
      make.size.equalTo(CGSize(width: 30, height: 30)) // 버튼 크기 설정
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
    buttonAction()
  }
  func handleButtonAction() {
      let isSaved = user?.isSaved ?? false
      let alertTitle = isSaved ? "삭제하시겠습니까?" : "추가하시겠습니까?"
      
      let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
          self?.user?.isSaved.toggle()
          self?.setButtonStatus()
      }))
      alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
      
      if let topViewController = UIApplication.shared.windows.first?.rootViewController {
          topViewController.present(alert, animated: true, completion: nil)
      }
  }

  func setButtonStatus() {
    let starImage = user?.isSaved == true ? UIImage(named: "StarChecked") : UIImage(named: "Star")
    star.setImage(starImage, for: .normal)
    // 버튼 액션 블록 설정
    buttonAction = { [weak self] in
      guard let self = self else { return }

      self.user?.isSaved.toggle()
      self.setButtonStatus()
    }
  }

}


