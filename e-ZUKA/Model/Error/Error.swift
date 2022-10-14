//
//  Error.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/12.
//

import Foundation

enum JECError: Error {
    case urlError
    case fetchError
    case parseError
    case encodeError
    
    var message: String {
        switch self {
        case .urlError:
            return "URLが正しくありません。\nhoge@jec.ac.jpにお問い合わせください"
        case .fetchError:
            return "jsonの取得に失敗しました。\n時間を置いて試してください"
        case .parseError:
            return "製作者:hoge@jec.ac.jpにお問い合わせください"
        case .encodeError:
            return ""
        }
    }
}
