//
//  ChatTransceiver.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/15.
//

import Foundation
import Combine

class ChatTransceiver {
    
    let pusherReceiver: ChatPusherReceiver
    // TODO: channelに変更があったら修正するように
    init(channel: String = "my-channel") {
        pusherReceiver = ChatPusherReceiver(channel: channel)
    }
    
    /// メッセージを送信する
    /// - Parameter messageData: 送信データ
    func sendMessage(_ messageData: SendMessageData) async throws{
        // メッセージを送信する処理
        
        let json = JSONEncoder()
        json.keyEncodingStrategy = .convertToSnakeCase
        guard let body = try? json.encode(messageData) else {
            // FIXME: 後で正しいエラーにする
            fatalError()
        }
        print(String(data: body, encoding: .utf8)!)
        
        let request = makeRequest(propertyKey: "SendMessageURL", body: body, method: .post)
        
        let (_, urlResponse) = try await URLSession.shared.data(for: request)
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            // FIXME: 適切なエラーハンドリングをしてほしい
            fatalError()
        }
        
        // ステータスコードチェック
        guard (200..<400).contains(httpURLResponse.statusCode) else {
            // FIXME: ステータスコードが200〜399以外ならエラーにしてほしい
            print("ここ: \(httpURLResponse.statusCode)")
            fatalError()
        }
        // FIXME: メッセージが送れたらステータスを送信済みにするようにする
        // dataはnullという文字になっている

        
    }
    
    
    /// メッセージを取得する（ページを開いた時に自動で取得する）
    /// - Returns: メッセージ
    func fetchMessage(with target: Int, after lastDate: Date) async throws -> [ReceiveMessageData] {
        
        // FIXME: 本当はRealmの一番最後の更新日を指定したい
        let formatter = DateFormatter.iso8601Full
        //let date = Date(timeIntervalSinceNow: -60 * 60 * 24)
        
        let queryItems: [URLQueryItem] = [.init(name: "session_token", value: UserData.shared.id),
                                          .init(name: "id", value: String(target)),
                                          .init(name: "time", value: formatter.string(from: lastDate))
                                          ]
        let request = makeRequest(propertyKey: "PartialMessageListURL",queryItems: queryItems, method: .get)

        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            // FIXME: 適切なエラーハンドリングをしてほしい
            fatalError()
        }
        
        
        // ステータスコードチェック
        guard (200..<400).contains(httpURLResponse.statusCode) else {
            // FIXME: ステータスコードが200〜399以外ならエラーにしてほしい
            fatalError()
        }
        
        if let parialMessages = try? JSONDecoder().decode(PartialMessages.self, from: data) {
            
            var messages: [ReceiveMessageData] = []
            for parialMessage in parialMessages.messages {
                messages.append(ReceiveMessageData(id: String(parialMessage.chatID), message: parialMessage.message, target: parialMessage.target, from: parialMessage.from, time: formatter.date(from: parialMessage.time) ?? .init(timeIntervalSince1970: 0)))
            }
            
            return messages
        }

        return []
    }
    
    
    
    /// チャットサーバへのリクエストを作成する
    /// - Parameters:
    ///   - body: 送信するメッセージ（JSONをEncodeしたもの）
    ///   - method: HTTPMethodが指定できる。デフォルトGET
    /// - Returns: URLRequest。出来なかったらfatalが正しいのかどうかは謎。直してほしい
    private func makeRequest(propertyKey: String, body: Data? = nil, queryItems: [URLQueryItem]? = nil, method: HTTPMethod = .get) -> URLRequest {
        
        guard let lambdaURL = properties[propertyKey],
              var url = URL(string: lambdaURL) else {
            // FIXME: 後で正しいエラーにする
            fatalError()
        }
        
        if method == .get {
            // 本当はきちんとパラメータを作るようにしたいが今回はこれでいく
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            
            if let queryItems = queryItems {
                urlComponents?.queryItems = queryItems
            }
            
            url = urlComponents?.url ?? url

        }
        
        var request = URLRequest(url: url)
        
        if body != nil, method == .post {
            request.httpMethod = method.value
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        
        
        return request
    }
}

// MARK: - ここで使うenum系はここにまとめておいて
enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    
    var value: String {
        self.rawValue
    }
}
