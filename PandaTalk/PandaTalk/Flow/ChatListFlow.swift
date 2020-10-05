//
//  ChatListFlow.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/10/06.
//

import RxFlow

enum ChatListStep: Step {
  case start
}

class ChatListFlow: Flow {
  
  var root: Presentable {
    chatListViewController
  }
  
  private let chatListViewController: ChatListViewController
  
  init() {
    chatListViewController = ChatListViewController(viewModel: .init())
  }
  
  private var navigationController: UINavigationController? {
    chatListViewController.navigationController
  }
  
  
  func navigate(to step: Step) -> FlowContributors {
    guard let chatListStep = step as? ChatListStep else {
      return .none
    }
    switch chatListStep {
    case .start:
      return .viewController(chatListViewController)
    }
  }
}
