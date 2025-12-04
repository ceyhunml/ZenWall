//
//  InternetMonitor.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 04.12.25.
//

import Foundation
import Network

final class InternetMonitor {

    static let shared = InternetMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "InternetMonitor")

    var isConnected: Bool = false
    var onStatusChange: ((Bool) -> Void)?

    private init() {
        monitor.pathUpdateHandler = { path in
            let online = path.status == .satisfied
            self.isConnected = online

            DispatchQueue.main.async {
                self.onStatusChange?(online)
            }
        }
        monitor.start(queue: queue)
    }

    func checkInternet(completion: @escaping (Bool) -> Void) {
        let testMonitor = NWPathMonitor()
        testMonitor.pathUpdateHandler = { path in
            completion(path.status == .satisfied)
            testMonitor.cancel()
        }
        testMonitor.start(queue: DispatchQueue.global())
    }
}
