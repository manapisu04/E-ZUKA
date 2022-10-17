//
//  MessageData.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/15.
//

import Foundation

struct SendMessageData: Encodable {
    let sessionToken: String
    let chat: Chat
    
    struct Chat: Encodable {
        let message: String
        let target: Int
        let from: Int
    }
}


struct ReceiveMessageData: Decodable {
    let id: String?
    
    let message: String
    // 宛先ユーザのID
    let target: Int
    // 送信元ユーザのID
    let from: Int
    let time: Date
}

struct ReceiveChatList: Codable {
    let status: Int
    let chats: [ChatDetails]
    
    struct ChatDetails: Codable {
        let id: Int
        let icon, name: String
        let message: Message
        
        struct Message: Codable {
            let message, time: String
            let from, chatID, target: Int

            enum CodingKeys: String, CodingKey {
                case message, time, from
                case chatID = "chat_id"
                case target
            }
        }
    }
}


extension DateFormatter {
    // クロージャーを書いて()で実行してreturnした値をformatterに入れている処理
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        // 2022-08-29T08:38:54.116585Z
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 9)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let japaneseNowDate: Date = {
        let timezone = TimeZone.current
         
        let timezoneSecond = timezone.secondsFromGMT()
         
        return Date(timeIntervalSinceNow: Double(timezoneSecond))
        
    }()
}



struct PartialMessages: Codable {
    let status: Int
    let messages: [Message]
    
    struct Message: Codable {
        let message, time: String
        let from, chatID, target: Int

        enum CodingKeys: String, CodingKey {
            case message, time, from
            case chatID = "chat_id"
            case target
        }
    }

}

