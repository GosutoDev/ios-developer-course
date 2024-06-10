//
//  StorageManaging.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 10.06.2024.
//

import Foundation
import FirebaseFirestore

protocol StorageManaging {
    func storeLike(jokeId: String, liked: Bool) async throws
}
