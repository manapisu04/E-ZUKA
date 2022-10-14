//
//  TalkViewModel.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/12.
//

import Foundation

class TalkViewModel: ObservableObject {

    // 一覧を表示するための配列
    @Published var displayChatList: [ChatData] = []
    
    @Published var isAccsessing: Bool = false
    
    init() {
        do {
            try getChatList()
            print("try getChatList()")
        } catch {
            print("getChatListでエラー")
        }
    }
    
    // チャット一覧を取得する関数
    func getChatList() throws {
        guard let url = URL(string: "https://pnveco5lvd6v3u4xnozosfa3au0shrjx.lambda-url.us-west-2.on.aws/") else {
            print("getChatListでurlが間違っています")
            throw JECError.urlError
        }
        
        // パラメータの作成
        let queryItems: [URLQueryItem] = [.init(name: "session_token", value: UserData.shared.id)]
        
        // URLComponentsの作成
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return
        }
        components.queryItems = queryItems
        guard let queryStringAddedUrl = components.url else {
            return
        }
        
        print(queryStringAddedUrl)
        
        Task {
            let request = URLRequest(url: queryStringAddedUrl)
            print("reqいけてる")
            DispatchQueue.main.async {
                self.isAccsessing = true
            }
            let result = await Fetcher.fetch(from: request)
            
            switch result {
            case .failure(let error):
                print("getChatListでエラー。\(error)")
                // アラート表示？？
                
                await MainActor.run {
                    isAccsessing = false
                }
                
            case .success(let data):
                do {
                    let result = try JSONDecoder().decode(ChatList.self, from: data)
                    
                    await MainActor.run {
                        print("success.getChatList")
                        
                        if result.status == 200 {
                            print("resultStatus == 200")
                            
                            
                            // 一覧表示用のstructの配列にデータを格納する
                            for datas in result.chats {
                                displayChatList.append(datas)
                            }
                            
                        }
                        
                        isAccsessing = false
                    }
                    
                } catch {
                    print(error)
                    print("でこーどえらー！")
                    
                    await MainActor.run(body: {
                        isAccsessing = false
                    })
                }
            }
        }
    }
}


struct ChatList: Decodable {
    let status: Int
    let chats: [ChatData]
}

struct ChatData: Decodable, Identifiable {
    let id: Int
    let icon: String
    let name: String
    let message: LatestMessage
}

struct LatestMessage: Decodable {
    let message: String?
    let time: String?
}

