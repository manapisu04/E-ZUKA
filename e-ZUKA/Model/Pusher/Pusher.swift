//
//  Pusher.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/15.
//

import Foundation
import PusherSwift

class PusherTest  {
    // constants //
    private let PUSHER_APP_KEY : String = "99bac0878611b4579902"
    private let PUSHER_CRUSTER : String = "ap3"
    let PUSHER_LAMBDA_URL : String = "https://hvja2dw6ihpaeqoemkldhsghdy0uyefo.lambda-url.us-west-2.on.aws/"
    
    // variables //
    private var pusher : Pusher
    
    static let shared: PusherTest = .init()
    
    // constructor/destructor //
    // 何度も何度も双方向通信始めちゃったらやばいのでシングルトン！
    private init() {
        print("設定するよ")
        // pusherオブジェクトの生成
        let options = PusherClientOptions(
            host: .cluster(self.PUSHER_CRUSTER)
        )
        self.pusher = Pusher(key: PUSHER_APP_KEY, options: options)
        startPusherMonitoring()
    }
    deinit {
        self.pusher.disconnect()
    }
    
    
    
    // private methods //
    /// HTTP送信オブジェクトの生成
    func ajax(url : URL, method : String, body : Data?) -> URLSessionDataTask {
        var request = URLRequest(url : url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("request 完了")
            guard let data = data else {
                return
            }
            do {
                let object = try JSONSerialization.jsonObject(with: data, options: [])
                print(object)
            } catch let error {
                print(error)
            }
        }
        return task
    }
    
    /// 受信用に Pusher channel に接続する
    func startPusherMonitoring() {
        // チャンネルをサーバに合わせる
        let channel = self.pusher.subscribe("my-channel")
        print("initialize pusher...")

        // イベント発生を監視
        let _ = channel.bind(
            eventName: "my-event",
            eventCallback: { (event: PusherEvent) in
                print("my-event発生")
                if let data = event.data {
                    do {
                        // String -> JSON 変換
                        let res = try JSONDecoder().decode(MessageData.self, from: Data(data.utf8))
                        // ターゲットが自分かどうか。メアドで
                        if (res.target == UserData.shared.mail) {    // 宛先チェック。ホントはこんなことせずにp2pごとにチャンネル名を変えるべき
                            // 宛先が自分なら表示
                            print(res.from + "からのメッセージを受信")
                            print(res.message)
                            // TODO: Realm
                        } else {
                            print("自分宛じゃないので無視")
                        }
                    } catch {
                        print(error)
                    }
                }
            })
        
        // 接続
        pusher.connect()
    }
}
