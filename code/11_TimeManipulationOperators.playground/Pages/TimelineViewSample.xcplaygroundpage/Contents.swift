// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.
import PlaygroundSupport
import Foundation
import Combine
import SwiftUI

public func testSample(label: String , testBlock: () -> Void) {
    print("您正在演示:\(label)")
    testBlock()
    print("演示:\(label)结束")
}
 
let valuesPerSecond = 1.0
let delayInSeconds = 1.5

let sourcePublisher = PassthroughSubject<Date, Never>()
let delayPublisher = sourcePublisher.delay(for: .seconds(delayInSeconds) , scheduler : DispatchQueue.main)

let subscription = Timer.publish(every: 1.0/valuesPerSecond, on: .main, in: .common)
                    .autoconnect()
                    .subscribe(sourcePublisher)


struct ManyFaces: View {
    static let emoji = ["😀", "😬", "😄", "🙂", "😗", "🤓", "😏", "😕", "😟", "😎", "😜", "😍", "🤪"]
    var body: some View {
        
        VStack {
            Spacer()
            TimelineView(.periodic(from: .now, by: 0.2)) { timeline in
                HStack(spacing: 120) {
                    let randomEmoji = ManyFaces.emoji.randomElement() ?? ""
                    Text(randomEmoji)
                        .font(.largeTitle)
                        .scaleEffect(4.0)
                    SubView()
                }
            }
            Spacer()
        }.frame(width: 300, height: 500)
    }
    
    struct SubView: View {
        var body: some View {
            let randomEmoji = ManyFaces.emoji.randomElement() ?? ""

            Text(randomEmoji)
                .font(.largeTitle)
                .scaleEffect(4.0)
        }
    }
}

let sourceTimeline = ManyFaces()

//Playground.current.liveView = UIHostingController(rootView: ManyFaces())
PlaygroundPage.current.liveView = UIHostingController(rootView: ManyFaces())
