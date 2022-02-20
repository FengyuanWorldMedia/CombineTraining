// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation

struct GetJobDetailsReq: Codable {
    var header : CommonReqHeader
    var body: GetJobDetailsReqBody?
    
    init() {
        self.header = CommonReqHeader()
    }
    
    enum CodingKeys : String, CodingKey {
        case header = "header"
        case body = "body"
    }
}

struct GetJobDetailsReqBody : Codable {
    var jobId : String
    enum CodingKeys : String, CodingKey {
      case jobId = "job_id"
    }
}

struct GetJobDetailsRes : Codable {
   var header : CommonResHeader
   var body : GetJobDetailsResBody
   enum CodingKeys : String, CodingKey {
     case header = "header"
     case body = "body"
   }
}

struct GetJobDetailsResBody : Codable {
    var jobId : String
    var jobName : String
    var salary : Int
    var companyName : String
    var newFlag : String
    var dateFrom : String
    var dateTo : String
    var detail : String
    
    enum CodingKeys : String, CodingKey {
        case jobId = "job_id"
        case jobName = "job_name"
        case salary = "salary"
        case companyName = "company_name"
        case newFlag = "new_flag"
        case dateFrom = "date_from"
        case dateTo = "date_to"
        case detail = "detail"
    }
}
 
