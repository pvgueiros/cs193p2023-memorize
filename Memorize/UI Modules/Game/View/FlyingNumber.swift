//
//  FlyingNumber.swift
//  Memorize
//
//  Created by Paula Vasconcelos Gueiros on 21/01/25.
//

import SwiftUI

struct FlyingNumber: View {
    
    private struct Constant {
        static let positiveNumberOffset: CGFloat = -100
        static let negativeNumberOffset: CGFloat = 100
        
        struct Shadow {
            static let color: Color = .black
            static let radius: CGFloat = 1.5
            static let xPosition: CGFloat = 1
            static let yPosition: CGFloat = 1
        }
        
        struct ContentColor {
            static let positive: Color = .green
            static let negative: Color = .red
        }
    }
    
    @State private var offset: CGFloat = 0
    
    let number: Int
    
    var body: some View {
        if number != 0 {
            scoreView
        }
    }
    
    var scoreView: some View {
        Text(number, format: .number.sign(strategy: .always()))
            .font(.largeTitle)
            .foregroundStyle(number < 0
                             ? Constant.ContentColor.negative
                             : Constant.ContentColor.positive)
            .shadow(
                color: Constant.Shadow.color,
                radius: Constant.Shadow.radius,
                x: Constant.Shadow.xPosition,
                y: Constant.Shadow.yPosition)
            .offset(x: 0, y: offset)
            .opacity(offset != 0 ? 0 : 1)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5)) {
                    offset = number < 0 ? Constant.negativeNumberOffset : Constant.positiveNumberOffset
                }
            }
            .onDisappear {
                offset = 0
            }
    }
}

#Preview {
    FlyingNumber(number: 5)
}
