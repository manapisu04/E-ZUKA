//
//  TabMainView.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/06.
//

import SwiftUI

struct TabMainView: View {
    // どのViewを開いているかを識別する変数
    @State var selection = 1
    
    var body: some View {
        ZStack {
            
            NavigationView {
                TabView(selection: $selection) {
                    
                        ARView()
                            .tabItem{
                                Label("", systemImage: "camera.viewfinder")
                            }.tag(5)
                        
                        TalkLibView()
                            .tabItem {
                                Label("", systemImage: "bubble.right")
                            }.tag(1)
                        
                        SearchLibView()
                            .tabItem {
                                Label("", systemImage: "person.3")
                            }.tag(2)
                        
                        DartsView()
                            .tabItem {
                                Label("", systemImage: "network")
                            }.tag(3)
                        
                        SettingView()
                            .tabItem {
                                Label("", systemImage: "gear")
                            }.tag(4)
                    }
                .navigationTitle(selection == 1 ? NSLocalizedString("チャット一覧", comment: "") : (selection == 2 ? NSLocalizedString("ユーザ検索", comment: "") : (selection == 3 ? NSLocalizedString("ダーツ機能", comment: "") : (selection == 5 ? NSLocalizedString("県カード撮影モード", comment: "") : NSLocalizedString("設定", comment: "")))))
                    .navigationBarTitleDisplayMode(.inline)
                    .onChange(of: selection) { selection in
                        if selection == 1 {
                            print("チャット一覧が選択された")
                            //                            // ここでトーク一覧が選択された時の処理を実装する
                            //                            let _ = TalkView.init()
                        } else if selection == 2 {
                            print("ユーザ検索が選択された")
                            // ここでガチャが選択された時の処理を実装する
                        } else if selection == 3 {
                            print("ダーツが選択された")
                            // ここで設定が選択されたときの処理を実装する
                        } else if selection == 4 {
                            print("設定が選択された")
                        }
                    }
                }
                
        }
    }
}

struct TabMainView_Previews: PreviewProvider {
    static var previews: some View {
        TabMainView()
    }
}
