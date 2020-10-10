//
//  AppModel.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/09/28.
//

import RxSwift

class AppModel {
  static let instance = AppModel()
  
  let disposeBag = DisposeBag()
  
  private init() { }
  
  let userModel = UserModel()
  let dataModel = DataModel()
  let apiManager = APIManager.instance
  
  func appStart() {
    apiManager.apiManagerStart()
    
    apiManager.user
      .filterNil()
      .bind {
        self.userModel.userEmail.onNext($0.email)
        self.userModel.uid.onNext($0.uid)
        
        print("in UserModel's email, uid is :",
              try? self.userModel.userEmail.value(),
              try? self.userModel.uid.value()
              )
      }
      .disposed(by: disposeBag)
  }
}
