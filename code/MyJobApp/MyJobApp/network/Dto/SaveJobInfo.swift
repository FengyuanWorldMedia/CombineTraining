// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation

struct SaveJobInfoReq: Codable {
    var header: CommonReqHeader
    var body: SaveJobInfoReqBody?
    init() {
         self.header = CommonReqHeader()
    }
    enum CodingKeys : String, CodingKey {
      case header = "header"
      case body = "body"
    }
}

struct SaveJobInfoReqBody : Codable {
    var jobId : String
    enum CodingKeys : String, CodingKey {
      case jobId = "job_id"
    }
}
 

struct SaveJobInfoRes : Codable {
   var header : CommonResHeader
   enum CodingKeys : String, CodingKey {
     case header = "header"
   }
}
 
