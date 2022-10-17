//
//  LoginViewModel.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/12.
//

import Foundation
import CryptoKit


enum RequestStatus {
    case unexecuted         // 未実行
    case success            // 成功
    case midway             // 途中
    case failed(Error)      // 失敗
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        } else {
            return false
        }
    }
}


class LoginViewModel: ObservableObject {
    @Published var status: RequestStatus
    
    @Published var isAccessing: Bool = false
    
    @Published var errorMessage: String = " "
    
    
    // LoginViewでTabViewへ遷移する用
    var roginBool: Bool = false
    
    // statusを変更。
    init() {
        status = .unexecuted
    }
    
    func RoginRequest(mail: String, passWord: String, name: String) {
        do{
            try rogging(mail: mail, passWord: passWord, name: name)
        } catch {
            status = .failed(error)
        }
    }
    
    func rogging(mail: String, passWord: String, name: String) throws {
        guard let url = URL(string: "https://jeyj3f6w6s7bpmesczdfxgs5bu0llvox.lambda-url.us-west-2.on.aws/") else {
            print("urlが間違ってる")
            throw JECError.urlError
        }
        
        Task {
            let passwordData = passWord.data(using: .utf8)!
            let hashData = SHA256.hash(data: passwordData)
            let hashString = hashData.hexStr
            
            print("This is Hash      \(hashString)")
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let encoder = JSONEncoder()
            let loginRequest = LoginRequest(mail: mail, password: hashString, user_name: name)
            guard let jsonValue = try? encoder.encode(loginRequest) else {
                print("エンコードしっぱい！")
                return
            }
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = jsonValue
            print(jsonValue)
            DispatchQueue.main.async {
                self.isAccessing = true
            }
            
            let result = await Fetcher.fetch(from: request)
            
            
            switch result {
                // 失敗時
            case .failure(let error):
                print("しっぱい")
                print(error)
                // メインスレッドに戻す
                await MainActor.run {
                    status = .failed(JECError.fetchError)
                    isAccessing = false
                    errorMessage = "ログインに失敗しました。\nEmailとパスワードを確認してください。"
                }
                
                // 成功時
            case .success(let data):
                
                do {
                    let result = try JSONDecoder().decode(LoginResponce.self, from: data)
                    
                    await MainActor.run {
                        print("success")
                        
                        // もし通信が成功して、jsonデータのstatusが200（成功）だったら、
                        if result.status == 200 {
                            print("resultStatus == 200")
                            // 画面遷移用
                            roginBool = true
                            UserData.shared.isAccount = true
                            // UserDefaultsにuserNameにuserNameを入れる
                            UserData.shared.userName = name
                            
                        } else {
                            print("resultStatus ≠ 200")
                        }
                        print("status = .success")
                        
                        isAccessing = false
                        
                        status = .success
                        // session_token
                        UserData.shared.id = result.session_token
                        print(UserData.shared.id)
                        // 自分のId
                        UserData.shared.myId = result.id
                    }
                    
                } catch {
                    print(error)
                    await MainActor.run {
                        print("decode catch")
                        
                        isAccessing = false
                        
                        // 失敗したら失敗のステータスに変更
                        status = .failed(JECError.parseError)
                    }
                }
            }
            
            
        }
    }
    
    
    
}

// hash化に必要
extension Digest {
    private var bytes: [UInt8] { Array(makeIterator()) }
    var hexStr: String {
        // 小文字のxにするとhash化された文字列のアルファベットが小文字で表示されるようになる。
        bytes.map { String(format: "%02x", $0) }.joined()
    }
}
