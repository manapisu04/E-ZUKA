//
//  LoginView.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/04.
//

import SwiftUI

struct LoginView: View {
    
    enum FocusField: Hashable {
            case user, password, username
    }
    
    
    
    @State private var loginEmail: String = "19jz0101@jec.ac.jp"
    @State private var password: String = "jec"
    @State private var username: String = ""
    @State private var isButtonDisable = false
    
    @FocusState private var focusedField: FocusField?
    // Email or PassWordが入力されていなかった時にtrueになる
    @State var faultRogin: Bool = false
    @StateObject var loginViewModel = LoginViewModel()

    
    
    
    var body: some View {
        
        ZStack {
            
            BackgroundView()
            
            VStack {
                Spacer()
                    .frame(height: UIScreen.main.bounds.height * 0.1)
                
                Text("DISCOVER!")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .shadow(color: Color("Shadow"),radius: 2)
                
                Spacer()
                
                TextField("hogehoge`@`discover.com", text: $loginEmail)
                    .textFieldStyle(
                        GradientTextFieldBackground(
                            systemImageString: "envelope"
                        )
                    )
                    .padding([.top], 20)
                    .padding([.leading, .trailing], 40.0)
                    .focused($focusedField, equals: .user)
                // Focuseをメールアドレスに
                    .onTapGesture {
                        focusedField = .user
                    }
                    
                
                TextField("パスワード", text: $password)
                    .textFieldStyle(
                        GradientTextFieldBackground(
                            systemImageString: "key"
                        )
                    )
                    .keyboardType(.asciiCapable)
                    .padding([.top], 20)
                    .padding([.leading, .trailing], 40.0)
                    .focused($focusedField, equals: .password)
                // Focuseをパスワードに
                    .onTapGesture {
                        focusedField = .password
                    }
                
                TextField("ユーザーネーム", text: $username)
                    .textFieldStyle(
                        GradientTextFieldBackground(
                        systemImageString: "person"
                        )
                    )
                    .padding([.top], 20)
                    .padding([.leading, .trailing], 40.0)
                    .focused($focusedField, equals: .username)
                    .onTapGesture {
                        focusedField = .username
                    }
                
                Text(loginViewModel.errorMessage)
                    .foregroundColor(Color("ErrorColor"))
                CustomButton(label: "アカウント作成") {
                    // サーバにログイン送る もし何も入力していなかったらtryしないで、エラーダイアログを表示する
                    if loginEmail == "" || password == "" || username == "" {
                        // 本当はこんな書き方良くないんだろうけど、
                        loginViewModel.errorMessage = "未入力項目があります"
                        
                    } else if loginEmail == "" {
                        loginViewModel.errorMessage = "e-mailを入力してください"
                    } else if password == "" {
                        loginViewModel.errorMessage = "passwordを入力してください"
                    } else if username == "" {
                        loginViewModel.errorMessage = "usernameを入力してください"
                    } else {
                        try? loginViewModel.rogging(mail: loginEmail, passWord: password)
                    }
                    
                }
                
                
                
                Spacer()
            }
            
            // ProgressView
            if loginViewModel.isAccessing {
                ProgressView()
            }
        }
        .onTapGesture {
            focusedField = nil
        }
        .fullScreenCover(isPresented: $loginViewModel.roginBool) {
            TabMainView()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            BackgroundView()
            LoginView()
        }
    }
}
