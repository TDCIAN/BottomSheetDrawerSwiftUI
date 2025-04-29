//
//  BottomSheetDrawerView.swift
//  BottomSheetDrawerView
//
//  Created by 김정민 on 4/29/25.
//

import SwiftUI

struct BottomSheetDrawerView<Content: View>: View {
    
    @State private var bottomSheetOffset: CGFloat = 0
    @State private var lastOffset: CGFloat = 0
    @GestureState private var gestureOffset: CGFloat = 0
    @State private var contentHeight: CGFloat = 0
    
    private let bottomSafeAreaHeight: CGFloat = UIApplication.shared.rootViewController?.view.safeAreaInsets.bottom ?? 0
    
    @Binding var showBottomSheet: Bool
    
    let content: () -> Content
    
    private let threshold: CGFloat
    
    init(
        showBottomSheet: Binding<Bool>,
        threshold: CGFloat = 3,
        @ViewBuilder content: @escaping () -> Content
        
    ) {
        self._showBottomSheet = showBottomSheet
        self.threshold = threshold
        self.content = content
    }
    
    var body: some View {
        Group {
            if showBottomSheet {
                // MARK: Dimmed Background
                Color.black
                    .opacity(0.5)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .animation(.easeInOut, value: showBottomSheet)
                    .onTapGesture {
                        withAnimation {
                            showBottomSheet = false
                        }
                    }
            }
            
            // MARK: Bottom Sheet
            GeometryReader { proxy in
                let screenHeight = proxy.frame(in: .global).height
                
                ZStack {
                    Color.white
                        .clipShape(
                            CustomCorner(
                                corners: [.topLeft, .topRight],
                                radius: 20
                            )
                        )
                    
                    VStack(spacing: 0) {
                        Capsule()
                            .fill(Color.gray)
                            .frame(width: 80, height: 4)
                            .padding(.top, 12)
                        
                        content()
                            .border(Color.red, width: 1)
                        
                        Spacer().frame(height: bottomSafeAreaHeight)
                    }
                    .background(
                        GeometryReader { contentProxy in
                            Color.clear
                                .preference(key: ContentHeightKey.self, value: contentProxy.size.height)
                        }
                    )
                    .onPreferenceChange(ContentHeightKey.self) { contentHeight in
                        self.contentHeight = contentHeight
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                }
                .offset(y: (screenHeight + bottomSafeAreaHeight) - contentHeight)
                .offset(y: {
                    if self.showBottomSheet {
                        if -bottomSheetOffset > 0 {
                            if bottomSheetOffset <= screenHeight {
                                return bottomSheetOffset
                            } else {
                                return screenHeight
                            }
                        } else {
                            return bottomSheetOffset - bottomSafeAreaHeight
                        }
                    } else {
                        return (screenHeight + bottomSafeAreaHeight) - contentHeight
                    }
                }())
                .gesture(
                    DragGesture()
                        .updating(
                            $gestureOffset,
                            body: { value, state, transaction in
                                state = value.translation.height
                                onChangeBottomSheetOffset()
                            }
                        )
                        .onEnded({ value in
                            let thresholdSize: CGFloat = (contentHeight / threshold)
                            
                            withAnimation {
                                if bottomSheetOffset < 0 {
                                    bottomSheetOffset = 0
                                } else {
                                    if bottomSheetOffset > thresholdSize {
                                        bottomSheetOffset = 0
                                        showBottomSheet = false
                                    } else {
                                        bottomSheetOffset = 0
                                    }
                                }
                            }
                            lastOffset = bottomSheetOffset
                        })
                )
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .onChange(of: showBottomSheet) { showBottomSheet in
                if !showBottomSheet {
                    bottomSheetOffset = 0
                    lastOffset = 0
                }
            }
        }
    }
    
    private func onChangeBottomSheetOffset() {
        DispatchQueue.main.async {
            bottomSheetOffset = gestureOffset + lastOffset
        }
    }
    
    private struct CustomCorner: Shape {
        let corners: UIRectCorner
        let radius: CGFloat
        
        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(
                    width: radius,
                    height: radius
                )
            )
            
            return Path(path.cgPath)
        }
    }
}

fileprivate struct ContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension UIApplication {
    var rootViewController: UIViewController? {
        return UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?
            .rootViewController
    }

}
