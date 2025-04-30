//
//  ContentView.swift
//  BottomSheetDrawerSwiftUI
//
//  Created by 김정민 on 4/29/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showBottomSheet: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: 50)
                
                Button(action: {
                    withAnimation {
                        showBottomSheet = true
                    }
                }, label: {
                    Text("Show Bottom Sheet")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 16, weight: .bold))
                        .frame(width: 300, height: 50)
                        .background(Color.blue)
                        .clipped()
                        .clipShape(Capsule())
                })
                
                
                Spacer()
            }
            .zIndex(0)
            
            BottomSheetDrawerView(
                showBottomSheet: $showBottomSheet,
                threshold: 3,
                content: {
                    VStack(spacing: 0) {
                        Rectangle()
                            .frame(height: 50)
                            .foregroundStyle(Color.red)
                        
                        Rectangle()
                            .frame(height: 50)
                            .foregroundStyle(Color.blue)
                        
                        Rectangle()
                            .frame(height: 50)
                            .foregroundStyle(Color.green)
                        
                        Rectangle()
                            .frame(height: 50)
                            .foregroundStyle(Color.yellow)
                        
                        Rectangle()
                            .frame(height: 50)
                            .foregroundStyle(Color.orange)
                        
                        Rectangle()
                            .frame(height: 50)
                            .foregroundStyle(Color.brown)
                        
                        Rectangle()
                            .frame(height: 50)
                            .foregroundStyle(Color.green)
                        
                        Rectangle()
                            .frame(height: 50)
                            .foregroundStyle(Color.red)
                    }
                }
            )
            .zIndex(1)
        }
        
    }
}

#Preview {
    ContentView()
}
