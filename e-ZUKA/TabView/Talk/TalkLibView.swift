//
//  TalkLibView.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/06.
//

import SwiftUI

struct TalkLibView: View {
    
    @ObservedObject var viewModel = TalkViewModel()
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            if UserData.shared.isAccount == false {
                WorkOnView(function: "チャット機能")
            } else {
                
            
                    ZStack {
                        List {
                            ForEach(viewModel.displayChatList) { data in
                                NavigationLink {

                                    ChatView(target: data.id, from: UserData.shared.myId, targetName: data.name)
                                } label: {
                                    TalkListCell(icon: data.icon, friendName: data.name, lastMessage: data.message.message ?? "メッセージを送ってみよう！", time: data.message.time ?? "")
                                        .frame(height: UIScreen.main.bounds.height / 9)
                                }
                            }
                        }
                        .listStyle(PlainListStyle())
                        
                        if viewModel.isAccsessing {
                            ProgressView()
                        }
                        
                    }
                        
                
            }
            
            VStack {
                Spacer()
                    .frame(maxHeight: .infinity)
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 10)
                    .background(.gray)
            }
        }
    }
}


struct TalkLibView_Previews: PreviewProvider {
    static var previews: some View {
        TalkLibView()
    }
}
