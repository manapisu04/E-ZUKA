//
//  Message.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/15.
//

import Foundation

// structure //
struct MessageData : Codable {
    var message :String
    // 宛先ユーザのID
    var target :String
    // 送信元ユーザのID
    var from :String
}
