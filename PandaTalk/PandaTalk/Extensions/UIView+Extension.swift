//
//  UIView+Extension.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/10/07.
//

import UIKit

extension UIView {
  func addSubviews(views: [UIView]) {
    views.forEach { [unowned self] in
      self.addSubview($0)
    }
    
  }
}
