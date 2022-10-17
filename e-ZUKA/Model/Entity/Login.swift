//
//  Login.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/12.
//

import Foundation

struct LoginResponce: Decodable {
    let status: Int
    let id: Int
    let mail: String
    let session_token: String
}

struct LoginRequest: Encodable {
    let mail: String
    let password: String
    let user_name: String
}
