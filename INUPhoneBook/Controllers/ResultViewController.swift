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
    label.font = UIFont.systemFont(ofSize: 24)
    return label
  }()
  
  private let searchController: UISearchBar = {
    let bar = UISearchBar()
    bar.placeholder = "상세정보를 입력하세요"
    bar.backgroundImage = UIImage()
    return bar
  }()
  
  private let resultTableView: UITableView = {
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
      make.bottom.equalTo(searchController.snp.top).offset(-20)
    }
    
    searchController.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
      make.width.equalToSuperview().multipliedBy(0.9)
      make.height.equalTo(60)
    }
    
    resultTableView.snp.makeConstraints { (make) in
      make.top.equalTo(searchController.snp.bottom).offset(70)
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
    
    let user = userManager.getUsersFromAPI()[indexPath.row]
    let starImage = user.isSaved == true ? UIImage(named: "StarChecked") : UIImage(named: "Star")
    
    cell.name.text = user.name
    cell.email.text = user.email
    cell.college.text = user.college
    cell.phoneNum.text = user.phoneNumber
    cell.profile.image = UIImage(named: "INU1")!
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
              print("저장된 것 삭제")
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
    let detailVC = DetailViewController()
    detailVC.userData = [selectedItem] // 선택된 아이템 데이터를 전달합니다.
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
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

// MARK: - pickerview 함수
extension ResultViewController {
  
  @objc func showCategoryList(sender: UIButton) {
    let dropDown = DropDown()
    dropDown.anchorView = sender
    dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
    dropDown.dataSource = ["카테고리1", "카테고리2", "카테고리3", "카테고리3"]
    dropDown.selectionAction = { [weak self] (index, item) in
      // DropDown의 항목 선택 시의 동작을 구현합니다.
      guard let self = self else { return }
      // 선택된 항목(item)을 사용하여 원하는 동작을 수행합니다.
      print("선택된 카테고리: \(item)")
    }
    dropDown.show()
  }

}

