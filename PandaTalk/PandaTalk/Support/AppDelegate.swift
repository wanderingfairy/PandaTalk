//
//  AppDelegate.swift
//  PandaTalk
//
//  Created by 정의석 on 2020/09/28.
//

import SnapKit
import RxSwift
import RxFlow
import Firebase
import Then

#if DEBUG
import Gedatsu
import FLEX
#endif

@_exported import RxBinding

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  private let coordinator = FlowCoordinator()
  private let disposeBag = DisposeBag()
  private let window = UIWindow()
  private let appModelInstance = AppModel.instance
  private let apiManagerInstance = APIManager.instance

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    #if DEBUG
    Gedatsu.open()
    FLEXManager.shared.showExplorer()
    #endif
    
    FirebaseApp.configure()
    AppModel.instance.appStart()
    
    coordinator.rx.didNavigate.subscribe(onNext: {
        print("did navigate to \($0) -> \($1)")
    }).disposed(by: disposeBag)
    
    //SignOut
    try? Auth.auth().signOut()
    
    //Login 분기 처리 필요
    apiManagerInstance.checkUserStatusInAPIManager() { [unowned self] bool in
      switch bool {
      case true :
        self.coordinate {
          (AppFlow(window: $0), AppStep.main)
        }
      case false:
        self.coordinate {
          (AppFlow(window: $0), AppStep.login)
        }
      }
    }
    return true
  }
  
  private func coordinate(to: (UIWindow) -> (Flow, Step)) {
    let (flow, step) = to(window)
    coordinator.coordinate(flow: flow, with: OneStepper(withSingleStep: step))
    window.makeKeyAndVisible()
  }
}

