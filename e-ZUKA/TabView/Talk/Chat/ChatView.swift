//
//  ChatView.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/15.
//

import SwiftUI
import RealmSwift
import Combine

class ChatRealm {
    
    static let shared: ChatRealm = .init()
    
    var config: Realm.Configuration
    private var realm: Realm
    
    private init() {
        config = Realm.Configuration()
        realm = try! Realm(configuration: config)
    }

    func messages(target: Int) -> [RealmMessage] {
        let predicate = NSPredicate(format: "target = %@", NSNumber(value: target))
        return Array(realm.objects(RealmMessage.self).filter(predicate).sorted(byKeyPath: "date"))
    }
    
    func add(_ message: RealmMessage) {
        try! realm.write{
            realm.add(message)
        }
    }
}

struct ChatView: View {
    
    @State var typingMessage: String = ""
    @StateObject var chatHelper: ChatHelper = .init()
    
    @State private var scrollTarget: Int? = nil
    @State private var keyboardHeight: CGFloat = 0

    private var target: Int
    private var from: Int
    private var targetName: String = ""
    
    
    // 相手のデータ表示用フラグ
    @State var showingFriendData: Bool = false

    
    /// 初期化処理
    /// - Parameters:
    ///   - target: 相手のID
    ///   - from: 自分のID
    ///   - targetName: 相手の名前
    init(target: Int, from: Int, targetName: String) {
        self.target = target
        self.from = from
        self.targetName = targetName
    }
    
    var scrollView: some View {
        ScrollView(.vertical) {
            ScrollViewReader { scrollView in
                LazyVStack(spacing: 0) {
                    ForEach(chatHelper.realTimeMessages) { message in
                        ChatDetailView(messages: message)
                    }
//                    .onChange(of: scrollTarget) { newTarget in
//                        withAnimation {
//                            scrollView.scrollTo(newTarget, anchor: .bottom)
//                        }
//                    }
//                    .onChange(of: keyboardHeight) { newHeight in
//                        if scrollTarget != nil {
//                            withAnimation {
//                                scrollView.scrollTo(scrollTarget, anchor: .bottom)
//                            }
//                        }
//                    }
//                    .onReceive(chatHelper.$realTimeMessages) { output in
//                        scrollView.scrollTo(output.last?.date, anchor: .bottom)
//                    }
                }
            }

            
        }

    }
    
    var body: some View {
        
        VStack {
            scrollView
                .onAppear{
                    chatHelper.setup(target: target)
                }


            HStack {
                TextField("Message...", text: $typingMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: CGFloat(30))
                Button(action: sendMessage) {
                    Text("Send")
                }
            }
            .frame(minHeight: CGFloat(50)).padding()
        }
        .navigationTitle(targetName)
//        .toolbar(content: {
//            ToolbarItem(placement: .navigationBarTrailing){
//                                Button {
//                                    showingFriendData = true
//                                } label: {
//                                    Image(systemName: "person.crop.circle.badge.exclamationmark")
//                                }
//                            }
//        })
//        .sheet(isPresented: $showingFriendData) {
//            PopupView(viewModel: PopuoViewModel(friendID: String(target)))
//        }
        
    }
    
    func sendMessage() {
        if !typingMessage.isEmpty {
            let message: RealmMessage = .init()
            message.message = typingMessage
            message.from = from
            message.target = target
            message.date = DateFormatter.japaneseNowDate
            chatHelper.sendMessage(message)
            typingMessage = ""
        }
    }

}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}


struct ChatDetailView: View {
    
    
    var messages: RealmMessage
    var isCurrentUser: Bool {
        if UserData.shared.myId != messages.target {
            return true
        } else {
            return false
        }
    }
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
            if !isCurrentUser {
                ContentMessageView(contentMessage: messages.message,
                                   isCurrentUser: isCurrentUser)
                Spacer()
            } else {
                Spacer()
                ContentMessageView(contentMessage: messages.message,
                                   isCurrentUser: isCurrentUser)
            }
            
        }
        .padding(.all, 20.0)
    }
    
}




struct ContentMessageView: View {
    var contentMessage: String
    var isCurrentUser: Bool
    
    var body: some View {
        Text(contentMessage)
            .padding(10)
            .foregroundColor(isCurrentUser ? Color.white : Color.black)
            .background(isCurrentUser ? Color.blue : Color(UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)))
            .cornerRadius(10)
    }
}
