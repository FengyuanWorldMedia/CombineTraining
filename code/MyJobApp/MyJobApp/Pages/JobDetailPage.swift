// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import SwiftUI
import Combine

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

struct JobDetailPage: View {
    
    @State private var subscriptions = Set<AnyCancellable>()
    @State private var service = JobService(networkRequest: NativeRequestable())
    
    var jobDetail: JobDetailDataModel
    
    private let SaveAreaGradient =  Gradient(stops: [
        Gradient.Stop(color: Color(hex: 0x75DBE8), location: 0.3),
        Gradient.Stop(color:  Color(hex: 0x5AA3BF), location: 0.6)
    ])
    
    @State private var acceptFlg = false
    
    @State private var saveJobsFlg = false
    
    var body: some View {
        
        ScrollView(.vertical) {
            Image("recruitment")
                .resizable()
                .frame(width: UIScreen.screenWidth, height: 200) 
                .padding(.bottom, 10)
                
            
            VStack(alignment: .leading, spacing: 20) {
                HStack() {
                    Text("职位:").font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text(jobDetail.jobName).font(.system(size: 20))
                }
                HStack {
                    Text("月薪:").font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text("\(jobDetail.salary)").font(.system(size: 20))
                }
                HStack {
                    Text("企业:").font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text(jobDetail.companyName).font(.system(size: 20))
                }
                HStack {
                    Text("最新发布:").font(.system(size: 12))
                        .foregroundColor(.gray)
                    if jobDetail.newFlag == "1" {
                        Image("new")
                            .resizable()
                            .frame(width: 20, height: 20)
                    } else {
                        Image(uiImage: UIImage(named: "new")!.sepiaTone()!)
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                }
                HStack {
                    Text("招聘起始时间:").font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text(DateUtil.format(from : jobDetail.dateFrom,
                                         fromFomart : DateUtil.DATE_FORMAT_yyyyMMdd ,
                                         toFormat: DateUtil.DATE_FORMAT_yyyy_MM_dd) ).font(.system(size: 20))
                }
                HStack {
                    Text("招聘结束时间:").font(.system(size: 12))
                        .foregroundColor(.gray)
                    Text(DateUtil.format(from : jobDetail.dateTo,
                                         fromFomart : DateUtil.DATE_FORMAT_yyyyMMdd ,
                                         toFormat: DateUtil.DATE_FORMAT_yyyy_MM_dd) ).font(.system(size: 20))
                }
                HStack {
                    Text("技能要求:").font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                HStack {
                    Text(jobDetail.detail)
                        .frame(alignment: .leading)
                        .font(.system(size: 15))
                }
                
                HStack {
                    Button(action: {
                        self.saveJobInfo()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5).fill(
                                LinearGradient(gradient: self.SaveAreaGradient, startPoint: .top, endPoint: .bottom)
                                ).frame(width: 100, height: 30)
                            Text("收     藏").foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                    
                    Spacer().frame(maxWidth: 30)
                    Button(action: {
                        self.acceptFlg = true
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5).fill(
                                LinearGradient(gradient: self.SaveAreaGradient, startPoint: .top, endPoint: .bottom)
                                ).frame(width: 100, height: 30)
                            Text("我要应聘").foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                }
            }.frame(width: UIScreen.screenWidth , alignment: .center)
            .sheet(isPresented: self.$acceptFlg) {
                AcceptJobPage(jobId: self.jobDetail.jobId)
            }.alert("您已经收藏了这个工作信息。\n欢迎下次应聘。", isPresented: self.$saveJobsFlg, actions: {})
            
        }.background(Color(hex: 0xF8F8F8))
            .edgesIgnoringSafeArea(.top)
        
    }
    
    
    func saveJobInfo() {
        let req = SaveJobInfoReq()
        service.saveJobInfo(req: req)
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("暂时收藏 error \(error.localizedDescription)")
                case .finished:
                    self.saveJobsFlg = true
                    print("暂时收藏 finished")
                }
            } receiveValue: { (response) in
                print("ResponseBody:\(response)")
            }
            .store(in: &self.subscriptions)
    }
    
    
}

struct JobDetailPage_Previews: PreviewProvider {
    static var previews: some View {
        JobDetailPage(jobDetail: JobDetailDataModel(jobId: "job123",
                                                    jobName: "iOS 工程师",
                                                    salary: 15000,
                                                    companyName: "丰源天下传媒",
                                                    newFlag: "0",
                                                    dateFrom: "20211212", dateTo: "20221212", detail: "5年工作经验\nSwift\njava"))
    }
}
