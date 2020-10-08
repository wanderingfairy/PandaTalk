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

class APIManager {
  static let instance = APIManager()
  
  private init() { }
  
  let userStatusBooleanSubject = BehaviorSubject<Bool>(value: false)
  
  let currentUserEmailSubject = BehaviorSubject<String>(value: "")
  
  //MARK: - This function must be called from the AppModel instance.
  func apiManagerStart() {
    guard let email = Auth.auth().currentUser?.email else { return }
    currentUserEmailSubject.onNext(email)
    userStatusBooleanSubject.onNext(true)
  }
  
  
}
