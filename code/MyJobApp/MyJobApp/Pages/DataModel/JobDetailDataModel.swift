// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation

class JobDetailDataModel : Equatable, ObservableObject {
    @Published var id: String
    @Published var jobId : String
    @Published var jobName : String
    @Published var salary : Int
    @Published var companyName : String
    @Published var newFlag : String
    @Published var dateFrom : String
    @Published var dateTo : String
    @Published var detail : String
    
    init() {
        self.id = UUID().uuidString
        self.jobId = ""
        self.jobName = ""
        self.salary = 0
        self.companyName = ""
        self.newFlag = ""
        self.dateFrom = ""
        self.dateTo = ""
        self.detail = ""
    }
    
    init(id: String = UUID().uuidString ,jobId:String , jobName: String, salary : Int, companyName : String, newFlag : String
         , dateFrom : String, dateTo : String , detail : String) {
        self.id = id
        self.jobId = jobId
        self.jobName = jobName
        self.salary = salary
        self.companyName = companyName
        self.newFlag = newFlag
        self.dateFrom = dateFrom
        self.dateTo = dateTo
        self.detail = detail
    }
    
    static func == (lhs: JobDetailDataModel, rhs: JobDetailDataModel) -> Bool {
        return lhs.jobId == rhs.jobId
    }
}
