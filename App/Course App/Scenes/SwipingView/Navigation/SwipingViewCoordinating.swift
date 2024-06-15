//
//  SwipingViewCoordinating.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 12.06.2024.
//

import SwiftUI
import UIKit

protocol SwipingViewCoordinating: ViewControllerCoordinator {
    func makeSwipingView(with joke: Joke?, isChildCoordinator: Bool) -> UIViewController
}

extension SwipingViewCoordinating where Self: CancellablesContaining, Self: NavigationControllerCoordinator {
    func makeSwipingView(with joke: Joke? = nil, isChildCoordinator: Bool = false) -> UIViewController {
        let store = SwipingViewStore(isChildCoordinator: isChildCoordinator)
        store.eventPublisher.sink { [weak self] _ in
            self?.navigationController.popToRootViewController(animated: true)
        }
        .store(in: &cancellables)
        
        return UIHostingController(rootView: SwipingView(store: store))
    }
}
