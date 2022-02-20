// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}

/// https://developer.apple.com/documentation/swift/textoutputstream
class TimerLogger : TextOutputStream {
    private var previous = Date()
    private let formatter = NumberFormatter()
    
    init() {
        formatter.maximumFractionDigits = 5
        formatter.minimumFractionDigits = 5
    }
    func write(_ string : String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return
        }
        let now = Date()
        print("+ \(formatter.string(for: now.timeIntervalSince(previous))!) \(string)")
        previous = now
    }
}

var subscriptions = Set<AnyCancellable>()

/// print 进行Debug信息输出。
testSample(label: "02_append"){
    let arrPublisher = [100,200,300,20,14].publisher
    arrPublisher
        .print("debugInfo", to: TimerLogger())
        .sink(receiveCompletion: { completion in
            print("02_apend completion:\(completion)")
        }, receiveValue: { value in
            print("02_apend value : \(value)")
        }).store(in: &subscriptions)
}
 
