//
//  ViewController.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/07/14.
//
import AVFoundation
import UIKit

import SnapKit
import AVKit

final class MainViewController: NaviHelper, UISearchBarDelegate {
  
  private var filteredData: [User] = []  // 필터링된 결과를 저장할 배열
  
  let user: [User] = [User(employeeNum: "1",
                           college: "인문대학",
                           department: "교수",
                           name: "김호식",
                           position: "교수",
                           role: "교수",
                           phonNum:"010-1111-1111",
                           email: "email@naver.com",
                           image: UIImage(named: "INU1")!, isSaved: false)]
  
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
    
    searchController.delegate = self
    navigationItemSetting()
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
  
  // MARK: - UISearchBarDelegate
  @objc func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    guard let keyword = searchBar.text else { return }
    let searchResultController = ResultViewController()
    searchResultController.searchKeyword = keyword
    
    let users = user.filter { $0.name == keyword }
    searchResultController.users = users
    
    navigationController?.pushViewController(searchResultController, animated: true)
  }

  
}
