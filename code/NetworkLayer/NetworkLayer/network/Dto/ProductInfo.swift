// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
///
struct ProductInfoReq: Codable {
    var productId: String
    var queryCond: String
}

struct ProductInfoRes: Codable {
    var productInfo: [ProductInfo]
}

struct ProductInfo: Codable {
    var productId: String
    var price: Int
}
