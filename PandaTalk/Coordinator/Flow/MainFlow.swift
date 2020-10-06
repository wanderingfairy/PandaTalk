//
//  MainFlow.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/10/05.
//

import RxFlow

enum MainStep: Step {
  case start
}

class MainFlow: Flow {
  var root: Presentable {
    return mainViewController
  }
  
  private let mainViewModel = MainViewModel()
  private lazy var mainViewController = MainViewController(viewModel: mainViewModel)
  
  private var navigationController: UINavigationController? {
    return mainViewController.navigationController
  }
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = step as? MainStep else {
      return .none
    }
    switch step {
    case .start:
      let friendsListFlow = FriendsListFlow()
      let chatListFlow = ChatListFlow()
      let settingFlow = SettingFlow()
      Flows.use(friendsListFlow, chatListFlow, settingFlow, when: .ready) {
        self.mainViewController.viewControllers = [$0, $1, $2]
      }
      return .multiple(flowContributors: [
        .contribute(withNextPresentable: mainViewController, withNextStepper: mainViewModel),
        .flow(friendsListFlow, with: FriendsListStep.start),
        .flow(chatListFlow, with: ChatListStep.start),
        .flow(settingFlow, with: SettingStep.start)
      ])
    }
  }
  
  
}
