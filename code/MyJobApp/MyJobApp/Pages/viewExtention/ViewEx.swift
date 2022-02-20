// Created by 丰源天下 on 2021/11/30.
// Copyright © 2021 Suzhou Fengyuan World Media. All rights reserved.

import Foundation
import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .leading)
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var moveUpAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom)
        //  .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .bottom)
        //  .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}


final class ScreenInfo: ObservableObject {
    @Published var subscriptionExpireAt = "" 
    @Published var isShow = false
    @Published var displayView: AnyView = AnyView(EmptyView())
    @Published var showError = false
    @Published var errorMessage = ""
}

struct ScreenMod: ViewModifier {
    var isShow:Binding<Bool>
    var topView:AnyView
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if isShow.wrappedValue == true {
                topView.edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct TopViewModifier: ViewModifier {
    var isShow:Binding<Bool>
    var topView:AnyView
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            if isShow.wrappedValue == true {
                topView
                    .edgesIgnoringSafeArea(.all)
                    .transition(.moveUpAndFade)
            }
        }
    }
}

extension View {
    
    public func bindingTopScreen(isShow:Binding<Bool>, topView:AnyView) -> some View {
        self.modifier(ScreenMod(isShow: isShow, topView: topView))
    }
    
    public func bindingTaionInputScreen(isShow:Binding<Bool>, topView:AnyView) -> some View {
        self.modifier(TopViewModifier(isShow: isShow, topView: topView))
    }
}
