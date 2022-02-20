// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import Combine
 
Just(1)
   .map { _ in print(Thread.isMainThread) }
   .receive(on: DispatchQueue.global())
   .map { print(Thread.isMainThread) }
   .sink { print(Thread.isMainThread) }
