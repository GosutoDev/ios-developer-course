//
//  DeeplinkHandling.swift
//  Course App
//
//  Created by Tomáš Duchoslav on 03.06.2024.
//

import Foundation

protocol DeeplinkHandling: AnyObject {
    func handleDeeplink(_ deeplink: Deeplink)
}
