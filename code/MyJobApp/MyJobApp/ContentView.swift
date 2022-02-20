// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import SwiftUI
import Combine

struct ContentView: View {
    
    @EnvironmentObject var jobDataModel: JobListDataModel
    
    var  body: some View {
        VStack(spacing: 20) {
            JobListPage()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
