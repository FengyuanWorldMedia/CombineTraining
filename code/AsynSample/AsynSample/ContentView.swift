// Created by AppDelegate on 2021/11/28.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.
//

import SwiftUI

extension Notification.Name {
    static let paramChange = Notification.Name("paramChange")
}

struct ContentView: View {
    /// NotificationCenter
    private let publisher = NotificationCenter.Publisher(center: .default,
                                                         name: .paramChange)
                                                        .receive(on: RunLoop.main)
    @State private var val = 1
    
    /// Timer
    @State var currentDate = Date()
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var cnt = 1
    
    
    var body: some View {
        VStack {
            Text("Hello, world!  \(self.cnt)")
                .padding()
            Button("Notification Sample", action: {
                let center = NotificationCenter.default
                self.val = val + 1
                let notification = Notification(name: .paramChange, object: "Parameter\(self.val)", userInfo: nil)
                center.post(notification)
            })
            
            Button("Operation Sample", action: {
                operationSample()
            })
            Button("Grand Central Dispatch (GCD)  Sample", action: {
                gcdSample()
            })
            Button("Closure Sample", action: {
                netSample()
            })
            
        }.onReceive(self.publisher, perform: { notification in
            if let value = notification.object as? String {
               print("params:\(value)")
            }
         }).onReceive(timer) { input in
             self.currentDate = input
             self.cnt = cnt + 1
             debugPrint(currentDate)
             if self.cnt > 5 {
                 self.timer.upstream.connect().cancel()
             }
         }
    }
    
    /// Operations
    private func operationSample() {
        print("operationSample start")
        let queue = OperationQueue()
        queue.name = "com.fytx.my_operation_queue"
        // 同时进行的Operation 最大数量
        queue.maxConcurrentOperationCount = 2
        // NSOperationQualityOfServiceBackground or NSOperationQualityOfServiceUserInteractive
        queue.qualityOfService = .userInitiated
        
        var operations: [SomeOperation] = []
        for i in 0..<5 {
            operations.append(SomeOperation(value: i))
        }
        queue.addOperations(operations, waitUntilFinished: true)
        // waitUntilFinished true的时候，"operationSample end" 最后打印
        // 为false的时候，在"operationSample start" 之后，立即打印。
        print("operationSample end")
    }
    
    /// Grand Central Dispatch (GCD)  Sample
    private func gcdSample() {
        /// DispatchQueue.sync 同步
        /// DispatchQueue.async 异步
        let concurrentTasks = 3
        let queue = DispatchQueue(label: "Concurrent queue", attributes: .concurrent)
        let sema = DispatchSemaphore(value: concurrentTasks)
        for i in 0..<10 {
            queue.async {
                print("gcdSample : \(i)")
                sema.signal() // 使用 （未使用的 信号）
            }
            sema.wait() // 等待 释放信号
        }
    }
    
    /// Closure Sample
    private func netSample() {
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        if var urlComponents = URLComponents(string: "https://www.google.com/search") {
          urlComponents.query = "q=swift"
          guard let url = urlComponents.url else {
            return
          }
          dataTask = defaultSession.dataTask(with: url) { data, response, error in // 逃逸闭包的概念
            defer {
                dataTask = nil
            }
            debugPrint(response)
            debugPrint(data)
            if let error = error {
                debugPrint("DataTask error: \( error.localizedDescription)")
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                debugPrint("DataTask Data: \(data)")
                DispatchQueue.main.async {
                    /// TODO：在画面的 main线程上 显示数据。
                    debugPrint("在画面的 main线程上 显示数据。")
                }
            }
          }
          dataTask?.resume()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
