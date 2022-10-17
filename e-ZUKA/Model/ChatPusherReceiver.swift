//
//  ChatPusherReceiver.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/15.
//

import Foundation
import PusherSwift

/// インスタンスが生きている間はモニタリングをしつづけるPusherReceiver
class ChatPusherReceiver {
    
    let pusher: Pusher
    // 接続先チャンネル
    let channel: String
    
    init(channel: String) {
        
        self.channel = channel
        
        // pusherオブジェクトの生成
        guard let cruster = properties["PusherCruster"],
        let appKey = properties["PusherAppKey"] else {
            // FIXME: 正しいエラー処理に変更する
            fatalError()
        }
        
        let options = PusherClientOptions(host: .cluster(cruster))
        pusher = Pusher(key: appKey, options: options)
        
        if pusher.connection.connectionState != .connected {
            // モニタリング開始
            startPusherMonitoring(for: channel)
        }
        
    }
    
    deinit {
        // 接続していたら切る
        if pusher.connection.connectionState == .connected {
            pusher.disconnect()
        }
    }
    
    private func startPusherMonitoring(for channelName: String) {
        let channel = pusher.subscribe(channelName: channelName)
        
        guard let eventName = properties["PusherEventName"] else {
            // FIXME: 正しいエラー処理に変更する
            fatalError()
        }
        
        let _ = channel.bind(eventName: eventName) { event in
            if let data = event.data {
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(.iso8601Full)
                    let message = try decoder.decode(ReceiveMessageData.self, from: Data(data.utf8))
                    
                    // 受信時の処理
                    let notification = Notification(name: .receiveMessage, userInfo: ["message" : message])
                    NotificationCenter.default.post(notification)
                } catch {
                    // FIXME: 正しいエラー処理に変更する
                    print(error)
                    fatalError()
                }
            }
        }
        pusher.connect()
    }
    
}


extension Notification.Name {
    static let receiveMessage = Notification.Name("receiveMessage")
}
