//
//  Login.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/12.
//

import Foundation

struct Login: Decodable {
    let status: Int
    let session_token: String
    let id: Int
    let mail: String
}

struct SignIn: Encodable {
    let mail: String
    let pw_hash: String
}
