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
  
  private let searchController = UISearchBar.createSearchBar()
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    let mainBackGroundColor = UIColor.selectColor(lightValue: .white,
                                                  darkValue: UIColor.mainBlack)
    self.view.backgroundColor = mainBackGroundColor
    
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

    searchBar.isUserInteractionEnabled = false

    // 검색 중 표시를 위한 UIActivityIndicatorView 추가
    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.startAnimating()
    searchBar.addSubview(activityIndicator)
    activityIndicator.center = CGPoint(x: searchBar.bounds.size.width / 2,
                                       y: searchBar.bounds.size.height / 2)
    
    let searchResultController = ResultViewController(searchKeyword: keyword)
    
    userManager.fetchUsersFromAPI(with: keyword) { [self] in
      let countCell = userManager.getUsersFromAPI().count
      DispatchQueue.main.async {
        // 검색 완료 시 UIActivityIndicatorView 숨기기
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        
        searchBar.isUserInteractionEnabled = true
        
        if countCell > 0 {
          self.navigationController?.pushViewController(searchResultController, animated: true)
        } else {
          let alertController = UIAlertController(title: "검색 결과 없음",
                                                  message: "다시 확인하고 입력해주세요.",
                                                  preferredStyle: .alert)
          let okAction = UIAlertAction(title: "확인",
                                       style: .default,
                                       handler: nil)
          
          let alertColor = UIColor.selectColor(lightValue: .black,
                                               darkValue: .white)
          
          okAction.setValue(alertColor, forKey: "titleTextColor")
          
          alertController.addAction(okAction)
          self.present(alertController, animated: true, completion: nil)
        }
      }
    }
  }
  
  
}

