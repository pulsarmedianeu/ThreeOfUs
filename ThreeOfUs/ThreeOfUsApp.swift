//
//  ThreeOfUsApp.swift
//  ThreeOfUs
//
//  Created by Orszagh Sandor on 2022. 03. 29..
//

import SwiftUI

@main
struct ThreeOfUsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
