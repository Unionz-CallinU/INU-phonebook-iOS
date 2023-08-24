//
//  UIViewControllerExtension.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/24.
//

import UIKit
import DropDown

extension UIViewController {
  @objc func showCategoryList(sender: UIButton) {
    let categories = CategoryManager.shared.fetchCategories()
    var categoryNames: [String] = []
    var user: User?

    for category in categories {
      if let categoryName = category.cellCategory{ // categoryName에 옵셔널 값이 들어있는 경우
        categoryNames.append(categoryName) // 옵셔널 값을 제거한 후 배열에 추가합니다.
      }
    }
    
    let dropDown = DropDown()
    dropDown.anchorView = sender
    dropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height)
    dropDown.dataSource = categoryNames
    dropDown.selectionAction = { [weak self] (index, item) in
      // DropDown의 항목 선택 시의 동작을 구현합니다.
      guard let self = self else { return }
      // 선택된 항목(item)을 사용하여 원하는 동작을 수행합니다.
      self.user?.category = item
      print("선택된 카테고리: \(self.user?.category)")
    }
    dropDown.show()
  }
}
