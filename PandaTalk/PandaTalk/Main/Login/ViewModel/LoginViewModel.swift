//
//  LoginViewModel.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/09/28.
//

import RxSwift
import RxBinding

class LoginViewModel: BaseViewModel {
  
  let apiManager = APIManager.instance
  
  var emailText = ""
  var passwordText = ""
  
  let emailTextSubject = BehaviorSubject<String>(value: "")
  let passwordTextSubject = BehaviorSubject<String>(value: "")
  let retypePasswordTextSubject = BehaviorSubject<String>(value: "")
  
  let emailIsValidSubject = BehaviorSubject<Bool>(value: false)
  let passwordIsValidSubject = BehaviorSubject<Bool>(value: false)
  let passwordIsEqualToRetypePasswordSubject = BehaviorSubject<Bool>(value: false)
  
  let canSignUpSubject = BehaviorSubject<Bool>(value: false)
  let canSignInSubject = BehaviorSubject<Bool>(value: false)
  
  //MARK: - ViewModel start function.
  // 유저가 로그인 된 상태면 로그인 뷰 닫고 메인 탭바 켬.
  func viewModelStart() {
    emailTextSubject
      .subscribe(onNext: { [unowned self] in self.emailText = $0 })
      .disposed(by: disposeBag)
    
    passwordTextSubject
      .subscribe(onNext: { [unowned self] in self.passwordText = $0})
      .disposed(by: disposeBag)
  }
  
  func checkUserLoginStatus() {
    apiManager.userStatusBooleanSubject
      .distinctUntilChanged()
      .filter { $0 == true}
      .bind { [unowned self] _ in
        print("User is already logined")
        self.steps.accept(LoginStep.loginComplete)
      }
      .disposed(by: disposeBag)
  }
  
  
  func checkCanSignUp() {
    emailTextSubject
      .bind { [unowned self] str in
        str != "" ? emailIsValidSubject.onNext(true) : emailIsValidSubject.onNext(false)
      }
      .disposed(by: disposeBag)
    
    Observable.combineLatest(emailIsValidSubject, passwordIsEqualToRetypePasswordSubject) { $0 && $1 }
      .distinctUntilChanged()
      .bind { [unowned self] bool in
        self.canSignUpSubject.onNext(bool) }
      .disposed(by: disposeBag)
  }
  
  func checkCanSignIn() {
    passwordTextSubject
      .bind { [unowned self] str in
        str.count >= 8 ? passwordIsValidSubject.onNext(true) : passwordIsValidSubject.onNext(false)
      }
      .disposed(by: disposeBag)
    
    Observable.combineLatest(emailIsValidSubject, passwordIsValidSubject) { ($0 && $1)}
      .distinctUntilChanged()
      .bind { [unowned self] bool in
        self.canSignInSubject.onNext(bool)
      }
      .disposed(by: disposeBag)
  }
  
  func didTapSignUpButton() {
    canSignUpSubject
      .distinctUntilChanged()
      .take(1)
      .filter { $0 == true }
      .bind { [unowned self] _ in self.apiManager.postCreateUserWithEmailAndPW(email: emailText, pw: passwordText) { bool in
        if bool {
          self.checkUserLoginStatus()
        }
      }
      }
      .disposed(by: disposeBag)
  }
  
  func didTapSignInButton() {
    print(#function, "함수는 실행됨")
    canSignInSubject
      .distinctUntilChanged()
      .take(1)
      .filter { $0 == true}
      .bind { [unowned self] _ in
        print(#function)
        self.apiManager.postSignInWithEmailAndPW(email: emailText, pw: passwordText) { bool in
          if bool {
            self.checkUserLoginStatus()
          }
        }
      }
      .disposed(by: disposeBag)
  }
}
