//
//  UserModel.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/10/06.
//

import RxSwift
import RxOptional

struct UserModel {
  
  private let bag = DisposeBag()
  
  private let firebaseUID = BehaviorSubject<String?>(value: nil)
  
  func setting(UID: String?) throws {
    guard let uid = UID else {
      throw AppError.uidIsNil
    }
    firebaseUID.onNext(uid)
    print("UID save is success")
  }
  
  func readCurrentUID(completion: @escaping (Result<String,AppError>) -> Void) {
    firebaseUID
      .errorOnNil(AppError.currentUIDReadingIsFail)
      .subscribe(
        onNext: { uid in
          completion(.success(uid))
        },
        onError: { (error) in
          completion(.failure(.currentUIDReadingIsFail))
      })
      .disposed(by: bag)
  }
}
