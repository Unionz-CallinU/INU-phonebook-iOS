//
//  StringExtension.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/22.
//

import UIKit

extension String {
  // MARK: - 휴대폰 번호 하이픈 추가
  public var withHypen: String {
    var stringWithHypen: String = self
    
    if stringWithHypen.count >= 7 && !stringWithHypen.contains("-") {
      stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
      stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.endIndex, offsetBy: -4))
    }
    
    return stringWithHypen
  }  
}

extension String {
  static func selectImgMode(_ lightValue: String, _ darkValue: String) -> String {
    if #available(iOS 13.0, *) {
      if UITraitCollection.current.userInterfaceStyle == .light {
        return lightValue
      } else {
        return darkValue
        
      }
    } else {
      // iOS 13 이하에서는 기본값 반환
      return lightValue
    }
  }
}
