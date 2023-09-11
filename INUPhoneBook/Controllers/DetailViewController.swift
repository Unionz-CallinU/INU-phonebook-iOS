//
//  DetailViewcontroller.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2523/07/19.
//

// 번호 누르면 바로 전화 가능하게, 이메일 누르면 바로 전달 가능하게
// 결과페이지에서 디테일 누를 때 코어데이터에 있으면 코어데이터, 없으면 api에서 즐겨찾기는 코어데이터에서
import UIKit

import SnapKit
import DropDown

class DetailViewController: NaviHelper {
  let userManager = UserManager.shared
  let categoryManager = CategoryManager.shared
  let coreDataManager = CoreDataManager.shared
  
  var userData: [User]?
  var userToCore: Users?
  var userToLike: User?
  var makeStatus: Bool?
  var senderLikeVC: LikeViewController?
  var resultVC: ResultViewController?
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if self.isMovingFromParent { resultVC?.reloadTalbeView() }
  }

  private let circleImage: UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "backGround")
    view.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
    return view
  }()
  
  private let professorImage: UIImageView = {
    let view = UIImageView()
    let image = UIImage(named: "mainimage")
    view.image = image
    view.frame = CGRect(x: 0, y: 0, width: 62, height: 81)
    return view
  }()
  
  // MARK: - 바뀌는 label
  private let nameTextLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard", size: 24)
    label.textAlignment = .center
    return label
  }()
  
  private let collegeLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard", size: 16)
    label.textColor = .lightGray
    return label
  }()
  
  private let departmentLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard", size: 16)
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
    label.font = UIFont(name: "Pretendard", size: 16)
    label.textColor = .lightGray
    return label
  }()
  
  private let phoneNumLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard", size: 18)
    return label
  }()
  
  private let emailLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont(name: "Pretendard", size: 18)
    return label
  }()
  
  // MARK: - 즐겨찾기에 등록된 경우 추가되는 UI
  lazy var selectLabel: UILabel = {
    let label = UILabel()
    label.textColor = .blue
    label.font = .systemFont(ofSize: 16)
    label.numberOfLines = 1
    label.text = userToCore?.category ?? "기본"
    return label
  }()
  
  lazy var selectButton: UIButton = {
    let button = UIButton()
    button.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
    button.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.00)
    return button
  }()
  
  private let selectBtnImage: UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "Left")
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    
    isSavedCheck()
    
    cellToDetail()
    cellToDetailCore()
    setNavigationbar()
  }
  
  func setNavigationbar() {
    let buttonImage: UIImage?
    let action: Selector
   
    self.navigationController?.navigationBar.topItem?.title = ""
    self.navigationController?.navigationBar.tintColor = .black
    
    if userToCore?.isSaved == true || makeStatus == true {
      buttonImage = UIImage(named: "Minus")
      action = #selector(addToLike)
    } else {
      buttonImage = UIImage(named: "Plus")
      action = #selector(addToLike)
    }
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: buttonImage,
      style: .plain,
      target: self,
      action: action
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

    
    guard let img = data.imageUrl else { return }
    if let img = UIImage(base64: data.imageUrl!, withPrefix: false) {
      professorImage.image = img
    } else{
      professorImage.image = UIImage(named: "mainimage")
    }
    
    userToLike?.id = data.id
    userToLike?.name = data.name
    userToLike?.college = data.college
    userToLike?.phoneNumber = data.phoneNumber
    userToLike?.department = data.department
    userToLike?.role = data.role
    userToLike?.email = data.email
    userToLike?.isSaved = data.isSaved
    userToLike?.college = data.category
    
    userToLike = data
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
  func isSavedCheck() {
    let user = userData?.first
    let userToCore = userToCore
    let checkDataCore = userManager.getUsersFromCoreData()
    
    if let userId = user?.name ?? userToCore?.name {
      if let _ = checkDataCore.first(where: { $0.name == userId }) {
        setupLayout()
        makeUI()
      } else {
        setupLayout()
        makeUI()
        deleteUI()
      }
    }
  }
  
  func setupLayout() {
    [
      selectButton,
      selectBtnImage,
      selectLabel,
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
    selectButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(118)
      make.width.equalToSuperview()
    }
    
    selectLabel.snp.makeConstraints { make in
      make.top.equalTo(selectButton.snp.top)
      make.leading.equalTo(selectButton.snp.leading).offset(20)
      make.centerY.equalTo(selectButton)
    }
    
    selectBtnImage.snp.makeConstraints { make in
      make.top.equalTo(selectButton.snp.centerY).offset(-5)
      make.trailing.equalTo(selectButton.snp.trailing).offset(-20)
    }
    
    professorImage.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(163)
      make.top.equalTo(circleImage.snp.top).offset(15)
    }
    
    circleImage.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(138)
      make.top.equalTo(selectButton.snp.bottom).offset(30)
    }
    
    nameTextLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(circleImage.snp.bottom).offset(50)
      make.width.equalTo(293.71)
      make.height.equalTo(22)
    }
    
    collegeLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(nameTextLabel.snp.bottom).offset(20)
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
  
  // 즐겨찾기에 저장 여부에 따라 UI변경
  func deleteUI(){
    self.selectButton.isHidden = true
    self.selectLabel.isHidden = true
    self.selectBtnImage.isHidden = true
  }
  
  func addUI(){
    self.selectButton.isHidden = false
    self.selectLabel.isHidden = false
    self.selectBtnImage.isHidden = false
  }
  
  // MARK: - DetailView에서 즐겨찾기 추가/삭제
  // userdata - api, usertocore,
  // 메인에서 바로 즐겨찾기가서 상세조회 누르고 버튼누르는 경우 - 코어데이터에서 가져와야함
  // 검색 후 상세조회누르고 버튼 누르는 경우 - api에서 가져오기
  // resultview에서 저장하고 detailview에서 삭제 후 바로 추가하면 작동을 안함
  
  @objc func addToLike() {
    let user = userData?.first
    let userToCore = userToCore
    let checkDataCore = userManager.getUsersFromCoreData()
    
    if let userId = user?.name ?? userToCore?.name {
      if let existingUser = checkDataCore.first(where: { $0.name == userId }) {
        self.makeRemoveCheckAlert { removeAction in
          if removeAction {
            existingUser.isSaved = false
            self.makeStatus = false
            self.userManager.deleteUserFromCoreData(with: existingUser) {
              // 데이터 업데이트 및 삭제 작업 완료 후 UI 업데이트
              DispatchQueue.main.async {
                self.deleteUI()
                self.setNavigationbar()
                self.senderLikeVC?.reloadTalbeView()
              }
            }
          } else {
            print("저장된 것 삭제하기 취소됨")
          }
        }
      } else {
        addBtnTapped()
      }
    }
  }
  // 카테고리 관련 함수
  @objc func selectButtonTapped(sender: UIButton) {
    let categories = CategoryManager.shared.fetchCategories()
    var categoryNames: [String] = []
    
    for category in categories {
      if let categoryName = category.cellCategory {
        categoryNames.append(categoryName)
      }
    }
    
    let dropDown = DropDown()
    dropDown.anchorView = sender
    dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
    dropDown.dataSource = categoryNames
    dropDown.selectionAction = { [weak self] (index, item) in
      guard let self = self else { return }
      if let userToCore = self.userToCore {
        self.coreDataManager.updateCategory(for: userToCore, with: item) {
          self.selectLabel.text = item
          self.senderLikeVC?.reloadTalbeView()
          print("Category updated.")
        }
      }
    }
    
    dropDown.show()
  }
}

// MARK: - 즐겨찾기에 저장,삭제 시 Alert 함수
extension DetailViewController {
  // User로 받음
  @objc private func addBtnTapped() {
    let pop = PopUpViewAtDetail(title: "즐겨찾기",
                                desc: "즐겨찾기목록에 추가하시겠습니까?",
                                user: userToLike,
                                senderVC: self)
    pop.modalPresentationStyle = .overFullScreen
    
    self.present(pop, animated: false)
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
