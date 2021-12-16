//
//  CombineExampleApp.swift
//  CombineExample
//
//  Created by 강희영 on 2021/12/16.
//

import SwiftUI

@main
struct CombineExampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
