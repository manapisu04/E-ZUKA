//
//  TalkLibView.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/06.
//

import SwiftUI

struct TalkLibView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            
            if UserData.shared.isAccount == false {
                WorkOnView(function: "チャット機能")
            } else {
                
            }
            
            VStack {
                Spacer()
                    .frame(maxHeight: .infinity)
                
                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 10)
                    .background(.gray)
            }
        }
    }
}


struct TalkLibView_Previews: PreviewProvider {
    static var previews: some View {
        TalkLibView()
    }
}
