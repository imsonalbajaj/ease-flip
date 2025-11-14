//
//  PlayView.swift
//  easeFlip
//
//  Created by Sonal on 29/07/25.
//

import SwiftUI
import Lottie

struct PlayView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var vm: PlayViewModel
    let verticalPadding = 16.0
    
    var body: some View {
        VStack {
            Text("Moves Count:  \(vm.youScore)")
                .foregroundStyle(.white)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            
            gridView
                .padding(verticalPadding)
                .background(RoundedRectangle(cornerRadius: 16.0).fill(Color.gray))
            
            
            Spacer()
            
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(8)
        .background(Color.black)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    vm.setVal()
                } label: {
                    Text("Reset")
                }
            }
        }
        .overlay {
            if vm.gamOver {
                congratulationsScreen
                    .frame(maxHeight: .infinity)
            }
        }
    }
    
    
    var gridView: some View {
        let columns: Array<GridItem> = Array(repeating: .init(.fixed(CGFloat(getItemWidth()))), count: vm.columns)
        
        return LazyVGrid(columns: columns, spacing: verticalPadding) {
            ForEach(0..<(vm.itemCount), id: \.self) { i in
                getGridCell(idx: i)
            }
        }
        
        
    }
    
    var congratulationsScreen: some View {
        Color.black
            .opacity(0.95)
            .clipShape(RoundedRectangle(cornerRadius: verticalPadding))
            .overlay {
                
                VStack {
                    Text("Congratulations you have won!")
                        .foregroundStyle(Color.white)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text("You have completed within moves: \(vm.youScore)")
                        .foregroundStyle(Color.white)
                        .font(.title3)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                LottieView(animation: .named("Confetti"))
                    .playing()
                    .animationDidFinish { _ in
                        vm.setVal()
                    }
            }
    }
    
    func getGridCell(idx: Int) -> some View {
        Color.white
            .frame(width: getItemWidth(), height: getItemWidth())
            .overlay {
                if vm.tapped[idx] {
                    Text("\(vm.cardAtLocation[idx])")
                        .font(.system(size: getItemWidth() * 0.6))
                        .minimumScaleFactor(0.1)
                        .padding()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 8.0))
            .onTapGesture {
                vm.cardTapped(idx: idx)
            }
    }
    
    func getItemWidth() -> CGFloat {
        return min ((UIScreen.main.bounds.width - 2 * verticalPadding - 2 * 8.0 - 8.0 * CGFloat(vm.columns - 1)) / CGFloat(vm.columns), UIScreen.main.bounds.width / CGFloat(vm.columns + 1))
    }
}
