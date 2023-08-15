//
//  LikeViewController.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/07/14.
//

import UIKit

import SnapKit

final class LikeViewController: NaviHelper, UITableViewDelegate {
  
  let userManager = UserManager.shared
  
  private let mainTitle: UILabel = {
    let label = UILabel()
    label.text = "즐겨찾기목록"
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
  
  private let resultTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CustomCell.self,
                       forCellReuseIdentifier: CustomCell.cellId)
    
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    
    setupLayout()
    makeUI()
    
    navigationItemSetting()
 
    self.navigationItem.rightBarButtonItem = .none
  }
  
  func setupLayout(){
    [
      mainTitle,
      resultTableView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  func makeUI(){
    resultTableView.dataSource = self
    resultTableView.delegate = self
    
    mainTitle.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(100)
    }
    
    resultTableView.snp.makeConstraints { make in
      make.top.equalTo(mainTitle.snp.bottom).offset(20)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }
}

extension LikeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userManager.getUsersFromCoreData().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.cellId,
                                             for: indexPath) as! CustomCell
    
    // 코어데이터에서 가져오는걸로 수정해야함
    let userTest = userManager.getUsersFromCoreData()[indexPath.row]
    let img = UIImage(named: "StarChecked")

    cell.name.text = userTest.name
    cell.email.text = userTest.email
    cell.college.text = userTest.college
    cell.phoneNum.text = userTest.phoneNumber
    cell.profile.image = UIImage(named: "INU1")!
    cell.star.setImage(img, for: .normal)
    
    cell.saveButtonPressed = { [weak self] (senderCell, isSaved) in
      guard let self = self else { return }
      
      if isSaved {
        self.makeRemoveCheckAlert { removeAction in
          if removeAction {
            self.userManager.deleteUserFromCoreData(with: userTest) {
              senderCell.user?.isSaved = false
              senderCell.setButtonStatus()
              tableView.reloadData()
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
  
  // UITableViewDelegate 함수 ,코어데이터로 변경해야함, 검색을 아무것도 안하고 디테일로 넘어가면 에러
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedItem = userManager.getUsersFromAPI()[indexPath.row]
    let detailVC = DetailViewController()
    detailVC.userData = [selectedItem] // 선택된 아이템 데이터를 전달합니다.
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
}
