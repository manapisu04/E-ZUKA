//
//  TalkListCell.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/14.
//

import SwiftUI

struct TalkListCell: View {
    
    // アイコンのサイズ
    let iconSize = UIScreen.main.bounds.width / 6
    // 相手アイコン
//    let icon: String
    // 相手のユーザネーム
    let friendName: String
    // 一覧で表示するメッセージ（最後のやりとり）
    let lastMessage: String
    // メッセージの送信時間
    let time: String
    
    
    var body: some View {
        HStack {
//            Image(uiImage: UIImage(data: Data(base64Encoded: icon)!) ?? UIImage(named: "defaultIcon")!)
//                .renderingMode(.original)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: iconSize, height: iconSize)
//                .clipShape(Circle())
//                .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            
            VStack(alignment: .leading) {
                Text(friendName)
//                    .foregroundColor(.charColor)
                    .font(.title3)
                    .lineLimit(1)
                    .padding(.bottom, 2.0)
                Text(lastMessage)
                    .foregroundColor(.gray)
                    .font(.body)
                    .lineLimit(1)
            }
            

            Spacer()
        }
        .padding()
    }
}

struct TalkListCell_Previews: PreviewProvider {
    static var previews: some View {
        TalkListCell(friendName: "ピヨ", lastMessage: "メッセージ", time: "12:00")
    }
}
