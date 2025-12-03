//
//  FirebaseAdapter.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 03.12.25.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

final class FirebaseAdapter: BackendService {

    static let shared = FirebaseAdapter()

    private init() {
        FirebaseApp.configure()
    }

    var auth: Auth { Auth.auth() }
    var firestore: Firestore { Firestore.firestore() }
}
