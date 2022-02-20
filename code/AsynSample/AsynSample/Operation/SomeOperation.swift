// Created by AppDelegate on 2021/11/28.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.
//

import Foundation

class SomeOperation: Operation {
    let value: Int
    
    init(value: Int) {
        self.value = value
    }

    override func main() {
        Thread.sleep(forTimeInterval: 1)
        print(value)
    }
}
