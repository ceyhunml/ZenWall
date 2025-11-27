//
//  SignupCoordinator.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 27.11.25.
//

import Foundation
import UIKit

class SignupCoordinator: Coordinator {
    private var builder: UserBuilder
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController, builder: UserBuilder) {
        self.builder = builder
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = FullnameViewController()
        navigationController.show(vc, sender: nil)
    }

    func showEmail(fullname: String) {
        builder.setFullname(fullname: fullname)
        let controller = EmailViewController(viewModel: .init(coordinator: self))
        navigationController.show(controller, sender: nil)
    }
//    
//    func showSuccess(card: String) {
//        builder.setCard(card: card)
//        let controller = SuccessController(builder: builder)
//        controller.close = { [weak self] in
//            self?.navigationController.popToRootViewController(animated: true)
//        }
//        navigationController.present(controller, animated: true)
//    }
}
