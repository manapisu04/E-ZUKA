//
//  SearchLibView.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/06.
//

import SwiftUI

struct SearchLibView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            
            if UserData.shared.isAccount == false {
                WorkOnView(function: "ユーザ検索機能")
            } else {
                
            }

            VStack {
                Spacer()
                    .frame(maxHeight: .infinity)

                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 10)
                    .background(.brown)
            }
        }
    }
}

struct SearchLibView_Previews: PreviewProvider {
    static var previews: some View {
        SearchLibView()
    }
}
