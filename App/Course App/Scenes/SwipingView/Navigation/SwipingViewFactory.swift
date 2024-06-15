//
//  SwipingViewFactory.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 12.06.2024.
//

import SwiftUI
import UIKit

protocol SwipingViewFactory {
    func makeSwipingView(with joke: Joke?, isChildCoordinator: Bool) -> UIViewController
}
