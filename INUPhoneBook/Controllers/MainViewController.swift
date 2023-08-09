//
//  ViewController.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/07/14.
//
import UIKit

import SnapKit

final class MainViewController: NaviHelper, UITableViewDelegate {
  let userManager = UserManager.shared
  
  // MARK: - 화면구성
  private let titleImage: UIImageView = {
    let img = UIImageView()
    img.image = UIImage(named: "mainimage")
    return img
  }()
  
  private let searchController: UISearchBar = {
    let bar = UISearchBar()
    bar.placeholder = "상세정보를 입력하세요"
    bar.backgroundImage = UIImage()   // 빈 이미지를 넣어서 주변 사각형 제거
    bar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
    bar.setImage(UIImage(named: "icCancel"), for: .search, state: .normal)
    bar.layer.cornerRadius = 30
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
    
    resultTableView.delegate = self
    resultTableView.dataSource = self
    resultTableView.register(UINib(nibName: CustomCell.cellId, bundle: nil), forCellReuseIdentifier: CustomCell.cellId)

    searchController.delegate = self
    navigationItemSetting()
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    resultTableView.reloadData()
  }
  
  // MARK: - view 계층 구성
  func setupLayout(){
    [
      searchController,
      titleImage
    ].forEach {
      view.addSubview($0)
    }
  }
  // MARK: - UI세팅
  func makeUI() {
    titleImage.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(searchController.snp.top).offset(-20)
    }
    
    searchController.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-50)
      make.width.equalToSuperview().multipliedBy(0.8)
      make.height.equalTo(60)
    }
  }
  
}

extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.userManager.getUsersFromAPI().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = resultTableView.dequeueReusableCell(withIdentifier: CustomCell.cellId,
                                                   for: indexPath) as! CustomCell
    
    // 모델에서 받아온 데이터 전달
    let userData = userManager.getUsersFromAPI()[indexPath.row]
    cell.user = userData
    // (델리게이트 말고) 클로저 방식을 활용하는 것도 가능 ⭐️⭐️
    cell.saveButtonPressed = { [weak self] (senderCell, isSaved) in
      guard let self = self else { return }
      // 저장이 안되어 있던 것이면
      if !isSaved {
        // 저장하려는 알럿메세지 띄우기
        self.makeMessegeAlert { text, savedAction in
          // 저장함(확인) 선택하면
          if savedAction {
            self.userManager.saveUserData(with: userData, message: text) {
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
            self.userManager.deleteUserFromCoreData(with: userData) {
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
}

//extension MainViewController: UITableViewDelegate {
//  // 테이블뷰 셀의 높이를 유동적으로 조절하고 싶다면 구현할 수 있는 메서드
//  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//    return 120
//  }
//
//  // 유저가 스크롤하는 것이 끝나려는 시점에 호출되는 메서드
//  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//    UIView.animate(withDuration: 0.3) {
//      guard velocity.y != 0 else { return }
//      if velocity.y < 0 {
//        let height = self.tabBarController?.tabBar.frame.height ?? 0.0
//        self.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY - height)
//      } else {
//        self.tabBarController?.tabBar.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.maxY)
//      }
//    }
//  }
//}

extension MainViewController: UISearchBarDelegate {
  // 검색(Search) 버튼을 눌렀을때 호출되는 메서드
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let text = searchController.text?.lowercased() else {
      return
    }
    print(text)
    userManager.fetchUsersFromAPI(with: text) {
      DispatchQueue.main.async {
        self.resultTableView.reloadData()
      }
    }
  }
  
  // 서치바에서 글자가 바뀔때마다 가져다가 소문자로 변환하기 (대문자 입력 막기)
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      searchBar.text = searchText.lowercased()
  }
}
