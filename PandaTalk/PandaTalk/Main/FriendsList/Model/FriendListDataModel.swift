//
//  FriendsListDataModel.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/09/28.
//

import RxSwift
import SkeletonView

struct FirendsListDataModel {
  var myProfile: CurrentUser!
  var friendsList: [Friend]
}

struct CurrentUser {
  var name: String
  var profileImage: UIImage?
  var email: String
  var uid: String
}

struct Friend {
  var name: String
  var profileImage: UIImage?
  var email: String
  var uid: String
}



let dummyFriend1 = Friend(name: "Red fox", profileImage: UIImage(), email: "fox@naver.com", uid: "WIEF123WDF")
let dummyFriend2 = Friend(name: "Polar bear", profileImage: UIImage(), email: "polarBear@naver.com", uid: "POLARBEAR")
let dummyFriend3 = Friend(name: "Cat", profileImage: UIImage(), email: "cat@gmail.com", uid: "CATUIDDUMMY")


