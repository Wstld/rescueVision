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
    let presistenceController = PresistenceController.shared
    @StateObject var viewModel = ObjectDetectionViewModel()
    @UIApplicationDelegateAdaptor private var appDelegate:AppDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, presistenceController.container.viewContext)
                .environmentObject(viewModel)
        }
    }
}
extension Color {
    static let menuBody = Color("MenuBodyBg")
    static let menuBodyDark = Color("MenuBodyDark")
    static let menuHeader = Color("MenuTitleBg")
    static let textColor = Color("BodyText")
    static let titleColor = Color("TitleText")
    
}

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
