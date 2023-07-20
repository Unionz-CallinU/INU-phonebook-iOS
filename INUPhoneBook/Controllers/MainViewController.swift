//
//  ViewController.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/07/14.
//
import UIKit

import SnapKit

final class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  private var filteredData: [User] = []  // 필터링된 결과를 저장할 배열
  
  let user: [User] = [User(profile: UIImage(named: "INU1")!,
                           name: "강호식",
                           phoneNum: "010-1234-4568",
                           email: "abcde@abc.com", star: UIImage(systemName: "star.fill")!),
                      
                      User(profile: UIImage(named: "INU2")!,
                           name: "김철수",
                           phoneNum:"010-9874-6542",
                           email:"bbc@bbc.com", star: UIImage(systemName: "star.fill")!),
                      
                      User(profile: UIImage(named: "INU3")!,
                           name: "김호식",
                           phoneNum:"010-1874-2542",
                           email:"bbq@bbc.com", star: UIImage(systemName: "star.fill")!)
  ]
  // MARK: - 화면구성
  private let titleImage: UIImageView = {
    let img = UIImageView()
    img.image = UIImage(named: "INU2")
    return img
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "INU 전화번호부"
    label.font = UIFont.systemFont(ofSize: 44, weight: .bold)
    return label
    
  }()
  private let searchController: UISearchBar = {
    let bar = UISearchBar()
    bar.placeholder = "입력"
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
    
    navigationItemSetting()
    searchController.delegate = self
    resultTableView.delegate = self
    resultTableView.dataSource = self
  }
  
  // MARK: - view 계층 구성
  func setupLayout(){
    [
      titleLabel,
      searchController,
      resultTableView,
      titleImage
    ].forEach {
      view.addSubview($0)
    }
  }
  // MARK: - UI세팅
  func makeUI() {
    titleImage.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.bottom.equalTo(titleLabel.snp.top)
    }
    titleLabel.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.7)
      make.top.equalTo(searchController.snp.top).offset(-70)
    }
    
    searchController.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview().offset(-50)
      make.width.equalToSuperview().multipliedBy(0.9)
      make.height.equalTo(60)
    }
    
    resultTableView.snp.makeConstraints { (make) in
      make.top.equalTo(searchController.snp.bottom)
      make.left.right.bottom.equalToSuperview()
    }
  }
  
  // MARK: - navi 설정
  func navigationItemSetting() {
    let leftButton = UIBarButtonItem(image: UIImage(systemName: "homekit"),
                                     style: .plain,
                                     target: self,
                                     action: #selector(homeButtonTapped(_:)))
    
    let rightButton = UIBarButtonItem(image: UIImage(systemName: "star.fill"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(likeButtonTapped(_:)))
    
    self.navigationItem.rightBarButtonItem = rightButton
    self.navigationItem.leftBarButtonItem = leftButton
  }
  
  @objc func homeButtonTapped(_ sender: UIBarButtonItem) {
    let mainView = MainViewController()
    self.navigationController?.pushViewController(mainView, animated: true)
  }
  
  @objc func likeButtonTapped(_ sender: UIBarButtonItem) {
    let likeView = LikeViewController()
    self.navigationController?.pushViewController(likeView, animated: true)
  }
  
}

extension MainViewController: UISearchBarDelegate {
  // UISearchBarDelegate 함수
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filteredData = user.filter {
      let targetText = $0.name.lowercased()
      let matchText = searchText.lowercased()
      return targetText.contains(matchText)
    }
    // 테이블 뷰를 갱신합니다.
    resultTableView.reloadData()
  }
  
  // UITableViewDataSource 함수
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.cellId, for: indexPath) as! CustomCell
    
    cell.profile.image = filteredData[indexPath.row].profile
    cell.name.text = filteredData[indexPath.row].name
    cell.phoneNum.text = filteredData[indexPath.row].phoneNum
    cell.email.text = filteredData[indexPath.row].email
    cell.star.image = filteredData[indexPath.row].star
    
    
    return cell
  }
  // UITableViewDelegate 함수 (선택)
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedItem = filteredData[indexPath.row]
    let detailVC = DetailViewController() // 새로운 디테일 뷰컨트롤러를 생성합니다.
//    detailVC.selectedItem = selectedItem // 선택된 아이템 데이터를 전달합니다.
    self.navigationController?.pushViewController(detailVC, animated: true)
  } 
}
