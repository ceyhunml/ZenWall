//
//  BackendService.swift
//  ZenWall
//
//  Created by Ceyhun Məmmədli on 03.12.25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol BackendService {
    var auth: Auth { get }
    var firestore: Firestore { get }
}
