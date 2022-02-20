// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import SwiftUI
import Combine

struct JobListPage: View {
    
    @State private var subscriptions = Set<AnyCancellable>()
    
    @State private var service = JobService(networkRequest: NativeRequestable())
    
    @EnvironmentObject var jobDataModel: JobListDataModel
    
    @StateObject var jobDetailDataModel: JobDetailDataModel = JobDetailDataModel()
    
    @State private var seeDetailFlg = false
    @State private var allJobsFlg = true
    
    var body: some View {
        NavigationView () {
            if self.jobDataModel.jobInfos.count == 0 {
                VStack {
                    Image("recruitment")
                        .resizable()
                        .frame(width: UIScreen.screenWidth, height: 200)
                        .padding(.bottom, 10)
                    Text("努力加载中...")
                        .foregroundColor(Color.gray)
                        .padding(.top, 100)
                    Spacer()
                }.edgesIgnoringSafeArea(.top)
            } else {
                ScrollView {
                    Image("recruitment")
                        .resizable()
                        .frame(width: UIScreen.screenWidth, height: 200)
                        .padding(.bottom, 10)
                    VStack {
                        HStack {
                            Button(action: {
                                /// All
                                self.allJobsFlg = true
                            }, label: {
                                Text("所有")
                                    .foregroundColor(Color(hex: 0x5AA3BF))
                            })
                            
                            Button(action: {
                                self.allJobsFlg = false
                            }, label: {
                                Text("最新")
                                    .foregroundColor(Color(hex: 0x5AA3BF))
                            })
                            
                            Button(action: {
                                self.jobDataModel.jobInfos.removeAll()
                                self.jobDataModel.newJobInfos.removeAll()
                                self.getJobList()
                            }, label: {
                                Image("search")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }).padding(.leading, 20)
                            
                            Spacer().frame(width: UIScreen.screenWidth * 0.1)
                            
                            Text("\(self.jobDataModel.jobCount) 件招聘信息")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                                .padding(.trailing, 20)
                        }
                        VStack(alignment: .leading) {
                            if self.allJobsFlg {
                                ForEach(self.jobDataModel.jobInfos ) { jobInfo in
                                    JobInfoRowView(jobInfo: jobInfo) { jobId in
                                        getJobDetails(jobId: jobInfo.jobId)
                                    }
                                }
                            } else {
                                ForEach(self.jobDataModel.newJobInfos ) { jobInfo in
                                    JobInfoRowView(jobInfo: jobInfo) { jobId in
                                        getJobDetails(jobId: jobInfo.jobId)
                                    }
                                }
                            }
                        }
                    }
                    NavigationLink(destination: JobDetailPage(jobDetail: self.jobDetailDataModel),
                                   isActive: self.$seeDetailFlg) {
                        EmptyView()
                    }
                }.edgesIgnoringSafeArea(.top)
            }
        }.onAppear {
            self.getJobList()
        }.background(Color(hex: 0xF8F8F8))
            .navigationBarTitle("")
            .navigationBarHidden(true)
    }
    
