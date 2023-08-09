//
//  ResultViewController.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/02.
//

import UIKit

import SnapKit

final class ResultViewController: NaviHelper, UISearchBarDelegate {
  
  var searchText: String?
  let userManager = UserManager.shared
  
  var searchKeyword: String?
  var users: [User] = []
  
  private let mainTitle: UILabel = {
    let label = UILabel()
    label.text = "검색결과"
    label.font = UIFont.systemFont(ofSize: 24)
    return label
  }()
  
  private let searchController: UISearchBar = {
    let bar = UISearchBar()
    bar.placeholder = "상세정보를 입력하세요"
    bar.backgroundImage = UIImage()   // 빈 이미지를 넣어서 주변 사각형 제거
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
      make.centerY.equalToSuperview().offset(-200)
      make.width.equalToSuperview().multipliedBy(0.9)
      make.height.equalTo(60)
    }
    
    resultTableView.snp.makeConstraints { (make) in
      make.top.equalTo(searchController.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
  }
}

extension ResultViewController: UITableViewDelegate, UITableViewDataSource {
  // UITableViewDataSource 함수
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.userManager.getUsersFromAPI().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = resultTableView.dequeueReusableCell(withIdentifier: CustomCell.cellId,
                                             for: indexPath) as! CustomCell
    
    let user = userManager.getUsersFromAPI()[indexPath.row]
    cell.user = user
    
    // (델리게이트 말고) 클로저 방식을 활용하는 것도 가능 ⭐️⭐️
    cell.saveButtonPressed = { [weak self] (senderCell, isSaved) in
        guard let self = self else { return }
        // 저장이 안되어 있던 것이면
        if !isSaved {
            // 저장하려는 알럿메세지 띄우기
            self.makeMessegeAlert { text, savedAction in
                // 저장함(확인) 선택하면
                if savedAction {
                  self.userManager.saveUserData(with: user, message: text) {
                        // 저장여부 설정 및 버튼 스타일 바꾸기(셀이 음악 가지고 있음)
                    senderCell.user?.isSaved = true
                        // 저장 여부 바뀌었으니, 버튼 재설정
                        senderCell.setButtonStatus()
                        print("저장됨")
                    }
                } else {
                    print("취소됨")
                }
            }
        // 이미 저장이 되어 있던 것이면
        } else {
            // 정말 지울 것인지를 묻는 알럿메세지 띄우기
          self.makeRemoveCheckAlert { removeAction in
              if removeAction {
                self.userManager.deleteUserFromCoreData(with: user) {
                  senderCell.user?.isSaved = false
                      // 저장 여부 바뀌었으니, 버튼 재설정
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
    let selectedItem = users[indexPath.row]
    let detailVC = DetailViewController() // 새로운 디테일 뷰컨트롤러를 생성합니다.
    //    detailVC.selectedItem = selectedItem // 선택된 아이템 데이터를 전달합니다.
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
  func makeRemoveCheckAlert(completion: @escaping (Bool) -> Void) {
      let alert = UIAlertController(title: "저장 음악 삭제", message: "정말 저장된 음악을 지우시겠습니까?", preferredStyle: .alert)
      let ok = UIAlertAction(title: "확인", style: .default) { okAction in
          completion(true)
      }
      let cancel = UIAlertAction(title: "취소", style: .cancel) { cancelAction in
          completion(false)
      }
      alert.addAction(ok)
      alert.addAction(cancel)
      self.present(alert, animated: true, completion: nil)
  }
  
  func makeMessegeAlert(completion: @escaping (String?, Bool) -> Void) {
      let alert = UIAlertController(title: "음악 관련 메세지", message: "음악과 함께 저장하려는 문장을 입력하세요.", preferredStyle: .alert)
      alert.addTextField { textField in
          textField.placeholder = "저장하려는 메세지"
      }
      var savedText: String? = ""
      let ok = UIAlertAction(title: "확인", style: .default) { okAction in
          savedText = alert.textFields?[0].text
          completion(savedText, true)
      }
      let cancel = UIAlertAction(title: "취소", style: .cancel) { cancelAction in
          completion(nil, false)
      }
      alert.addAction(ok)
      alert.addAction(cancel)
      self.present(alert, animated: true, completion: nil)
  }
}



