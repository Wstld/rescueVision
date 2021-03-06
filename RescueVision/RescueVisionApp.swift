//
//  RescueVisionApp.swift
//  RescueVision
//
//  Created by Pontus Westlund on 2021-01-13.
//

import SwiftUI
import Firebase


@main
struct RescueVisionApp: App {
    @StateObject var viewModel = ObjectDetectionViewModel()
    @UIApplicationDelegateAdaptor private var appDelegate:AppDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}

//colors for app
extension Color {
    static let menuBody = Color("MenuBodyBg")
    static let menuBodyDark = Color("MenuBodyDark")
    static let menuHeader = Color("MenuTitleBg")
    static let textColor = Color("BodyText")
    static let titleColor = Color("TitleText")
}

//appdelegate to config FB
class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
