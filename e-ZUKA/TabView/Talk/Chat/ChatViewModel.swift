//
//  ChatViewModel.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/15.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var chatData: [Message] = []
    
    /// Pusher にメッセージ送信
    func send(message: String, to opponentID: String) -> Bool {
        
        let messageData: MessageData = .init(message: message, target: opponentID, from: UserData.shared.id)
        
        print("sendMessage start")
        guard let url = URL(string: PusherTest.shared.PUSHER_LAMBDA_URL) else {
            print("URLエラー")
            return false
        }
        
        guard let httpBody = try? JSONEncoder().encode(messageData) else {
            print("JSON変換エラー")
            return false
        }
        
        // HTTPリクエスト生成
        PusherTest.shared.ajax(url: url, method: "POST", body: httpBody).resume()
        return true
    }
}
