//
//  Friend.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/15.
//

import Foundation


struct Friend: Decodable, Identifiable {
    var id: String
    var name: String
    var message: [Message]
}

struct Message: Decodable, Hashable {
    var id: String
    var message: String
    var time: String
}

struct FriendList: Decodable {
    let friends: [Friend]
}
