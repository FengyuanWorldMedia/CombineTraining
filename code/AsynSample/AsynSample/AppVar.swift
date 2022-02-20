// Created by AppDelegate on 2021/11/28.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.
//

import Foundation
class AppVar {
    static var envObj = EnvObj()
    static var openMethod = ""
    static var linkInfo = ""
}

class EnvObj : ObservableObject {
    @Published var showDialog = false
}
