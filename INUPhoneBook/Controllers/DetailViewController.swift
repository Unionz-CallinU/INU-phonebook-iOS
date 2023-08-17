//
//  DetailViewcontroller.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2523/07/19.
//

// 번호 누르면 바로 전화 가능하게, 이메일 누르면 바로 전달 가능하게
import UIKit

import SnapKit

class DetailViewController: NaviHelper {
  let userManager = UserManager.shared
  var userData: [User]?
  var userToCore: Users?
  
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
    cellToDetailCore()
    setNavigationbar()
  }
  
  func setNavigationbar() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: UIImage(named: "Plus"),
      style: .plain,
      target: self,
      action: #selector(addToLike)
    )
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
  
  func cellToDetailCore(){
    guard let dataToCore = userToCore else { return }
    nameTextLabel.text = dataToCore.name
    collegeLabel.text = dataToCore.college
    departmentLabel.text = dataToCore.department
    phoneNumLabel.text = dataToCore.phoneNumber
    roleLabel.text = dataToCore.role
    emailLabel.text = dataToCore.email
  }
  
  // MARK: - view 계층 구성
  func setupLayout() {
    [
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
    professorImage.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(163)
      make.top.equalToSuperview().offset(171)
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
  
    // userdata - api, usertocore,
    // 메인에서 바로 즐겨찾기가서 상세조회 누르고 버튼누르는 경우 - 코어데이터에서 가져와야함
    // 검색 후 상세조회누르고 버튼 누르는 경우 - api에서 가져오기
    // 데이터의 id 혹은 이름이 코어데이터에 이미 있으면 삭제하시겠습니까 없으면 추가하시겠습니까
    
  @objc func addToLike() {
    let user = userData?.first
    let userToCore = userToCore
    let checkDataCore = userManager.getUsersFromCoreData()
    
    if let userId = user?.id ?? userToCore?.id {
      if let existingUser = checkDataCore.first(where: { $0.id == userId }) {
        self.makeRemoveCheckAlert { removeAction in
          if removeAction {
            self.userManager.deleteUserFromCoreData(with: existingUser) {
              userToCore?.isSaved = false
              print("저장된 것 삭제")
            }
          } else {
            print("저장된 것 삭제하기 취소됨")
          }
        }

      } else {
        // 즐겨찾기에 없는 경우 - 추가 로직 구현
        self.makeMessageAlert { savedAction in
          if savedAction {
            self.userManager.saveUserData(with: user!) {
              user?.isSaved = true
              print("저장됨")
            }
          } else {
            print("취소됨")
          }
        }
      }
    }
  }

  
  func makeMessageAlert(completion: @escaping (Bool) -> Void) {
    let alert = UIAlertController(title: "저장?",
                                  message: "정말 저장하시겠습니까?",
                                  preferredStyle: .alert)
    
    let ok = UIAlertAction(title: "확인",
                           style: .default) { okAction in
      completion(true)
    }
    let cancel = UIAlertAction(title: "취소",
                               style: .cancel) { cancelAction in
      completion(false)
    }
    
    alert.addAction(cancel)
    alert.addAction(ok)
    
    self.present(alert, animated: true, completion: nil)
  }
  
  func makeRemoveCheckAlert(completion: @escaping (Bool) -> Void) {
    let alert = UIAlertController(title: "삭제?",
                                  message: "정말 저장된거 지우시겠습니까?",
                                  preferredStyle: .alert)
    let ok = UIAlertAction(title: "확인",
                           style: .default) { okAction in
      completion(true)
    }
    let cancel = UIAlertAction(title: "취소",
                               style: .cancel) { cancelAction in
      completion(false)
    }
    alert.addAction(ok)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
}

