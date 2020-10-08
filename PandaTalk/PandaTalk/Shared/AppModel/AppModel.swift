//
//  AppModel.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/09/28.
//

import RxSwift

class AppModel {
  static let instance = AppModel()
  
  private init() { }
  
  let userModel = UserModel()
  let dataModel = DataModel()
  let apiManager = APIManager.instance
  
  func appStart() {
    apiManager.apiManagerStart()
  }
  
  
}
