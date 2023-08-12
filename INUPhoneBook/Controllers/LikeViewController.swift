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
  
  private let tableView: UITableView = {
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
      tableView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  func makeUI(){
    tableView.dataSource = self
    tableView.delegate = self
    
    mainTitle.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(100)
    }
    
    tableView.snp.makeConstraints { make in
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
    
    let user = userManager.getUsersFromCoreData()[indexPath.row]
    cell.name.text = user.name
    cell.email.text = user.email
    cell.college.text = user.college
    cell.phoneNum.text = user.phoneNumber
    cell.profile.image = UIImage(named: "INU1")!
    
    return cell
  }
}
