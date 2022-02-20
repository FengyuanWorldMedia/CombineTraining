//: [Previous](@previous)

import Foundation

private var pendingRequestWorkItem: DispatchWorkItem?

func requestWorkItem() {
    /// 取消task
    pendingRequestWorkItem?.cancel()
    /// 定义新的task
    let requestWorkItem = DispatchWorkItem {
        print("requestWorkItem")
    }
    
    pendingRequestWorkItem = requestWorkItem
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250),
                                  execute: requestWorkItem)
}

requestWorkItem()
