//
//  StorageManager.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 10.06.2024.
//

import FirebaseFirestore
import Foundation
import os


final class StorageManager: StorageManaging {
    // MARK: Private properties
    private let database = Firestore.firestore()
    private let logger = Logger()
    
    // MARK: Functions
    func storeLike(jokeId: String, liked: Bool) async throws {
        do {
            try await database.collection("jokesLikes").document(jokeId).setData([
                "liked": liked
            ])
            logger.info("Document successfully written!")
        } catch {
            logger.info("Error writing document: \(error)")
        }
    }
    
    func liked(jokeId: String) async throws -> Bool {
        let docRef = database.collection("jokesLikes").document(jokeId)
        do {
            let document = try await docRef.getDocument()
            if let liked = document.data()?["liked"] as? Bool {
                return liked
            }
        } catch {
            logger.info("Error reading document: \(error)")
        }
        return false
    }
}
