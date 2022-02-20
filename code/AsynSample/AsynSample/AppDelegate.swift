// Created by AppDelegate on 2021/11/28.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.
//
import SwiftUI
import Foundation

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("app startup")
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func application(  _ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions ) -> UISceneConfiguration {
        let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = FySceneDelegate.self
        return sceneConfig
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        AppVar.linkInfo = url.absoluteString
        AppVar.envObj.showDialog = true
        return true
    }
}
