//
//  AppProperties.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/15.
//

import Foundation


/// Propertiesを読み込むクラス
/// シングルトンのためProp.sharedで使うこと
///
typealias Prop = AppProperties
class AppProperties {
    static let shared: Prop = .init()
    
    let properties: [String : String]
    
    private init() {
        
        if let path = Bundle.main.path(forResource: "Properties", ofType: "plist"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
           let plist = try? PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as? [String : String] {
            
            properties = plist
        } else {
            properties = [:]
        }
    }
}
