//
//  AppModel.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/09/28.
//

import RxSwift

class AppModel {
  static let instance = AppModel()
  
  let userModel = UserModel()
  let dataModel = DataModel()
  
}
