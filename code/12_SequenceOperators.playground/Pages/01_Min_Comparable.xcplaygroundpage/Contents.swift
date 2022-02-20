// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}

/// https://developer.apple.com/documentation/swift/comparable
struct CustomDate: Comparable {
    
    let year: Int
    let month: Int
    let day: Int
    
    static func == (lhs: CustomDate, rhs: CustomDate) -> Bool {
        return lhs.year == rhs.year
                && lhs.month == rhs.month
                && lhs.day == rhs.day
    }
    
    static func < (lhs: CustomDate, rhs: CustomDate) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        } else if lhs.month != rhs.month {
            return lhs.month < rhs.month
        } else {
            return lhs.day < rhs.day
        }
    }
    
    static func <= (lhs: CustomDate, rhs: CustomDate) -> Bool {
        return lhs < rhs || lhs == rhs
    }
    
    static func > (lhs: CustomDate, rhs: CustomDate) -> Bool {
        return !(lhs <= rhs)
    }
    
    static func >= (lhs: CustomDate, rhs: CustomDate) -> Bool {
        return lhs > rhs ||  lhs == rhs
    }
}

testSample(label: "01_Min_Comparable") {
    let date1 = CustomDate(year: 2021, month: 10, day: 5)
    let date2 = CustomDate(year: 2021, month: 10, day: 6)
    let date3 = CustomDate(year: 2021, month: 10, day: 4)
    let dates = [date1,date2,date3]
    print(dates)
    print(dates.sorted()) // 升序
    print(dates.sorted { $0 > $1 })// 降序
}

var subscriptions = Set<AnyCancellable>()
 

/// 数值最小值， 数据由sourcePublisher发布者产生。
testSample(label: "01_Min02") {
    let sourcePublisher = PassthroughSubject<CustomDate, Never>()
    sourcePublisher
        .min()
        .sink(receiveCompletion: { completion in
            print("01_Min02 completion:\(completion)")
        }, receiveValue: { minValue in
            print("01_Min02 min value : \(minValue)")
        }).store(in: &subscriptions)
    
    let date1 = CustomDate(year: 2021, month: 10, day: 5)
    let date2 = CustomDate(year: 2021, month: 10, day: 3)
    let date3 = CustomDate(year: 2021, month: 10, day: 4)
    let date4 = CustomDate(year: 2021, month: 10, day: 8)
    
    sourcePublisher.send(date1)
    sourcePublisher.send(date2)
    sourcePublisher.send(date3)
    sourcePublisher.send(date4)
    // 这个是一定要有的，否则min 不会效果；认为输入没有完成，无法获取最小值。
    sourcePublisher.send(completion: .finished)
}
 





