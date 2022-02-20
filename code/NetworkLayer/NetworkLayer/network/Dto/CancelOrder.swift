// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation

struct CancelOrderReq: Codable {
    var orderId: String
    var reason: String
}

struct CancelOrderRes: Codable {
    var resultCd: String
}
