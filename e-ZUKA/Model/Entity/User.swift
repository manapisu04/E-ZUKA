//
//  User.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/12.
//

import Foundation

// FIXME: ユーザデフォルトにしてもいいんじゃないかなぁ
/// 趣味の数保持する用。
class UserData {
//    var id: String {
//        didSet(id) {
//            UserDefaults.standard.set(id, forKey: "id")
//        }
//    }
    
    /// アカウント作成済みかどうか
    var isAccount: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isAccount")
        }
        set(isAccount) {
            UserDefaults.standard.set(isAccount, forKey: "isAccount")
        }
    }
    
    /// セッショントークン
    var id: String {
        get {
            UserDefaults.standard.string(forKey: "id") ?? ""
        }
        set (id) {
            UserDefaults.standard.set(id, forKey: "id")
//            print(UserDefaults.standard.string(forKey: "id"))
        }
    }
    
    var finishedPutData: Bool {
        get {
            UserDefaults.standard.bool(forKey: "finishedPutData")
        }
        set(finishedPutData) {
            UserDefaults.standard.set(finishedPutData, forKey: "finishedPutData")
        }
    }
    
    /// 自分のID
    var myId: Int {
        get {
            UserDefaults.standard.integer(forKey: "myId")
        }
        set (myId) {
            UserDefaults.standard.set(myId, forKey: "myId")
//            print(UserDefaults.standard.string(forKey: "myId"))
        }
    }
    
    var mail: String {
        didSet(mail) {
            UserDefaults.standard.set(mail, forKey: "mail")
        }
    }
    
    var userName: String {
        get {
            UserDefaults.standard.string(forKey: "userName") ?? ""
        }
        set (userName) {
            UserDefaults.standard.set(userName, forKey: "userName")
        }
    }
    
    static let shared: UserData = .init()
    private init() {
        print("よみこみよみこみ")
        
        mail = UserDefaults.standard.string(forKey: "mail") ?? ""
        if let readID = UserDefaults.standard.string(forKey: "id") {
            id = readID
        }
        
        print(id)
    }
    var hobbiesCount = 0
}
