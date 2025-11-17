//
//  CoordinatorProtocol.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 17.11.25.
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}
