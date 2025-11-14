//
//  HomeView.swift
//  easeFlip
//
//  Created by Sonal on 18/08/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ScoreModel.timestamp, order: .reverse) var scores: [ScoreModel]
    
    @State private var showScores = false
    let gameLevels = GameLevel.allCases
    
    var body: some View {
        NavigationStack {
            
            VStack {
                ForEach(gameLevels, id: \.self) { level in
                    NavigationLink(destination: PlayView(vm: PlayViewModel(forLevel: level, modelContext: modelContext))) {
                        Text("Play \(level.rawValue) ")
                            .font(.title3)
                            .foregroundStyle(Color.primary)
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background {
                                Capsule()
                                    .fill(Color.secondary)
                            }
                            .padding(1)
                    }
                }
                
                Spacer()
            }
            .padding()
            
            .navigationTitle("Ease Flip")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showScores.toggle()
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
            }
            .popover(isPresented: $showScores) {
                ScorePopoverView()
                    .padding()
            }
        }
    }
}

/*
#Preview {
    HomeView()
        .modelContainer(for: ScoreModel.self)
}
*/
