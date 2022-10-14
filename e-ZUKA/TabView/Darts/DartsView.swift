//
//  DartsView.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/06.
//

import SwiftUI

struct DartsView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                
            }

            VStack {
                Spacer()
                    .frame(maxHeight: .infinity)

                Rectangle()
                    .fill(Color.clear)
                    .frame(height: 10)
                    .background(.yellow)
            }
        }
    }
}

struct DartsView_Previews: PreviewProvider {
    static var previews: some View {
        DartsView()
    }
}
