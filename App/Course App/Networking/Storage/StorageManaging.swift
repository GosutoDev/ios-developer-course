//
//  StorageManaging.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 10.06.2024.
//

import FirebaseFirestore
import Foundation

protocol StorageManaging {
    func storeLike(jokeId: String, liked: Bool) async throws
}
