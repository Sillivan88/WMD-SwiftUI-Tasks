//
//  SceneDelegate.swift
//  Tasks
//
//  Created by Thomas Sillmann on 17.03.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let testTasks = [
            Task(title: "Workshop vorbereiten", priority: .high),
            Task(title: "Workshop durchführen", priority: .high),
            Task(title: "Swift-Artikel schreiben")
        ]
        let contentView = ContentView().environmentObject(TaskManager(tasks: testTasks))
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
}
