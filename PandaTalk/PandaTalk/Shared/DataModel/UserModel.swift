//
//  UserModel.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/10/06.
//

import RxSwift
import RxOptional
import Firebase
import FirebaseAuth

struct UserModel {
  
  private let bag = DisposeBag()
  
  let userSubject = BehaviorSubject<User?>(value: nil)
  
  let userEmail = BehaviorSubject<String?>(value: nil)
  let uid = BehaviorSubject<String?>(value: nil)
  
  let currentUser = PublishSubject<CurrentUser>()
}
