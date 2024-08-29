//
//  Inject_TCA_ObservationApp.swift
//  Inject-TCA-Observation
//
//  Created by Daniel Romero on 8/29/24.
//

import AppFeature
import SwiftUI

@main
struct Inject_TCA_ObservationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            AppFeatureView(store: self.appDelegate.store)
        }
    }
}
