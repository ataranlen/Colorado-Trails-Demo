//
//  ColoradoTrailsApp.swift
//  Colorado Trails
//
//  Created by Nathan Stoltenberg on 9/3/25.
//

import SwiftUI
import OAuthSwift

@main
struct ColoradoTrailsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    print("onOpenURL - \(url)")

                    OAuthSwift.handle(url: url)

                }
        }
    }
}
