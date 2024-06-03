//
//  CustomNavigationController.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 24.05.2024.
//

import Combine
import os
import UIKit

final class CustomNavigationController: UINavigationController {
    private let logger = Logger()
    private let eventSubject = PassthroughSubject<CustomNavigationControllerEvent, Never>()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAppearance()
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            eventSubject.send(.dismiss)
        }
    }
}

// MARK: - Event Emitter
extension CustomNavigationController: EventEmitting {
    var eventPublisher: AnyPublisher<CustomNavigationControllerEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
}

// MARK: - Gesture Recognizer Delegate
extension CustomNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        logger.info("\(gestureRecognizer)")
        return true
    }
}

// MARK: - Controller Delegate
extension CustomNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        logger.info("\(viewController)")
    }
}
