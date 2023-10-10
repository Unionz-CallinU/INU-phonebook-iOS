//
//  DetailViewcontroller.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2523/07/19.
//

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
  var labelText: String?
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if self.isMovingFromParent { resultVC?.reloadTalbeView() }
  }
  
  private let circleImage: UIImageView = {
    let view = UIImageView()
    
    let viewImgName = String.selectImgMode("ImgBackGround",
                                           "ImgBackGround_dark")
    let viewImg = UIImage(named: viewImgName)?.withRenderingMode(.alwaysOriginal)
    
    view.image = viewImg
    view.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
    
    return view
  }()
  
  private let professorImage: UIImageView = {
    let view = UIImageView()
    let image = UIImage(named: "mainimage")
    view.image = image
    view.frame = CGRect(x: 0, y: 0, width: 62, height: 81)
    view.layer.cornerRadius = 15
    return view
  }()
  
  // MARK: - 바뀌는 label
  private let nameTextLabel: UILabel = {
    let label = UILabel()
    let labelColor = UIColor.selectColor(lightValue: .black,
                                         darkValue: .white)
    label.textColor = labelColor
    label.font = UIFont(name: "Pretendard", size: 24)
    label.textAlignment = .center
    return label
  }()
  
  private let collegeLabel: UILabel = {
    let label = UILabel()
    let labelColor = UIColor.selectColor(lightValue: .black,
                                         darkValue: .grey2)
    label.textColor = labelColor
    label.font = UIFont(name: "Pretendard", size: 16)
    label.textColor = labelColor
    return label
  }()
  
  private let departmentLabel: UILabel = {
    let label = UILabel()
    let labelColor = UIColor.selectColor(lightValue: .lightGray,
                                         darkValue: .grey2)
    label.textColor = labelColor
    label.font = UIFont(name: "Pretendard", size: 16)
    label.textColor = .lightGray
    return label
  }()
  
  lazy var positionLabel: UILabel = {
    let label = UILabel()
    let labelColor = UIColor.selectColor(lightValue: .lightGray,
                                         darkValue: .grey2)
    label.font = UIFont(name: "Pretendard", size: 16)
    label.textColor = labelColor
    
    return label
  }()
  
  lazy var roleLabel: UILabel = {
    let label = UILabel()
    let labelColor = UIColor.selectColor(lightValue: .lightGray,
                                         darkValue: .grey2)
    label.font = UIFont(name: "Pretendard", size: 16)
    label.textColor = labelColor
    label.lineBreakMode = .byWordWrapping
    label.numberOfLines = 2
    
    return label
  }()
  
  lazy var phoneNumLabel: UIButton = {
    let btn = UIButton()
    let btnColor = UIColor.selectColor(lightValue: .black, darkValue: .white)
    btn.titleLabel?.font = UIFont(name: "Pretendard", size: 18)
    btn.setTitleColor(btnColor ,for: .normal)
    btn.addTarget(self, action: #selector(touchUpForCalling), for: .touchUpInside)
    // 왼쪽 이미지 설정
    let leftImage = UIImage(named: "Call")
    btn.setImage(leftImage, for: .normal)
    
    let spacingBetweenImageAndTextLeftSide : CGFloat = 8.0
    btn.imageEdgeInsets = UIEdgeInsets(top: 0,
                                       left:-spacingBetweenImageAndTextLeftSide,
                                       bottom :0,
                                       right :spacingBetweenImageAndTextLeftSide)
    return btn
  }()
  
  lazy var phoneNumButton: UIButton = {
    let btn = UIButton()
    btn.addTarget(self, action: #selector(touchUpForCalling), for: .touchUpInside )
    
    let leftImage = UIImage(named: "linkImg")
    btn.setImage(leftImage, for: .normal)
    return btn
  }()
  
  lazy var emailLabel: UIButton = {
    let btn = UIButton()
    let btnColor = UIColor.selectColor(lightValue: .black, darkValue: .white)
    btn.titleLabel?.font = UIFont(name: "Pretendard", size: 18)
    btn.setTitleColor(btnColor ,for: .normal)
    btn.addTarget(self, action: #selector(touchUpFormailing), for: .touchUpInside )
    
    // 왼쪽 이미지 설정
    let leftImage = UIImage(named: "Mail")
    btn.setImage(leftImage, for: .normal)
    
    let spacingBetweenImageAndTextLeftSide : CGFloat = 8.0
    btn.imageEdgeInsets = UIEdgeInsets(top: 0,
                                       left:-spacingBetweenImageAndTextLeftSide,
                                       bottom :0,
                                       right :spacingBetweenImageAndTextLeftSide)
    return btn
  }()
  
  lazy var maillinkButton: UIButton = {
    let btn = UIButton()
    btn.addTarget(self, action: #selector(touchUpFormailing), for: .touchUpInside )
    
    let leftImage = UIImage(named: "linkImg")
    btn.setImage(leftImage, for: .normal)
    return btn
  }()
  
  // MARK: - 즐겨찾기에 등록된 경우 추가되는 UI
  lazy var selectLabel: UILabel = {
    let label = UILabel()
    label.textColor = UIColor.blue
    label.font = UIFont(name: "Pretendard", size: 18)
    label.numberOfLines = 1
    label.text = userToCore?.category
    return label
  }()
  
  lazy var selectButton: UIButton = {
    let button = UIButton()
    let btnColor = UIColor.selectColor(lightValue: .grey1,
                                       darkValue: .grey4)
    button.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
    button.backgroundColor = btnColor
    return button
  }()
  
  private let selectBtnImage: UIImageView = {
    let view = UIImageView()
    view.image = UIImage(named: "Left")
    return view
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let mainBackGroundColor = UIColor.selectColor(lightValue: .white,
                                                  darkValue: UIColor.mainBlack)
    
    self.view.backgroundColor = mainBackGroundColor
    
    cellToDetail()
    cellToDetailCore()
    isSavedCheck()
    
    setNavigationbar()
  }
  
  func setNavigationbar() {
    let buttonImage: UIImage?
    let action: Selector
    
    let plusImgName = String.selectImgMode("Plus",
                                           "Plus_dark")
    let plusImg = UIImage(named: plusImgName)?.withRenderingMode(.alwaysOriginal)
    
    let minusImgName = String.selectImgMode("Minus",
                                            "Minus_dark")
    let minusImg = UIImage(named: minusImgName)?.withRenderingMode(.alwaysOriginal)
    
    let backBtnColor = UIColor.selectColor(lightValue: .black,
                                           darkValue: .grey2)
    
    self.navigationController?.navigationBar.topItem?.title = ""
    self.navigationController?.navigationBar.tintColor = backBtnColor
    
    if userToCore?.isSaved == true || makeStatus == true {
      buttonImage = minusImg
      action = #selector(addToLike)
    } else {
      buttonImage = plusImg
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
    phoneNumLabel.setTitle(data.phoneNumber, for: .normal)
    roleLabel.text = data.role
    emailLabel.setTitle(data.email, for: .normal)
    positionLabel.text = data.position
    
    guard data.imageUrl != nil else { return }
    if let img = UIImage(base64: data.imageUrl!, withPrefix: false) {
      
      let resizedImage = img.withRenderingMode(.alwaysOriginal)
        .resized(to: CGSize(width: 64, height: 81))
      
      professorImage.image = resizedImage
      
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
    userToLike?.position = data.position
    
    userToLike = data
  }
  
  func cellToDetailCore(){
    guard let dataToCore = userToCore else { return }
    nameTextLabel.text = dataToCore.name
    collegeLabel.text = dataToCore.college
    departmentLabel.text = dataToCore.department
    phoneNumLabel.setTitle(dataToCore.phoneNumber, for: .normal)
    roleLabel.text = dataToCore.role
    emailLabel.setTitle(dataToCore.email, for: .normal)
    positionLabel.text = dataToCore.position
    
    if let img = UIImage(base64: dataToCore.imgUrl ?? "mainimage", withPrefix: false) {
      professorImage.image = img
    } else {
      professorImage.image = UIImage(named: "mainimage")
    }
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
      positionLabel,
      maillinkButton,
      phoneNumButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - UI세팅
  func makeUI() {
    let roleLabelSize = roleLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                      height: CGFloat.greatestFiniteMagnitude))
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
      make.centerX.centerY.equalTo(circleImage)
      make.width.equalTo(62)
      make.height.equalTo(81)
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
      make.centerX.equalToSuperview()
      make.top.equalTo(collegeLabel.snp.bottom).offset(10)
    }
    
    positionLabel.snp.makeConstraints { make in
      make.top.equalTo(departmentLabel.snp.bottom).offset(10)
      make.centerX.equalToSuperview()
    }
    
    
    roleLabel.snp.makeConstraints { make in
      if roleLabelSize.width < view.bounds.width {
        make.centerX.equalToSuperview()
      } else {
        make.leading.trailing.equalToSuperview().inset(20)
      }
      make.top.equalTo(positionLabel.snp.bottom).offset(10)
    }
    
    phoneNumLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(roleLabel.snp.bottom).offset(30)
    }
    
    phoneNumButton.snp.makeConstraints { make in
      make.leading.equalTo(phoneNumLabel.snp.trailing).offset(5)
      make.centerY.equalTo(phoneNumLabel.snp.centerY)
    }
    emailLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(phoneNumLabel.snp.bottom).offset(10)
    }
    
    maillinkButton.snp.makeConstraints { make in
      make.leading.equalTo(emailLabel.snp.trailing).offset(5)
      make.centerY.equalTo(emailLabel.snp.centerY)
    }
    
  }
  
  // MARK: - 저장여부에 따라 UI 변경
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
  @objc func addToLike() {
    let user = userData?.first
    let userToCore = userToCore
    let checkDataCore = userManager.getUsersFromCoreData()
    
    userToLike = user
    
    if let userId = user?.name ?? userToCore?.name {
      if let existingUser = checkDataCore.first(where: { $0.name == userId }) {
        self.makeRemoveCheckAlert { removeAction in
          if removeAction {
            existingUser.isSaved = false
            self.makeStatus = false
            
            let customPopupVC = CustomPopupViewController()
            
            customPopupVC.titleLabel.text = "\(existingUser.name!) 님이"
            customPopupVC.descriptionLabel.text = "즐겨찾기목록에 삭제되었습니다."
            
            customPopupVC.modalPresentationStyle = .overFullScreen
            
            self.userManager.deleteUserFromCoreData(with: existingUser) {
              DispatchQueue.main.async {
                self.deleteUI()
                self.setNavigationbar()
                self.senderLikeVC?.reloadTableView()
              }
              
              self.present(customPopupVC, animated: false, completion: nil)
            }
          } else {
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
    dropDown.backgroundColor = .grey1
    dropDown.customCellConfiguration = { (index, item, cell) in
      let separator = UIView()
      separator.backgroundColor = .grey3
      cell.addSubview(separator)
      separator.snp.makeConstraints { make in
        make.leading.trailing.equalToSuperview()
        make.bottom.equalToSuperview()
        make.height.equalTo(1)
      }
      
      cell.optionLabel.textAlignment = .center
      cell.optionLabel.textColor = .grey3
    }
    
    dropDown.selectionAction = { [weak self] (index, item) in
      guard let self = self else { return }
      if let userToCore = self.userToCore {
        self.coreDataManager.updateCategory(for: userToCore, with: item) {
          self.selectLabel.text = item
          self.senderLikeVC?.reloadTableView()
        }
      }
      if let userToLike = self.userToLike {
        if let matchingUser = self.userManager.getUsersFromCoreData().first(where: { $0.name == userToLike.name }) {
          self.coreDataManager.updateCategory(for: matchingUser, with: item) {
            self.selectLabel.text = item
          }
        }
      }
    }
    
    dropDown.show()
  }
}

// MARK: - 즐겨찾기에 저장,삭제 시 Alert 함수
extension DetailViewController {
  @objc private func addBtnTapped() {
    let pop = PopUpViewAtDetail(title: "즐겨찾기",
                                desc: "즐겨찾기목록에 추가하시겠습니까?",
                                user: userToLike,
                                senderVC: self)
    pop.saveAction = { [weak self]  in
      
      let customPopupVC = CustomPopupViewController()
      let userName =  self?.userToLike?.name
      let nameAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Pretendard", size: 24) as Any
      ]
      
      let attributedName = NSAttributedString(string: userName ?? "",
                                              attributes: nameAttributes)
      let descriptionAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Pretendard", size: 18) as Any
      ]
      let descriptionText = NSAttributedString(string: "님이", attributes: descriptionAttributes)
      let finalText = NSMutableAttributedString()
      
      finalText.append(attributedName)
      finalText.append(descriptionText)
      
      customPopupVC.titleLabel.attributedText = finalText
      customPopupVC.descriptionLabel.text = "즐겨찾기에 추가되었습니다."
      customPopupVC.modalPresentationStyle = .overFullScreen
      
      self?.selectLabel.text = self?.labelText
      self?.present(customPopupVC, animated: false, completion: nil)
    }
    
    pop.modalPresentationStyle = .overFullScreen
    
    self.present(pop, animated: false)
  }
  
  func makeRemoveCheckAlert(completion: @escaping (Bool) -> Void) {
    let alert = UIAlertController(title: "삭제?",
                                  message: "정말 지우시겠습니까?",
                                  preferredStyle: .alert)
    let ok = UIAlertAction(title: "확인",
                           style: .default) { okAction in
      completion(true)
    }
    let cancel = UIAlertAction(title: "취소",
                               style: .cancel) { cancelAction in
      completion(false)
    }
    
    let alertColor = UIColor.selectColor(lightValue: .black,
                                         darkValue: .white)
    
    cancel.setValue(alertColor, forKey: "titleTextColor")
    ok.setValue(alertColor, forKey: "titleTextColor")
    
    alert.addAction(ok)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }
}

// MARK: - 전화, 메일 앱 연결
extension DetailViewController {
  @objc func touchUpForCalling(_ sender: UIButton) {
    guard let number = phoneNumLabel.titleLabel?.text else { return }
    
    if let url = NSURL(string: "tel://" + number),
       UIApplication.shared.canOpenURL(url as URL) {
      UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
  }
  
  @objc func touchUpFormailing(_ sender: UIButton) {
    guard let mail = emailLabel.titleLabel?.text else { return }
    if let url = NSURL(string: "mailto://" + mail),
       UIApplication.shared.canOpenURL(url as URL) {
      UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
  }
  
}
