//
//  LikeViewController.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/07/14.
//

//  cell이 0개가 되었을 때 새로 추가되었을 때 화면 리로드, 카테고리 추가

import UIKit

import SnapKit

final class LikeViewController: NaviHelper, UITableViewDelegate {
  
  let userManager = UserManager.shared
  let categoryManager = CategoryManager.shared
  var minusButtonVisible: Bool = false
  var checkButtonStatus: Bool = false
  
  private var sections: [String] = []
  private var deleteSections: [String] = []
  private var checkButtons: [UIButton] = []

  // MARK: - 화면구성
  private let mainTitle: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 24)
    return label
  }()
  
  private let mainImage: UIImageView = {
    let img = UIImageView()
    img.image = UIImage(named: "mainImage2")
    return img
  }()
  
  private let bottomTitle: UILabel = {
    let label = UILabel()
    label.text = "즐겨찾기목록에 추가된\n   연락처가 없습니다"
    label.numberOfLines = 2
    label.textColor = .gray
    return label
  }()
  
  lazy var editButton: UIButton = {
    let btn = UIButton()
    let btnImgName = String.selectImgMode("Edit", "Edit_dark")
    let btnImg = UIImage(named: btnImgName)?.withRenderingMode(.alwaysOriginal)

    btn.setImage(btnImg, for: .normal)
    btn.addTarget(self,
                  action: #selector(editButtonTapped),
                  for: .touchUpInside)
    return btn
  }()
  
  lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .fill
    stackView.spacing = 10
    return stackView
  }()
  
  lazy var plusButton: UIButton = {
    let btn = UIButton()
    let btnImgName = String.selectImgMode("Plus", "Plus_dark")
    let btnImg = UIImage(named: btnImgName)?.withRenderingMode(.alwaysOriginal)

    btn.setImage(btnImg, for: .normal)
    btn.addTarget(self,
                  action: #selector(plusButtonTapped),
                  for: .touchUpInside)
    return btn
  }()
  
  lazy var minusButton: UIButton = {
    let btn = UIButton()
    let btnImgName = String.selectImgMode("Minus", "Minus_dark")
    let btnImg = UIImage(named: btnImgName)?.withRenderingMode(.alwaysOriginal)

    btn.setImage(btnImg, for: .normal)
    btn.addTarget(self,
                  action: #selector(minusButtonTapped),
                  for: .touchUpInside)
    return btn
  }()
  
  private let resultTableView: UITableView = {
    let tableView = UITableView()
    let tableViewColor = UIColor.selectColor(lightValue: .white,
                                             darkValue: .mainBlack)
    tableView.register(SavedCustomCell.self,
                       forCellReuseIdentifier: SavedCustomCell.cellId)
    
    if #available(iOS 15, *) {
      tableView.sectionHeaderTopPadding = 5
    }
    
    tableView.backgroundColor = tableViewColor
    tableView.separatorStyle = .singleLine
    tableView.separatorInset.left = 0
    return tableView
  }()
  
  lazy var allSelectButton: UIButton = {
    let btn = UIButton()
    
    if let image = UIImage(named: "emptycheck") {
      let resizedImage = image.withRenderingMode(.alwaysOriginal)
        .resized(to: CGSize(width: 20, height: 20))
      
      btn.setImage(resizedImage, for: .normal)
    }
    btn.addTarget(self,
                  action: #selector(allSelectBtnTapped),
                  for: .touchUpInside)
    return btn
  }()
  
  lazy var deleteButton: UIButton = {
    let btn = UIButton()
    
    let btnTitleColor = UIColor.selectColor(lightValue: .black,
                                                 darkValue: .white)
    btn.setTitle("삭제", for: .normal)
    btn.setTitleColor(btnTitleColor, for: .normal)
    
    let btnBackGroundColor = UIColor.selectColor(lightValue: .grey1,
                                                 darkValue: .grey4)
    btn.backgroundColor = btnBackGroundColor
    btn.layer.cornerRadius = 10
    btn.addTarget(self,
                  action: #selector(deleteButtonTapped),
                  for: .touchUpInside)
    return btn
  }()
  
  private let allSelectLabel: UILabel = {
    let label = UILabel()
    
    let labelColor = UIColor.selectColor(lightValue: .black,
                                         darkValue: .white)
    label.textColor = labelColor
    label.text = "전체선택"
    label.font = UIFont(name: "Pretendard", size: 16)

    return label
  }()

  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let mainBackGroundColor = UIColor.selectColor(lightValue: .white,
                                                 darkValue: UIColor.mainBlack)
    self.view.backgroundColor = mainBackGroundColor
    
    setSections()
    
    setupLayout()
    makeUI()
    
    navigationItemSetting()
    setNavigationbar()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  func setNavigationbar() {
    navigationItem.rightBarButtonItem = .none
  }
  
  func setSections(){
    sections = categoryManager.fetchCategories().map { $0.cellCategory ?? "기본" }
    
    if let defaultIndex = sections.firstIndex(of: "기본") {
      sections.remove(at: defaultIndex)
      sections.insert("기본", at: 0)
    }
  }
  
  // UI함수
  func setupLayout(){
    let countSections = categoryManager.fetchCategories().count
    if countSections == 0 {
      [
        mainTitle,
        mainImage,
        bottomTitle
      ].forEach {
        view.addSubview($0)
      }
    } else {
      [
        mainTitle,
        editButton,
        resultTableView
      ].forEach {
        view.addSubview($0)
      }
    }
  }
  
  func makeUI(){
    let countSections = categoryManager.fetchCategories().count
    
    resultTableView.dataSource = self
    resultTableView.delegate = self
    
    if countSections == 0 {
      mainTitle.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(10)
        make.bottom.equalTo(mainImage.snp.top).offset(30)
        make.centerX.equalToSuperview()
      }
      
      mainImage.snp.makeConstraints { make in
        make.centerX.equalToSuperview()
        make.centerY.equalToSuperview().offset(-100)
      }
      
      bottomTitle.snp.makeConstraints { make in
        make.top.equalTo(mainImage.snp.bottom).offset(50)
        make.centerX.equalToSuperview()
      }
    } else {
      mainTitle.snp.makeConstraints { make in
        make.centerX.equalToSuperview()
        make.top.equalToSuperview().offset(123)
      }
      editButton.snp.makeConstraints { make in
        make.trailing.equalToSuperview().offset(-10)
        make.top.equalTo(mainTitle.snp.bottom).offset(40)
      }
      resultTableView.snp.makeConstraints { make in
        make.top.equalTo(editButton.snp.bottom).offset(10)
        make.leading.trailing.bottom.equalToSuperview()
      }
    }
  }
  
  // MARK: - Edit 함수
  @objc private func editButtonTapped() {
    editButton.isHidden = true
    buttonStackView.isHidden = false

    view.setNeedsLayout()
    view.layoutIfNeeded()
    
    if editButton.isHidden {
      // 버튼 추가
      buttonStackView.addArrangedSubview(plusButton)
      buttonStackView.addArrangedSubview(minusButton)
      
      // 버튼이 슈퍼뷰에 추가된 후에 제약 조건 설정
      view.addSubview(buttonStackView)
      buttonStackView.snp.makeConstraints { make in
        make.trailing.equalToSuperview().offset(-10)
        make.top.equalTo(mainTitle.snp.bottom).offset(50)
      }
    }

  }
  
  @objc private func plusButtonTapped() {
    showCategoryInputAlert()
  }
  
  // MARK: - 카테고리 추가 함수
  func showCategoryInputAlert() {
    let alert = UIAlertController(title: "",
                                  message: "원하는 이름을 입력하세요",
                                  preferredStyle: .alert)

    alert.addTextField { $0.placeholder = "카테고리 이름" }
    
    let addAction = UIAlertAction(title: "추가",
                                  style: .default) { [weak self] action in
      guard let categoryName = alert.textFields?.first?.text,
            !categoryName.isEmpty else { return }
      
      
      // 중복 체크
      if self?.sections.contains(categoryName) == false {
        // 새로운 카테고리 추가
        self?.categoryManager.save(sectionName: categoryName)
        self?.sections.append(categoryName)
        self?.resultTableView.reloadData()
        
        let customPopupVC = CustomPopupViewController()
        
        customPopupVC.titleLabel.text = categoryName
        customPopupVC.descriptionLabel.text = "카테고리가 추가되었습니다."
        
        customPopupVC.modalPresentationStyle = .overFullScreen
        self?.present(customPopupVC, animated: false, completion: nil)
        
      }
    }
    
    let cancelAction = UIAlertAction(title: "취소",
                                     style: .cancel,
                                     handler: nil)
    let alertColor = UIColor.selectColor(lightValue: .black,
                                         darkValue: .white)
    
    addAction.setValue(alertColor, forKey: "titleTextColor")
    cancelAction.setValue(alertColor, forKey: "titleTextColor")

    alert.addAction(addAction)
    alert.addAction(cancelAction)
    
    if let alert = alert.view.subviews.first?.subviews.first?.subviews.first {
      let alertColor = UIColor.selectColor(lightValue: .white,
                                                   darkValue: .grey4)
      alert.backgroundColor = alertColor
    }
    present(alert, animated: true, completion: nil)
  }
  
  // MARK: - 카테고리 삭제 함수
  @objc func minusButtonTapped(){
    buttonStackView.isHidden = true
    deleteButton.isHidden = false
    allSelectButton.isHidden = false
    allSelectLabel.isHidden = false
    
    view.addSubview(allSelectButton)
    view.addSubview(allSelectLabel)
    view.addSubview(deleteButton)
    
    
    minusButtonVisible.toggle()
    resultTableView.reloadData()
    
    allSelectButton.snp.makeConstraints { make in
      make.leading.equalToSuperview().offset(10)
      make.top.equalTo(mainTitle.snp.bottom).offset(50)
    }
    
    allSelectLabel.snp.makeConstraints { make in
      make.leading.equalTo(allSelectButton.snp.trailing)
      make.centerY.equalTo(allSelectButton.snp.centerY)
    }
    
    deleteButton.snp.makeConstraints { make in
      make.trailing.equalToSuperview().offset(-10)
      make.bottom.equalTo(resultTableView.snp.top).offset(-10)
      make.width.equalTo(60)
    }
    
    let action: Selector = #selector(backButtonTapped)
    let buttonImage = UIImage(named: "Back")
    if let originalImage = buttonImage?.withRenderingMode(.alwaysOriginal) {
      navigationItem.rightBarButtonItem = UIBarButtonItem(
        image: originalImage,
        style: .plain,
        target: self,
        action: action
      )
    }
  }


  // MARK: - 카테고리 전체 선택
  @objc func allSelectBtnTapped() {
    checkButtonStatus.toggle()
    
    if let imageName = checkButtonStatus ? "checked" : "emptycheck",
       let image = UIImage(named: imageName) {
      let resizedImage = image.withRenderingMode(.alwaysOriginal)
        .resized(to: CGSize(width: 20, height: 20))
      allSelectButton.setImage(resizedImage, for: .normal)
      for button in checkButtons {
        button.setImage(resizedImage, for: .normal)
      }
    }

    
    if checkButtonStatus {
      deleteSections = sections.filter { $0 != "기본" }
    } else {
      deleteSections.removeAll()
    }
    
    let allSelected = deleteSections.count == sections.count - 1
    allSelectLabel.text = allSelected ? "선택해제" : "전체선택"
  }
  

  // 카테고리 삭제버튼
  @objc private func deleteButtonTapped() {
    for section in deleteSections {
      let usersInCategory = userManager.getUsersFromCoreData().filter {
        $0.category == section
      }

      if !usersInCategory.isEmpty {
        let alert = UIAlertController(title: "삭제",
                                      message: "카테고리에 속한 데이터를 전부 지우시겠습니까?",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "확인",
                                      style: .default,
                                      handler: { _ in
          self.categoryManager.deleteCategory(category: section)
          for user in usersInCategory {
            self.userManager.deleteUserFromCoreData(with: user) {
            }
          }
          if let index = self.sections.firstIndex(of: section) {
            self.sections.remove(at: index)
          }
          self.resultTableView.reloadData()
        }))
        
        alert.addAction(UIAlertAction(title: "취소",
                                      style: .cancel,
                                      handler: nil))
        
        present(alert, animated: true, completion: nil)
      } else {
        categoryManager.deleteCategory(category: section)
        if let index = sections.firstIndex(of: section) {
          sections.remove(at: index)
        }
        resultTableView.reloadData()
      }
    }
  }

  @objc func backButtonTapped(){
    deleteButton.isHidden = true
    allSelectButton.isHidden = true
    allSelectLabel.isHidden = true
    editButton.isHidden = false
    minusButtonVisible.toggle()
    
    reloadTableView()
    
    let image = UIImage(named: "emptycheck")
    let resizedImage = image?.withRenderingMode(.alwaysOriginal)
      .resized(to: CGSize(width: 20, height: 20))
    allSelectButton.setImage(resizedImage, for: .normal)
    
    navigationItem.rightBarButtonItem = .none
  }
  
  func reloadTableView(){
    self.resultTableView.reloadData()
  }
}

