//
//  SettingView.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/06.
//

import SwiftUI

struct SettingView: View {
    
    @State var isNotification: Bool = false
    @State var userName: String = ""
 
    init () {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                List{
                    
                    Section {
                        TextField("ニックネーム", text: $userName)
                    } header: {
                        Text("アカウント")
                    }
                    
                    Section {
                        Toggle(isOn: $isNotification) {
                            Text("通知")
                        }
                    } header: {
                        Text("チャット通知")
                    }
                    
                }
            }
            
            
            

            VStack {
                Spacer()
                    .frame(maxHeight: .infinity)

                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 10)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("GradientStartColor"), Color("GradientEndColor")]), startPoint: .top, endPoint: .bottom))
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
