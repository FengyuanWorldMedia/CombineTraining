// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation

struct AcceptJobReq: Codable {
    var header : CommonReqHeader
    var body: AcceptJobReqBody?
    init() {
         self.header = CommonReqHeader()
    }
    enum CodingKeys : String, CodingKey {
      case header = "header"
      case body = "body"
    }
}

struct AcceptJobReqBody: Codable {
    var jobId : String
    var myName : String
    var mailAddress : String
    var date : String
    var apeal : String
    
    enum CodingKeys : String, CodingKey {
        case jobId = "job_id"
        case myName = "my_name"
        case mailAddress = "mail_address"
        case date = "date"
        case apeal = "apeal"
    }
}
 

struct AcceptJobRes : Codable {
   var header : CommonResHeader
   enum CodingKeys : String, CodingKey {
     case header = "header"
   }
}
