//
//  UIColorExtension.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/09/14.
//

import UIKit

extension UIColor {
  static let blue = UIColor(red: 0.00, green: 0.37, blue: 0.93, alpha: 1.00)
  static let skyBlue = UIColor(red: 0.67, green: 0.82, blue: 1.00, alpha: 1.00)
  static let blueGrey = UIColor(red: 0.93, green: 0.94, blue: 0.95, alpha: 1.00)
  static let yello = UIColor(red: 1.00, green: 0.72, blue: 0.00, alpha: 1.00)
  static let grey0 = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
  static let grey1 = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1.00)
  static let grey2 = UIColor(red: 0.63, green: 0.63, blue: 0.63, alpha: 1.00)
  static let grey3 = UIColor(red: 0.40, green: 0.40, blue: 0.40, alpha: 1.00)
  static let grey4 = UIColor(red: 0.19, green: 0.19, blue: 0.19, alpha: 1.00)

  static let mainBlack = UIColor(red: 0.14, green: 0.14, blue: 0.14, alpha: 1.00)
  
  func asImage(_ width: CGFloat = UIScreen.main.bounds.width, _ height: CGFloat = 1.0) -> UIImage {
    let size: CGSize = CGSize(width: width, height: height)
    let image: UIImage = UIGraphicsImageRenderer(size: size).image { context in
      setFill()
      context.fill(CGRect(origin: .zero, size: size))
    }
    return image
  }
}

// MARK: - 다크모드 관련 함수
extension UIColor {
  static func selectColor(lightValue: UIColor, darkValue: UIColor) -> UIColor {
    if #available(iOS 13, *) {
      return UIColor { traitCollection in
        return traitCollection.userInterfaceStyle == .light ? lightValue : darkValue
      }
    } else {
      return lightValue
    }
  }
}
