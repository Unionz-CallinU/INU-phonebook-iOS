import UIKit

import SnapKit

final class CustomCell: UITableViewCell {
  static let cellId = "CellId"
  
  var user: User? {
    didSet {
      configureUIwithData()
    }
  }
  
  var saveButtonPressed: ((CustomCell, Bool) -> ()) = { (sender, pressed) in }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    star.setImage(UIImage(systemName: "heart"), for: .normal)
    star.tintColor = .gray
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
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
    btn.addTarget(CustomCell.self, action: #selector(saveButtonTapped), for: .touchUpInside)
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
  
  
  func configureUIwithData() {
    guard let user = user else { return }
    
    name.text = user.name
    college.text = user.college
    phoneNum.text = user.phoneNumber
    email.text = user.email
    setButtonStatus()
  }
  
  @objc func saveButtonTapped(_ sender: UIButton) {
    guard let isSaved = user?.isSaved else { return }
    
    // 뷰컨트롤로에서 전달받은 클로저를 실행 (내 자신 MusicCell/저장여부 전달하면서) ⭐️
    saveButtonPressed(self, isSaved)
    // 다시 저장 여부 셋팅
    setButtonStatus()
  }
  
  func setButtonStatus() {
    guard let isSaved = self.user?.isSaved else { return }
    // 저장이 되지 않았으면
    if !isSaved {
      star.setImage(UIImage(systemName: "heart"), for: .normal)
      star.tintColor = .gray
      // 저장이 되어 있으면
    } else {
      star.setImage(UIImage(systemName: "heart.fill"), for: .normal)
      star.tintColor = .red
    }
  }
}

