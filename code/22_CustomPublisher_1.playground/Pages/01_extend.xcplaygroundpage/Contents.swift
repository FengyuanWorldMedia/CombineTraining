// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine

extension Publisher {
    
    /// 其中 Output 已经在 Publisher 里 声明过。
    /// where Output == Optional<T> 表示 接收的类型为 Optional<T> ，本例测试为 Optional<Int> ,即 Int？或 String?。
    ///  本里中的范型类型，是由返回值类型Publishers.CompactMap<Self, T> 中的 T 决定的， 其中的 Self 为 Upstream类型，即 Publisher 。
    /// compactMap 是 Publisher 既存的Operator，其返回值 Publishers.CompactMap<Self, T>。
    ///
    /// 通过这个扩展，我们就把 compactMap 的功能封装在自己的 Publisher中了，而不需要做其他任何工作。
    ///
    func ignoreOptionalValues<T>() -> Publishers.CompactMap<Self, T> where Output == Optional<T> {
        self.compactMap { $0 }
    }
    
    func myPrefix<T>() -> Publishers.Output<Self> where Output == T {
        self.prefix(2)
    }
    
}


let intvalues : [Int?] = [1, 2, nil , 3 , 4 , nil]

intvalues.publisher
        .ignoreOptionalValues()
        .sink {
            print("ignoreOptionalValues(int) receive value: \($0)")
        }


let strvalues : [String?] = ["a", "b", nil , "c" , "d" , nil]

strvalues.publisher
        .ignoreOptionalValues()
        .sink {
            print("ignoreOptionalValues(String) receive value: \($0)")
        }


strvalues.publisher
        .myPrefix()
        .sink {
            print("myPrefix receive value: \($0)")
        }
