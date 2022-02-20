// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
///
struct PurchaseReq: Codable {
    var productIds: [String]
    var cost: Int
}

struct PurchaseRes: Codable {
    var resultCd: String
    var orderId: String
}