// MARK: - tableView 함수
extension LikeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let users = userManager.getUsersFromCoreData()
    let filteredUsers = users.filter { $0.category == sections[section] }
    return filteredUsers.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SavedCustomCell.cellId,
                                             for: indexPath) as! SavedCustomCell
    let user = userManager.getUsersFromCoreData().filter {
      $0.category == sections[indexPath.section] }[indexPath.row]
    let img = UIImage(named: "StarChecked")
    let cellColor = UIColor.selectColor(lightValue: .white,
                                        darkValue: .mainBlack)
    cell.name.text = user.name
    cell.email.text = user.email
    cell.college.text = user.college
    cell.phoneNum.text = user.phoneNumber
    cell.star.setImage(img, for: .normal)
  
    cell.user = user
    cell.backgroundColor = cellColor
    
    cell.saveButtonPressed = { [weak self] (senderCell) in
      guard let self = self else { return }
      self.makeRemoveCheckAlert { okAction in
        if okAction {
          let customPopupVC = CustomPopupViewController()
          
          customPopupVC.titleLabel.text = "\(user.name!) 님이"
          customPopupVC.descriptionLabel.text = "즐겨찾기목록에 삭제되었습니다."
          
          customPopupVC.modalPresentationStyle = .overFullScreen
          self.present(customPopupVC, animated: false, completion: nil)

          self.userManager.deleteUserFromCoreData(with: user) {
            self.resultTableView.reloadData()
          }
        }
      }
    }
    
    cell.selectionStyle = .none
    return cell
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
  
  // UITableViewDelegate 함수
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let category = sections[indexPath.section]
    let users = userManager.getUsersFromCoreData().filter { $0.category == category }
    
    if indexPath.row < users.count {
      let selectedUser = users[indexPath.row]
      
      let detailVC = DetailViewController()
      selectedUser.isSaved = true
      detailVC.userToCore = selectedUser
      detailVC.senderLikeVC = self
      
      self.navigationController?.pushViewController(detailVC, animated: true)
    }
  }
}

