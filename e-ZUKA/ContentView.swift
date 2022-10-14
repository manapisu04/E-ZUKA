//
//  ContentView.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/04.
//

import SwiftUI



/*
 ここは、Launch Screenを表示して、LoginViewを表示するView
 */

struct ContentView: View {
    
    @State private var isLoading = true
    @State private var isStart = true
    @State private var isLoginViewDisable = true
    @State var isLogined = false
    
    // Launch Screen
    var launchScreen: some View {
        VStack {
//            Image("school")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .foregroundColor(.accentColor)
//                .frame(width: 170.0)
//                .shadow(color: Color("Shadow"),radius: 2)
            
            Spacer()
                .frame(height: UIScreen.main.bounds.height * 0.2)
            
            Text("DISCOVER!")
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .font(.system(size: 50, weight: .bold, design: .rounded))
                .shadow(color: Color("Shadow"),radius: 2)
            
            Spacer()
            
            
        }
    }
    
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            launchScreen
                .scaleEffect(isStart ? 20.0 : isLoading ? 1.0 : 0.01)
                .opacity(isLoading ? 1.0 : 0)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.65, blendDuration: 0.1))  {
                            isStart = false
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation {
                            isLoading = false
                            isLoginViewDisable = false
                        }
                    }
                }
            
            TabMainView()
                .opacity(isLoginViewDisable ? 0.0 : 1.0)
                .scaleEffect(isLogined ? 0.01 : 1.0)
            
        }
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
