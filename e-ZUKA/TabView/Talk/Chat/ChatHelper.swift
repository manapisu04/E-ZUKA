//
//  ChatHelper.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/14.
//

import Combine
import Foundation

class ChatHelper: ObservableObject {
    var didChange: PassthroughSubject<RealmMessage, Never> = .init()
    var transceiver: ChatTransceiver = .init()

//    var session: String = UserDefaults.standard.string(forKey: "currentUserSession") ?? ""
    @Published var realTimeMessages: [RealmMessage] = []
    
    var cancellable: [AnyCancellable] = []
    
    var chatRealm: ChatRealm = ChatRealm.shared
    
    /// 初期化処理
    /// - Parameter realmMessages: realmから受け取った値
    func setup(target: Int) {

        // realmから受け取った値
        realTimeMessages = chatRealm.messages(target: target)
        //print(realTimeMessages)
        // realmから受け取った値に未受信の値を受け取る
        // fetchMessage内でRealm登録とrealTimeMessagesは更新されているので、ここでは入れない
        if realTimeMessages.isEmpty {
            fetchMessage(with: target, after: Date(timeIntervalSince1970: 0))
        } else {
            fetchMessage(with: target, after: realTimeMessages.last!.date)
        }
        print(realTimeMessages)
        cancellable.append(
            // 変更があったらRealmに登録する
            didChange.sink { [self] message in
                chatRealm.add(message)
            }
        )
        
        // callback
        // Pusherから受信した値を登録するためのcallback
        cancellable.append(
            NotificationCenter.default.publisher(for: .receiveMessage, object: nil)
                .sink { notification in
                    if let info = notification.userInfo,
                       let message = info["message"] as? ReceiveMessageData {
                        if UserData.shared.myId == message.target {
                            let addMessage = RealmMessage()
                            addMessage.target = message.target
                            addMessage.from = message.from
                            addMessage.message = message.message
                            addMessage.date = message.time
                            // 二重の元？
                            self.receiveMessage(addMessage)
                        }
                    }
                }
        )
        
        
    }
    
    
    func sendMessage(_ chatMessage: RealmMessage) {
        realTimeMessages.append(chatMessage)
        didChange.send(chatMessage)
        
        let sendMessageData = SendMessageData(sessionToken: UserData.shared.id, chat: SendMessageData.Chat(message: chatMessage.message, target: chatMessage.target, from: chatMessage.from))
        Task.detached {
            do {
                // 送っても何も戻ってこない
                _ = try await self.transceiver.sendMessage(sendMessageData)
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func receiveMessage(_ chatMessage: RealmMessage) {
        realTimeMessages.append(chatMessage)
        didChange.send(chatMessage)
    }
    
    // 未受信の情報を登録する
    func fetchMessage(with target: Int, after lastDate: Date) {
        Task.detached { [self] in
            print(lastDate)
            print(Date(timeInterval: 1, since: lastDate))
            let chats = try await self.transceiver.fetchMessage(with: target, after: Date(timeInterval: 1000, since: lastDate))
            for chat in chats {
                let message: RealmMessage = .init()
                message.message = chat.message
                message.from = chat.from
                message.target = chat.target
                message.date = chat.time
                
                await MainActor.run {
                    realTimeMessages.append(message)
                    self.didChange.send(message)
                }
                
                
            }
        }
        
        
    }
}

