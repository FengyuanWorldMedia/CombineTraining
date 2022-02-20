// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import SwiftUI
import Combine

struct AcceptJobPage: View {
    /// read-only
    @SwiftUI.Environment(\.isPresented) var isPresented
    /// call self.dismiss.callAsFunction()  to close AcceptJobPage
    @SwiftUI.Environment(\.dismiss) var dismiss
    
    @State private var subscriptions = Set<AnyCancellable>()
    @State private var service = JobService(networkRequest: NativeRequestable())
    
    private let AcceptButtonGradient =  Gradient(stops: [
        Gradient.Stop(color: Color(hex: 0x75DBE8), location: 0.3),
        Gradient.Stop(color:  Color(hex: 0x5AA3BF), location: 0.6)
    ])
    
    var jobId : String
    
    @State private var name = ""
    @State private var mailAddress = ""
    @State private var dateOfAudition = ""
    @State private var experience = ""
    
    @State private var date = Date()
    private let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2021, month: 1, day: 1)
        let endComponents = DateComponents(year: 2121, month: 12, day: 31, hour: 23, minute: 59, second: 59)
        return calendar.date(from:startComponents)!...calendar.date(from:endComponents)!
    }()
    
    @State private var acceptFlg = false
    @State private var checkMsg = ""
    
    let nameCheckSubject = PassthroughSubject<String, Never>()
    let mailCheckSubject = PassthroughSubject<String, Never>()
    let experienceCheckSubject = PassthroughSubject<String, Never>()
    
    @State private var nameCheckFlg = true /// 要求长度必须大于 6 ，小于 10
    @State private var mailCheckFlg = true /// 要求为邮件格式
    @State private var expeCheckFlg = true /// 要求长度必须大于 50，小于 100
    
    var body: some View {
        
        ScrollView(.vertical) {
            Image("recruitment")
                .resizable()
                .frame(width: UIScreen.screenWidth, height: 200)
                .padding(.bottom, 10)
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("验证信息:").font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.leading, 20)
                    Text(self.checkMsg).font(.system(size: 12))
                        .foregroundColor(.red)
                        .padding(.leading, 20)
                }
                HStack() {
                    Text("姓名:").font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.leading, 20)
                    TextField("请输入您的姓名", text: $name, onEditingChanged: {_ in
                       // do nothing.
                    }, onCommit: {
                        // do nothing.
                    })
                    .onChange(of: self.name, perform: { _ in
                        self.nameCheckSubject.send(self.name)
                    })
                    .onTapGesture {
                       // do nothing
                    }
                    .padding(.all, 10)
                    .border(width: 1, edges: [.bottom], color: Color(hex: 0x5AA3BF))
                    .foregroundColor(self.nameCheckFlg ? .black : .red)
                }
                HStack {
                    Text("邮箱:").font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.leading, 20)
                    TextField("请输入您的邮箱", text: $mailAddress, onEditingChanged: {_ in
                        // do nothing
                    }, onCommit: {
                        // do nothing
                    })
                    .onChange(of: self.mailAddress, perform: { _ in
                        self.mailCheckSubject.send(self.mailAddress)
                    })
                    .onTapGesture {
                        // do nothing
                    }
                    .padding(.all, 10)
                    .border(width: 1, edges: [.bottom], color: Color(hex: 0x5AA3BF))
                    .background(self.mailCheckFlg ? Color(hex: 0xF8F8F8) : Color(hex: 0xEFDBD7))
                    
                }
                HStack {
                    DatePicker(
                          selection: $date,
                          in: self.dateRange,
                          displayedComponents: [.date , .hourAndMinute]
                    ) {
                       Text("面试预约时间").font(.system(size: 12)).foregroundColor(.gray)
                    }.frame(width: UIScreen.screenWidth * 0.8 , alignment: .center)
                        .padding(.leading, 20)
                }
                
                VStack {
                    Text("个人经验简介:").font(.system(size: 12))
                        .foregroundColor(.gray)
                        .padding(.leading, 20)
                    TextEditor(text: self.$experience)
                        .frame(height: 150)
                        .border(width: 2, edges: [.top], color: Color(hex: 0x5AA3BF))
                        .border(width: 2, edges: [.leading], color: Color(hex: 0x5AA3BF))
                        .onChange(of: self.experience) { _ in
                            self.experienceCheckSubject.send(self.experience)
                        }
                        .padding(.top, 10)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .background(self.expeCheckFlg ? Color(hex: 0xF8F8F8) : Color(hex: 0xEFDBD7))
                }
                 
                HStack {
                    Button(action: {
                        self.acceptJob()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5).fill(
                                LinearGradient(gradient: self.AcceptButtonGradient, startPoint: .top, endPoint: .bottom)
                                ).frame(width: 100, height: 30)
                            Text("应聘").foregroundColor(.white)
                                .font(.system(size: 15))
                        }
                    }
                }.frame(width: UIScreen.screenWidth , alignment: .center)
                
            }.frame(width: UIScreen.screenWidth , alignment: .center)
        }.background(Color(hex: 0xF8F8F8))
        .edgesIgnoringSafeArea(.top)
        .onTapGesture {
            endEditing(true)
        }
        .alert(isPresented: self.$acceptFlg) {
            Alert(
                title: Text(""),
                message: Text("您已经应聘了此岗位。\n请您等待该公司的人力资源部门联系。"),
                dismissButton: .default(Text("知道了"), action: {
                    self.dismiss.callAsFunction()
                })
            )
        }
        .onAppear {
            self.nameCheck()
            self.mailCheck()
            self.experienceCheck()
        }
    }
    
    func endEditing(_ force: Bool) {
        UIApplication.shared.keyWindow?.endEditing(force)
    }
    
    func acceptJob() {
        if !(self.name.count > 0 && self.nameCheckFlg &&
            self.mailAddress.count > 0 && self.mailCheckFlg &&
            self.experience.count > 0 && self.expeCheckFlg) {
            self.checkMsg = "请您输入正确信息"
            return
        }
        self.checkMsg = ""
        print("应聘 jodId :\(self.jobId)")
        var req = AcceptJobReq()
        let acceptReqBody = AcceptJobReqBody(jobId: self.jobId,
                                             myName:  self.name,
                                             mailAddress: self.mailAddress,
                                             date: DateUtil.format(date: self.date, format: DateUtil.DATE_FORMAT_TIMESTAMP2) ,
                                             apeal: self.experience)
        req.body = acceptReqBody
        service.acceptJob(req: req)
            .sink { (completion) in
                switch completion {
                case .failure(let error):
                    print("应聘 error \(error.localizedDescription)")
                case .finished:
                    self.acceptFlg = true
                    print("应聘 finished")
                }
            } receiveValue: { (response) in
                print("ResponseBody:\(response)")
            }
            .store(in: &self.subscriptions)
    }
    
    func nameCheck() {
        let debounce = nameCheckSubject.debounce(for: .seconds(3.0), scheduler: DispatchQueue.main)
        debounce.sink(receiveCompletion: { completion in
            print("throttle completion: \(completion)")
        }, receiveValue: { value in
            print("name:\(self.name)")
            self.nameCheckFlg = StringUtil.sizeCheck(string: value, minSize: 6 , maxSize : 15)
        }).store(in: &subscriptions)
    }
    
    func mailCheck() {
        let debounce = mailCheckSubject.debounce(for: .seconds(3.0), scheduler: DispatchQueue.main)
        debounce.sink(receiveCompletion: { completion in
            print("throttle completion: \(completion)")
        }, receiveValue: { value in
            print("mail:\(self.mailAddress)")
            self.mailCheckFlg = StringUtil.isValidEmailAddress(emailAddressString: value)
        }).store(in: &subscriptions)
    }
    
    func experienceCheck() {
        let debounce = experienceCheckSubject.debounce(for: .seconds(3.0), scheduler: DispatchQueue.main)
        debounce.sink(receiveCompletion: { completion in
            print("throttle completion: \(completion)")
        }, receiveValue: { value in
            print("experience:\(self.experience)")
            self.expeCheckFlg = StringUtil.sizeCheck(string: value, minSize: 10 , maxSize : 100)
        }).store(in: &subscriptions)
    }
}
 
struct AcceptJobPage_Previews: PreviewProvider {
    static var previews: some View {
        AcceptJobPage(jobId: "testJobID")
    }
}
