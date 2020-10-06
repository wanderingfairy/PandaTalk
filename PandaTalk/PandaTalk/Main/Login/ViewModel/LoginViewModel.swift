//
//  LoginViewModel.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/09/28.
//

import RxSwift
import RxBinding

class LoginViewModel: BaseViewModel {
  
  let emailTextSubject = BehaviorSubject<String>(value: "")
  let passwordTextSubject = BehaviorSubject<String>(value: "")
  
  func didTapSignInButton() {
  }
}
