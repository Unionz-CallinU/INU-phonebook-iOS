//
//  ResultViewController.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/02.
//

import UIKit

import DropDown
import SnapKit

final class ResultViewController: NaviHelper {
  
  let userManager = UserManager.shared
  var searchKeyword: String?
  var starStatus: Bool?
  
  init(searchKeyword: String) {
    self.searchKeyword = searchKeyword
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private let mainTitle: UILabel = {
    let label = UILabel()
    let labelColor = UIColor.selectColor(lightValue: .black,
                                         darkValue: .grey0)
    label.text = "검색결과"
    label.font = UIFont(name: "Pretendard", size: 24)
    label.textColor = labelColor
    return label
  }()
  
  private let searchController = UISearchBar.createSearchBar()
  
  lazy var resultTableView: UITableView = {
    let tableView = UITableView()
    let tableViewBackGroundColor = UIColor.selectColor(lightValue: .white,
                                                       darkValue: UIColor.mainBlack)
    tableView.register(CustomCell.self,
                       forCellReuseIdentifier: CustomCell.cellId)
    tableView.backgroundColor = tableViewBackGroundColor
    tableView.separatorInset.left = 0
    return tableView
  }()
  
  lazy var tableViewLine: UIView = {
    let line = UIView()
    line.backgroundColor = UIColor.grey2
    return line
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let mainBackGroundColor = UIColor.selectColor(lightValue: .white,
                                                  darkValue: UIColor.mainBlack)
    self.view.backgroundColor = mainBackGroundColor
    
    setupLayout()
    makeUI()
    
    searchController.delegate = self
    navigationItemSetting()
    
    resultTableView.delegate = self
    resultTableView.dataSource = self
  }
  
  // MARK: - view 계층 구성
  func setupLayout(){
    [
      searchController,
      resultTableView,
      mainTitle
    ].forEach {
      view.addSubview($0)
    }
  }
  // MARK: - UI세팅
  func makeUI() {
    mainTitle.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(119.72)
    }
    
    searchController.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(mainTitle).offset(60)
      make.width.equalToSuperview().multipliedBy(0.8)
      make.height.equalTo(45)
    }
    
    resultTableView.snp.makeConstraints { make in
      make.top.equalTo(searchController.snp.bottom).offset(60)
      make.left.right.bottom.equalToSuperview()
    }
  }
}

// MARK: - cell 함수
extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
  // UITableViewDataSource 함수
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.userManager.getUsersFromAPI().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = resultTableView.dequeueReusableCell(withIdentifier: CustomCell.cellId,
                                                   for: indexPath) as! CustomCell
    var user = userManager.getUsersFromAPI()[indexPath.row]
    var isSaved = false
    let cellBackGroundColor = UIColor.selectColor(lightValue: .white,
                                                  darkValue: UIColor.mainBlack)
    cell.backgroundColor = cellBackGroundColor
    userManager.getUsersFromCoreData().forEach { userToCore in
      if userToCore.id == String(user.id) { isSaved = true}
    }
    user.isSaved = isSaved
    
    let starImage = user.isSaved! ? UIImage(named: "StarChecked") : UIImage(named: "GreyStar")
    cell.name.text = user.name
    cell.email.text = user.email
    cell.college.text = user.college
    cell.phoneNum.text = user.phoneNumber
    cell.star.setImage(starImage, for: .normal)
    
    cell.user = user
    
    cell.saveButtonPressed = { [weak self] (senderCell, isSaved) in
      guard let self = self else { return }
      if !isSaved {
        self.didTapButton(senderCell: cell)
      } else {
        self.makeRemoveCheckAlert { removeAction in
          if removeAction {
            self.userManager.deleteUser(with: user) {
              senderCell.user?.isSaved = false
              senderCell.setButtonStatus()
              
              let customPopupVC = CustomPopupViewController()
              
              customPopupVC.titleLabel.text = (senderCell.user?.name)! + "님이"
              customPopupVC.descriptionLabel.text = "즐겨찾기목록에 삭제되었습니다."
              
              customPopupVC.modalPresentationStyle = .overFullScreen
              self.present(customPopupVC, animated: false, completion: nil)
            }
          } else {
            print("저장된 것 삭제하기 취소됨")
          }
        }
      }
    }
    
    cell.selectionStyle = .none
    return cell
  }
  
  // UITableViewDelegate 함수 (선택)
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedItem = userManager.getUsersFromAPI()[indexPath.row]
    let test = userManager.getUsersFromCoreData().first(where: { $0.id == String(selectedItem.id) })
    let detailVC = DetailViewController()
    
    if userManager.getUsersFromCoreData().first(where: { $0.id == String(selectedItem.id) }) != nil {
      detailVC.userToCore = test
      detailVC.makeStatus = true
    } else {
      detailVC.userData = [selectedItem]
    }
    
    detailVC.resultVC = self
    self.navigationController?.pushViewController(detailVC, animated: true)
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func reloadTalbeView(){
    resultTableView.reloadData()
  }
}

// MARK: - Alert 함수
extension ResultViewController {
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
  
  @objc private func didTapButton(senderCell: CustomCell) {
    let popupViewController = MyPopupViewController(title: "즐겨찾기",
                                                    desc: "즐겨찾기목록에 추가하시겠습니까?",
                                                    user: senderCell.user,
                                                    senderCell: senderCell)
    
    popupViewController.saveAction = { [weak self] user, senderCell in
      let customPopupVC = CustomPopupViewController()
      
      let userName = senderCell.user?.name ?? ""
      let nameAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont(name: "Pretendard", size: 24) as Any
      ]
      
      let attributedName = NSAttributedString(string: userName, attributes: nameAttributes)
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
      
      self?.present(customPopupVC, animated: false, completion: nil)
    }
    
    popupViewController.modalPresentationStyle = .overFullScreen
    self.present(popupViewController, animated: false)
  }
}

// MARK: - 서치바 함수
extension ResultViewController: UISearchBarDelegate {
  // 검색(Search) 버튼을 눌렀을때 호출되는 메서드
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let keyword = searchBar.text else { return }
    let searchResultController = ResultViewController(searchKeyword: keyword)
    
    userManager.fetchUsersFromAPI(with: keyword) { [self] in
      DispatchQueue.main.async { [self] in
        navigationController?.pushViewController(searchResultController, animated: true)
      }
    }
  }
}



