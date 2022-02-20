// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation

class JobListDataModel : ObservableObject {
    /// 所有工作信息件数
    @Published var jobCount : Int
    /// 所有工作信息
    @Published var jobInfos : [JobInfoDataModel]
    /// 最新发布的工作信息
    @Published var newJobInfos : [JobInfoDataModel]
    
    init() {
        jobCount = 0
        jobInfos = []
        newJobInfos = []
    }
}

struct JobInfoDataModel : Equatable, Identifiable {
   var id: String
   var jobId : String
   var jobName : String
   var salary : Int
   var companyName : String
   var newFlag : String
    
    init(id: String = UUID().uuidString ,jobId:String , jobName: String, salary : Int, companyName : String, newFlag : String) {
        self.id = id
        self.jobId = jobId
        self.jobName = jobName
        self.salary = salary
        self.companyName = companyName
        self.newFlag = newFlag
    }
    
   static func == (lhs: JobInfoDataModel, rhs: JobInfoDataModel) -> Bool {
        return lhs.jobId == rhs.jobId
    }
}
