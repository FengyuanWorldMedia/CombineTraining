// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation

class AsyncClass {
    
    var completionHandler: (() -> Void)?
    
    func asyncMethod(completionHandler: @escaping () -> Void) {
        print("async")
//        self.completionHandler = completionHandler
//        self.completionHandler?()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completionHandler()
        }
        print("async end")
    }
    
    func syncMethod(completionHandler: () -> Void) {
        print("sync")
        completionHandler()
        print("sync end")
    }
}

class TestClass {
    
    var tmp = 0

    let asyncInstance = AsyncClass()
    func asyncTest() {
        asyncInstance.asyncMethod {
            self.tmp = 100
            print("asyncMethod")
        }
    }
    func syncTest() {
        asyncInstance.syncMethod {
            self.tmp = 100
            print("syncMethod")
        }
    }
    deinit {
        print("released")
    }

}
 
func classTest() {
    let testInstance: TestClass? = TestClass()
    testInstance!.asyncTest()
    testInstance!.syncTest()
}

classTest()

// testInstance --> asyncInstance -> completionHandler -> testInstance#tmp

//testInstance --> asyncInstance
