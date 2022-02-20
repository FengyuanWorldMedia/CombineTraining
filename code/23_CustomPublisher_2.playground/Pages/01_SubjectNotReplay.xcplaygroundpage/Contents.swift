// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

let publisher = PassthroughSubject<Int , Never>()
publisher.send(0)

let subscription1 = publisher.sink(receiveCompletion: {
    print("subscription1 \($0)")
}, receiveValue: {
    print("subscription1 \($0)")
})

publisher.send(1)
publisher.send(2)
publisher.send(3)

let subscription2 = publisher.sink(receiveCompletion: {
    print("subscription2 \($0)")
}, receiveValue: {
    print("subscription2 \($0)")
})

publisher.send(4)
publisher.send(5)
publisher.send(completion: .finished)

var subscription3: AnyCancellable? = nil

DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    subscription3 = publisher.sink(receiveCompletion: {
        print("subscription3 \($0)")
    }, receiveValue: {
        print("subscription3 \($0)")
    })
    
}

