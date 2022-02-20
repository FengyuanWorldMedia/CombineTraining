// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation


struct CommonReqHeader : Codable {
    var token : String
    
    init() {
        self.token = UUID().description
    }
    
    enum CodingKeys : String, CodingKey {
        case token = "token"
    }
}

struct CommonResHeader : Codable {
    var resultCd : String
    enum CodingKeys : String, CodingKey {
      case resultCd = "result_cd"
    }
}
