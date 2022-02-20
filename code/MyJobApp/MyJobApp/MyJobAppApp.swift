// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import SwiftUI

@main
struct MyJobAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(JobListDataModel())
        }
    }
}
