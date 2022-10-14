//
//  WorkOnView.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/12.
//

import SwiftUI

struct WorkOnView: View {
    
    let function : String
    
    @State var sendLogin: Bool = false
    
    var body: some View {
        VStack {
            BodyLabel("「\(function)」を使用するためには", size: 18)
            BodyLabel("アカウント登録が必要です。", size: 18)
                .padding(5)
            
            TranslucentButton(label: "ログインに進む") {
                sendLogin.toggle()
            }
        }
        .fullScreenCover(isPresented: $sendLogin) {
            LoginView()
        }
    }
}

struct WorkOnView_Previews: PreviewProvider {
    static var previews: some View {
        WorkOnView(function: "チャット機能")
    }
}
