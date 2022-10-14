//
//  RealmMessage.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/14.
//

import Foundation
import RealmSwift

class RealmMessage: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId

    @Persisted var message: String
    @Persisted var target: Int
    @Persisted var from: Int
    @Persisted var date: Date = .now
}
