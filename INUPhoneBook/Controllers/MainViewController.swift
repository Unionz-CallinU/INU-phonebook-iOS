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
    bar.tintColor = UIColor.grey2
    bar.barTintColor = UIColor.blueGrey
    
    if let searchBarTextField = bar.value(forKey: "searchField") as? UITextField {
      searchBarTextField.font = UIFont.systemFont(ofSize: 18)
      searchBarTextField.layer.cornerRadius = 25
      searchBarTextField.layer.masksToBounds = true
    }
    bar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)

    bar.showsBookmarkButton = true
    bar.setImage(UIImage(named: "Search"), for: .bookmark, state: .normal)
    
    bar.backgroundImage = UIImage()
    
    return bar
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
      make.bottom.equalTo(searchController.snp.top).offset(-40)
    }
    
    searchController.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(358)
      make.width.equalToSuperview().multipliedBy(0.8)
    }
  }
}

extension MainViewController: UISearchBarDelegate {
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

