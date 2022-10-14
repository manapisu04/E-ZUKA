//
//  ARView.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/12.
//

import SwiftUI

struct ARView: View {
    var body: some View {
        ZStack {
            BackgroundView()
            
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

struct ARView_Previews: PreviewProvider {
    static var previews: some View {
        ARView()
    }
}
