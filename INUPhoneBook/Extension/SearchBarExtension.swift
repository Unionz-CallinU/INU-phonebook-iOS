//
//  SearchBarExtension.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/09/18.
//

import UIKit

extension UISearchBar {
  static func createSearchBar() -> UISearchBar {
    let bar = UISearchBar()
    let barTextColor = UIColor.selectColor(lightValue: .grey2, darkValue: .grey0)
    bar.placeholder = "상세정보를 입력하세요"
    bar.tintColor = UIColor.grey2
    bar.searchTextField.font = UIFont(name: "Pretendard", size: 20)
    
    let searchBarColor = UIColor.selectColor(lightValue: .blueGrey, darkValue: .grey3)
    if let searchBarTextField = bar.value(forKey: "searchField") as? UITextField {
      searchBarTextField.font = UIFont.systemFont(ofSize: 18)
      searchBarTextField.layer.cornerRadius = 25
      searchBarTextField.layer.masksToBounds = true
      searchBarTextField.backgroundColor = searchBarColor
    }
    
    let searchImgName = String.selectImgMode("Search", "Search_dark")
    let searchImg = UIImage(named: searchImgName)?.withRenderingMode(.alwaysOriginal)
    
    bar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
    
    bar.showsBookmarkButton = true
    bar.setImage(searchImg, for: .bookmark, state: .normal)
    bar.searchTextField.clearButtonMode = .never
    
    bar.backgroundImage = UIImage()
    
    bar.layer.shadowColor = UIColor.blueGrey.cgColor
    bar.layer.shadowOffset = CGSize(width: 1, height: 1)
    bar.layer.shadowOpacity = 0.25
    bar.layer.shadowRadius = 4
    
    return bar
  }
  
}
