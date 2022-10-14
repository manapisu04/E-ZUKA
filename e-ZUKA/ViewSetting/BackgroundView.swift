//
//  BackgroundView.swift
//  e-ZUKA
//
//  Created by 白井裕人 on 2022/10/04.
//

import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            // 背景色の設定（上から下）
            LinearGradient(gradient: Gradient(colors: [Color("GradientStartColor"), Color("GradientEndColor")]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            GeometryReader { reader in
                // 太めのラインの設定
                BackShape(bezierPath: .background)
                    .stroke(style: StrokeStyle(lineWidth: 50))
                    .foregroundColor(Color("GradientEndColor"))
                    .frame(width: reader.size.width, height: reader.size.height)
                    .offset(x: 0, y: 2)
                // パスの内側を透明なオレンジで塗ってるやつ。
                BackShape(bezierPath: .background)
                    .fill(Color("BackGroundObjectColor"))
                    .frame(width: reader.size.width, height: reader.size.height)
                    .opacity(0.5)
                
            }
            
        }
    }
}

// 実際にパスの位置や力をいじっているところ
extension UIBezierPath {
    static var background: UIBezierPath {
        let path = UIBezierPath()
        // スタート地点
        path.move(to: CGPoint(x: -0.5, y: -1))
        // (-0.5, 0.6)地点へ線を引く
        path.addLine(to: CGPoint(x: -0.5, y: 0.6 ))
        // (1.5, 0.5)地点に向けてカーブを作る。controlPoint1, controlPoint2が力のかかり方。ベクトル
        path.addCurve(to: CGPoint(x: 1.5, y: 0.5), controlPoint1: CGPoint(x: 0.6, y: -0.6), controlPoint2: CGPoint(x: 0.4, y: 1))
        // (1.2, -1)地点に向けて線をひく
        path.addLine(to: CGPoint(x: 1.2, y: -1))
        // 終わり
        path.close()
        return path
        
    }
}

/// 背景ラインの自作struct（パスをいじるやつ）
struct BackShape: Shape {
    
    let bezierPath: UIBezierPath
    
    func path(in rect: CGRect) -> Path {
        let path = Path(bezierPath.cgPath)
        let multiplier = min(rect.width, rect.height)
        let transform = CGAffineTransform(scaleX: multiplier, y: multiplier)
        return path.applying(transform)
    }
}



// 自作のTitleLabelを使用すれば、フォントをすべて変更できる（文字サイズも）
struct TitleLabel: View {
    let label: String
    let size: CGFloat
    // デフォルトの文字サイズは25に設定している。変えられるよ！
    init(_ label: String, size: CGFloat = 25) {
        self.label = label
        self.size = size
    }
    var body: some View {
        Text(label)
            // ここで、フォントを変更している
            .font(Font.titleFont(size: size))
            .foregroundColor(Color("FontColor"))
    }
}

// 自作のBodyLabelを使用すれば、フォントをすべて変更できる（文字サイズも）
struct BodyLabel: View {
    let label: String
    let size: CGFloat
    // デフォルトの文字サイズは15に設定
    init(_ label: String, size: CGFloat = 15) {
        self.label = label
        self.size = size
    }
    
    var body: some View {
        Text(label)
            // フォントを変更
            .font(.custom("HiraMaruProN-W4", size: size))
            .foregroundColor(Color("FontColor"))
    }
}

extension Font {
    static func titleFont(size: CGFloat) -> Font {
        return Font.custom("07LogoTypeGothic7", size: size)
    }
}

// ユーザネームの枠
//struct UserNameTextField: TextFieldStyle {
//    func _body(configuration: TextField<Self._Label>) -> some View {
//        ZStack {
//            RoundedRectangle(cornerSize: 10.0)
//                .fill(Color("TextFieldColor"))
//                .frame(height: 40)
//
//            RoundedRectangle(cornerSize: 10.0
//                .stroke(
//                    LinearGradient(colors: [.green, .white, .yellow], startPoint: .leading, endPoint: .trailing)
//                ),
//                lineWidth: 2
//            )
//            .frame(height: 40)
//
//            VStack {
//                configuration
//            }
//        }
//    }
//}

struct UserNameTextField : TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .foregroundColor(Color("FontColor"))
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(LinearGradient(colors: [.blue, .white, .yellow], startPoint: .leading, endPoint: .trailing), lineWidth: 2)
            )
            .padding()
            
    }
}

struct GradientTextFieldBackground2nd: TextFieldStyle {
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color("TextFieldColor"))
                .frame(height: 40)
            
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(
                    LinearGradient(colors: [
                        Color("TextEditorStartColor")
                        ,Color("TextEditorMidColor")
                        ,Color("TextEditorEndColor")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                    lineWidth: 2
            )
                .frame(height: 40)
            
            configuration
                .padding(.leading)
                .foregroundColor(Color("FontColor"))
        }
    }
    
}

// TextFieldの枠を自作している
struct GradientTextFieldBackground: TextFieldStyle {
    
    let systemImageString: String?
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10.0)
                .fill(Color("TextFieldColor"))
                .frame(height: 40)
            //.opacity(0.8)
            RoundedRectangle(cornerRadius: 10.0)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color("TextEditorStartColor")
                            ,Color("TextEditorMidColor")
                            ,Color("TextEditorEndColor")
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
                .frame(height: 40)
            
            
            HStack {
                if let systemImageString = systemImageString {
                    Image(systemName: systemImageString)
                }
                configuration
            }
            .padding(.leading)
            .foregroundColor(Color("FontColor"))
        }
    }
}


// 自作のCustomButton（ログイン画面のグラデーションボタン）
struct CustomButton: View {
    
    private let gradientView = LinearGradient(
        gradient: Gradient(colors: [Color("TextEditorStartColor"), Color("TextEditorMidColor"),Color("TextEditorEndColor")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing)
    let label: String
    let action: () -> ()
    
    
    var body: some View {
        ZStack {
            Button {
                action()
            } label: {
                // ここにTextを書かない、GeometryReaderを書くことによって、モディファイアを適用させている
                GeometryReader { reader in


                }
            }
            .background(gradientView)
            .opacity(0.5)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .cornerRadius(20)
            .padding([.trailing, .leading], 60)
            
            Text(label)
                .font(.system(size: 20, weight:.bold, design:.rounded))
                .foregroundColor(.white)
                .padding(20)
        }
    }
}

// 自作のボタン（半透明）
struct TranslucentButton: View {
    
    let label: String
    let action: () -> ()
    
    var body: some View {
        ZStack {
            Button {
                action()
            } label: {
                // ここにTextを書かない、GeometryReaderを書くことによって、モディファイアを適用させている
                GeometryReader { reader in


                }

            }
            .background(.white)
            .opacity(0.7)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .cornerRadius(20)
            .padding([.trailing, .leading], 60)
            
            // ZStackであえて上からTextを表示してる
            Text(label)
                .font(.system(size: 20, weight:.bold, design:.rounded))
                .foregroundColor(.gray)
                .padding(20)
        }
    }
}



struct BackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BackgroundView()
    }
}
