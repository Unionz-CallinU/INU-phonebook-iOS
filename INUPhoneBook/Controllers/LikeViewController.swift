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
  
  private let sections: [String] = ["기본"]
  
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

  private let editButton: UIButton = {
      let btn = UIButton()
      let img = UIImage(named: "Edit")
      btn.setImage(img, for: .normal)
      return btn
  }()

  private let resultTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(SavedCustomCell.self,
                       forCellReuseIdentifier: SavedCustomCell.cellId)
    
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    
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
  
  func setupLayout(){
    if userManager.getUsersFromCoreData().count == 0 {
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
    resultTableView.dataSource = self
    resultTableView.delegate = self
    
    if userManager.getUsersFromCoreData().count == 0 {
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
        make.top.equalToSuperview().offset(100)
      }
      editButton.snp.makeConstraints { make in
        make.trailing.equalToSuperview().offset(-10)
        make.top.equalTo(mainTitle.snp.bottom).offset(50)
      }
      resultTableView.snp.makeConstraints { make in
        make.top.equalTo(editButton.snp.bottom)
        make.leading.trailing.bottom.equalToSuperview()
      }
    }
  }
}

extension LikeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userManager.getUsersFromCoreData().count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SavedCustomCell.cellId,
                                             for: indexPath) as! SavedCustomCell
    
    let userTest = userManager.getUsersFromCoreData()[indexPath.row]
    let img = UIImage(named: "StarChecked")
    
    cell.name.text = userTest.name
    cell.email.text = userTest.email
    cell.college.text = userTest.college
    cell.phoneNum.text = userTest.phoneNumber
    cell.profile.image = UIImage(named: "INU1")!
    cell.star.setImage(img, for: .normal)
    
    cell.user = userTest
    
    cell.saveButtonPressed = { [weak self] (senderCell) in
      guard let self = self else { return }
      self.makeRemoveCheckAlert { okAction in
        if okAction {
          self.userManager.deleteUserFromCoreData(with: userTest) {
            self.resultTableView.reloadData()
            print("삭제 및 테이블뷰 리로드 완료")
          }
        } else {
          print("삭제 취소")
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
  
  // UITableViewDelegate 함수
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedUser = userManager.getUsersFromCoreData()[indexPath.row]
    let detailVC = DetailViewController()
    
    detailVC.userToCore = selectedUser
    self.navigationController?.pushViewController(detailVC, animated: true)
    
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
    let headerView = UILabel()
    headerView.text = sections[section]
    headerView.backgroundColor = UIColor(red: 0.91,
                                         green: 0.91,
                                         blue: 0.91,
                                         alpha: 1.00)
    headerView.font = UIFont.boldSystemFont(ofSize: 16)
    headerView.textAlignment = .center
    headerView.textColor = .blue
    
    let style = NSMutableParagraphStyle()
    style.headIndent = 20
    style.firstLineHeadIndent = 20
    
    let attributes = [NSAttributedString.Key.paragraphStyle: style]
    let attributedString = NSAttributedString(string: headerView.text ?? "",
                                              attributes: attributes)
    headerView.attributedText = attributedString
    
    return headerView
  }
  
  
}
