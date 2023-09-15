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
    label.text = "검색결과"
    label.font = UIFont(name: "Pretendard", size: 24)
    return label
  }()
  
  private let searchController: UISearchBar = {
    let bar = UISearchBar()
    bar.placeholder = "상세정보를 입력하세요"
    bar.tintColor = UIColor.grey2
    bar.searchTextField.font = UIFont(name: "Pretendard", size: 20)
    bar.barTintColor = UIColor.blueGrey
    
    if let searchBarTextField = bar.value(forKey: "searchField") as? UITextField {
      searchBarTextField.font = UIFont.systemFont(ofSize: 18)
      searchBarTextField.layer.cornerRadius = 25
      searchBarTextField.layer.masksToBounds = true
    }
    
    bar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)

    bar.showsBookmarkButton = true
    bar.setImage(UIImage(named: "Search"), for: .bookmark, state: .normal)
    bar.searchTextField.clearButtonMode = .never

    bar.backgroundImage = UIImage()
    
    bar.layer.shadowColor = UIColor.blueGrey.cgColor
    bar.layer.shadowOffset = CGSize(width: 1, height: 1) // 쉐도우의 오프셋 설정
    bar.layer.shadowOpacity = 0.25 // 쉐도우의 투명도 설정
    bar.layer.shadowRadius = 4 // 쉐도우의 반경 설정
        
    return bar
  }()
  
  lazy var resultTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.cellId)
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    
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
      make.width.equalTo(290)
      make.height.equalTo(45)
    }
    
    resultTableView.snp.makeConstraints { (make) in
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
    
    if userManager.getUsersFromCoreData().first(where: { $0.id == String(selectedItem.id) }) != nil {
      let detailVC = DetailViewController()
      detailVC.userData = [selectedItem]
      detailVC.makeStatus = true
      detailVC.resultVC = self
      self.navigationController?.pushViewController(detailVC, animated: true)
    } else {
      let detailVC = DetailViewController()
      detailVC.userData = [selectedItem]
      detailVC.resultVC = self
      self.navigationController?.pushViewController(detailVC, animated: true)
    }
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
  
  @objc private func didTapButton(senderCell: CustomCell) {
    let popupViewController = MyPopupViewController(title: "즐겨찾기",
                                                    desc: "즐겨찾기목록에 추가하시겠습니까?",
                                                    user: senderCell.user,
                                                    senderCell: senderCell)
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



