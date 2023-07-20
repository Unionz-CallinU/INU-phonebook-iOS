//
//  LikeViewController.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/07/14.
//

import UIKit

import SnapKit

final class LikeViewController: UIViewController {
  let user: [User] = [User(profile: UIImage(named: "INU1")!,
                           name: "강호식",
                           phoneNum: "010-1234-4568",
                           email: "abcde@abc.com",
                           star: UIImage(systemName: "star.fill")!)]
  
  private let resultTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.cellId)
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = .white
    self.title = "즐겨찾기"
    
    setupLayout()
    makeUI()
    
    resultTableView.delegate = self
    resultTableView.dataSource = self
  }
  
  func setupLayout(){
    [
      resultTableView
    ].forEach {
      view.addSubview($0)
    }
  }
  
  func makeUI(){
    resultTableView.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom) // bottom constraint 추가
    }
  }
  
}

extension LikeViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return user.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.cellId, for: indexPath) as! CustomCell
    
    cell.profile.image = user[indexPath.row].profile
    cell.name.text = user[indexPath.row].name
    cell.phoneNum.text = user[indexPath.row].phoneNum
    cell.email.text = user[indexPath.row].email
    cell.star.image = user[indexPath.row].star
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}