    func getJobList() {
        print("search all jobs")
        let req = GetJobListReq()
        let allJobPublisher = service.getJobList(req: req)
        
        allJobPublisher.map({
            reponse in
            return reponse.body.jobInfos.count
        })
        .replaceError(with: 0)
        .assign(to: &self.jobDataModel.$jobCount)
        
        allJobPublisher.sink(receiveCompletion: { (completion) in
                    switch completion {
                    case .failure(let error):
                        print("获取工作一览 error \(error.localizedDescription)")
                    case .finished:
                        print("获取工作一览 finished")
                    }
        }, receiveValue: { (response) in
            if response.header.resultCd == "OK" {
                let jobList = response.body.jobInfos
                var jobInfos = [JobInfoDataModel]()
                for job in jobList {
                    let model = JobInfoDataModel(jobId: job.jobId,
                                                 jobName: job.jobName,
                                                 salary: job.salary,
                                                 companyName: job.companyName,
                                                 newFlag: job.newFlag)
                    jobInfos.append(model)
                }
                jobDataModel.jobInfos = jobInfos
            }

        }) .store(in: &self.subscriptions)
        
        allJobPublisher
            .tryMap { (res) -> GetJobListRes in
                if res.header.resultCd != "OK" {
                    throw NetworkError.badRequest(code: 501, error: "requestError")
                } else {
                    return res
                }
            }
            .flatMap {
                $0.body.jobInfos.publisher
            }
            .filter {
                return $0.newFlag == "1"
            }
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print("获取最新工作一览 error \(error.localizedDescription)")
                case .finished:
                    print("获取最新工作一览 finished")
                }
            }, receiveValue: { (jobInfo) in
                let model = JobInfoDataModel(jobId: jobInfo.jobId,
                                             jobName: jobInfo.jobName,
                                             salary: jobInfo.salary,
                                             companyName: jobInfo.companyName,
                                             newFlag: jobInfo.newFlag)
                jobDataModel.newJobInfos.append(model)
            })
             .store(in: &self.subscriptions)
    }
    
    func getJobDetails(jobId : String) {
        print("JobDetail Search  jobId: \(jobId)")
        var req = GetJobDetailsReq()
        req.body = GetJobDetailsReqBody(jobId: jobId)
        service.getJobDetails(req: req)
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("获取工作详细 error \(error.localizedDescription)")
                case .finished:
                    print("获取工作详细 finished")
                }
            } receiveValue: { (response) in
                print("ResponseBody:\(response)")
                if response.header.resultCd == "OK" {
                    let jobDetail: GetJobDetailsResBody = response.body
                    jobDetailDataModel.jobId = jobDetail.jobId
                    jobDetailDataModel.jobName = jobDetail.jobName
                    jobDetailDataModel.salary = jobDetail.salary
                    jobDetailDataModel.companyName = jobDetail.companyName
                    jobDetailDataModel.newFlag = jobDetail.newFlag
                    jobDetailDataModel.dateFrom = jobDetail.dateFrom
                    jobDetailDataModel.dateTo = jobDetail.dateTo
                    jobDetailDataModel.detail = jobDetail.detail
                    self.seeDetailFlg = true
                }
            }
            .store(in: &self.subscriptions)
    }
    
    
}

struct JobInfoRowView: View {
    var jobInfo: JobInfoDataModel
    
    var moreHandler: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text(jobInfo.jobName)
                    .font(Font.system(size: CGFloat(15), design: Font.Design.default))
                .padding([.horizontal, .top], 5)
                Spacer()
                if jobInfo.newFlag == "1" {
                    Image("new")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
         
           //  Divider()
            HStack (alignment: .center) {
                VStack(alignment: .leading) {
                    Text("诚聘企业").font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text(jobInfo.companyName)
                        .font(Font.system(size: CGFloat(12), design: Font.Design.default))
                        .foregroundColor(.gray)
                        .background(Color(hex: 0xF0F0F0))
                }
                Spacer()
                Text("¥ " + String(jobInfo.salary))
                    .font(Font.system(size: CGFloat(15), design: Font.Design.default))
                    .foregroundColor(Color(hex: 0xED794E))
                .padding([.trailing], 10)
                Button(action: {
                    moreHandler(self.jobInfo.jobId)
                }) {
                    Text(">>")
                        .font(Font.system(size: CGFloat(15), design: Font.Design.default))
                        .foregroundColor(Color(hex: 0x5AA3BF))
                }
            }
            .padding([.horizontal, .bottom], 5)
        }
        .border(width: 1, edges: [.bottom], color: Color(hex: 0xB2DBE8)) 
        .padding([.all], 2)
    }
}
 
struct JobListPage_Previews: PreviewProvider {
    static var previews: some View {
        JobListPage().environmentObject(JobListDataModel())
    }
}
