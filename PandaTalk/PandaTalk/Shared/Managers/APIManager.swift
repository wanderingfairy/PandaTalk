//
//  APIManager.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/09/28.
//

import RxSwift
import Firebase
import FirebaseAuth
import FirebaseDatabase
import RxFirebase

class APIManager {
  static let instance = APIManager()
  let disposeBag = DisposeBag()
  private init() { }
  
  let userStatusBooleanSubject = BehaviorSubject<Bool>(value: false)
  
  let currentUserEmailSubject = BehaviorSubject<String>(value: "")
  
  //MARK: - This function must be called from the AppModel instance.
  func apiManagerStart() {
    guard let email = Auth.auth().currentUser?.email else { return }
    print(#function, email)
    currentUserEmailSubject.onNext(email)
    userStatusBooleanSubject.onNext(true)
  }
  
  func checkUserStatusInAPIManager(completion: @escaping (Bool) -> Void) {
    guard let user = Auth.auth().currentUser else {
      completion(false)
      return }
    print(#function, "true")
    user.email != "" ? completion(true) : completion(false)
  }
  
  func postCreateUserWithEmailAndPW(email: String, pw: String, completion: @escaping (Bool) -> Void) {
    Auth.auth().rx.createUser(withEmail: email, password: pw)
      .distinctUntilChanged()
      .take(1)
      .subscribe(onNext: { [unowned self] authResult in
          // User signed in
        guard let userEmail = authResult.user.email else {
          print("회원가입 성공했으나 이메일 없음")
          return }
        self.currentUserEmailSubject.onNext(userEmail)
        self.userStatusBooleanSubject.onNext(true)
        print(#function, "user Create success")
        completion(true)
      }, onError: { error in
          // Uh-oh, an error occurred!
        print(#function, "error :", error.localizedDescription)
        completion(false)
      }).disposed(by: disposeBag)
  }
  
  func postSignInWithEmailAndPW(email: String, pw: String, completion: @escaping (Bool) -> Void) {
    print(#function)
    Auth.auth().rx.signIn(withEmail: email, password: pw)
      .distinctUntilChanged()
      .take(1)
      .subscribe(onNext: { [unowned self] authResult in
              // User signed in
        guard let userEmail = authResult.user.email else {
          print("로그인 성공했으나 이메일 없음")
          return }
        print(authResult.user.email)
        self.currentUserEmailSubject.onNext(userEmail)
        self.userStatusBooleanSubject.onNext(true)
        print(#function, "user sign in success")
        completion(true)
          }, onError: { error in
              // Uh-oh, an error occurred!
            print(#function, "error :", error.localizedDescription)
            completion(false)
          }).disposed(by: disposeBag)
  }
  
  
}