extension LikeViewController {
  // MARK: - Section
  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section]
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    let headerBackGroundColor = UIColor.selectColor(lightValue: .grey1,
                                                 darkValue: .grey4)
    headerView.backgroundColor = headerBackGroundColor
    
    let checkButton = UIButton(type: .custom)
    
    if let btnImage = UIImage(named: "emptycheck") {
        let resizedImage = btnImage.withRenderingMode(.alwaysOriginal)
            .resized(to: CGSize(width: 20, height: 20))

        checkButton.setImage(resizedImage, for: .normal)
    }
    
    checkButtons.append(checkButton)

    checkButton.addTarget(self,
                          action: #selector(checkButtonTapped(_:)),
                          for: .touchUpInside)
    
    let titleLabel = UILabel()
    titleLabel.text = sections[section]
    titleLabel.font = UIFont(name: "Pretendard", size: 18)
    titleLabel.textColor = UIColor.blue
    
    if minusButtonVisible == true && sections[section] != "기본" {
      mainTitle.text = "즐겨찾기편집"
      headerView.addSubview(checkButton)
      checkButton.snp.makeConstraints { make in
        make.leading.equalTo(headerView.snp.leading).offset(10)
        make.centerY.equalTo(headerView.snp.centerY)
      }

      headerView.addSubview(titleLabel)
      titleLabel.snp.makeConstraints { make in
        make.leading.equalTo(checkButton.snp.trailing).offset(10)
        make.centerY.equalTo(headerView.snp.centerY)
      }
    } else {
      mainTitle.text = "즐겨찾기목록"
      headerView.addSubview(titleLabel)
      titleLabel.snp.makeConstraints { make in
        make.leading.equalTo(headerView.snp.leading).offset(20)
        make.centerY.equalTo(headerView.snp.centerY)
      }
    }
    checkButton.isHidden = !minusButtonVisible
    
    return headerView
  }
  
  @objc func checkButtonTapped(_ sender: UIButton) {
    if let headerView = sender.superview,
       let minusButton = headerView.subviews.first(where: { $0 is UIButton }) as? UIButton,
       let titleLabel = headerView.subviews.first(where: { $0 is UILabel }) as? UILabel {
      
      checkButtonStatus.toggle()
      let imageName = checkButtonStatus ? "checked" : "emptycheck"
      if let image = UIImage(named: imageName) {
        let resizedImage = image.withRenderingMode(.alwaysOriginal)
          .resized(to: CGSize(width: 20, height: 20))
        
        minusButton.setImage(resizedImage, for: .normal)
      }
      
      if !checkButtonStatus {
        if let index = deleteSections.firstIndex(of: titleLabel.text!) {
          deleteSections.remove(at: index)
        }
      } else {
        if !deleteSections.contains(titleLabel.text!) {
          deleteSections.append(titleLabel.text ?? "기본")
        }
      }
      let allSelected = deleteSections.count == sections.count - 1
      allSelectLabel.text = allSelected ? "선택해제" : "전체선택"
    }
  }
}


