//
//  ScorePopoverView.swift
//  easeFlip
//
//  Created by Sonal on 13/11/25.
//

import SwiftUI
import SwiftData

struct ScorePopoverView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ScoreModel.timestamp, order: .reverse) private var scores: [ScoreModel]
    
    @State private var showDeleteAlert = false
    @State private var scoreToDelete: ScoreModel? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("Your Saved Scores:")
                .font(.title2)
                .bold()
                .padding(.bottom, 4)
            
            if scores.isEmpty {
                Text("No saved scores yet.")
                    .foregroundStyle(.secondary)
            } else {
                List {
                    HStack {
                        Text("Level")
                            .foregroundStyle(.secondary)
                            .frame(width: 55, alignment: .center)
                        Spacer()
                        Text("Moves Count")
                            .foregroundStyle(.secondary)
                            .frame(width: 55, alignment: .center)
                        Spacer()
                        Text("Time Stamp")
                            .foregroundStyle(.secondary)
                    }
                    
                    ForEach(scores) { score in
                        HStack {
                            Text("\(score.level.capitalized)")
                                .frame(width: 55, alignment: .center)
                            Spacer()
                            Text("**\(score.score)**")
                                .frame(width: 55, alignment: .center)
                            Spacer()
                            Text(formatDate(score.timestamp))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: confirmDelete)
                }
                .listStyle(.plain)
            }
            
            Spacer()
        }
        .alert("Delete Score?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                deleteScore()
            }
        } message: {
            Text("Are you sure you want to delete this score?")
        }
    }
    
    // MARK: Date formatter
    func formatDate(_ ts: Double) -> String {
        let date = Date(timeIntervalSince1970: ts)
        let f = DateFormatter()
        f.dateFormat = "MMM d, h:mm a"
        return f.string(from: date)
    }
    
    // MARK: trigger delete score
    private func confirmDelete(at offsets: IndexSet) {
        if let index = offsets.first {
            scoreToDelete = scores[index]
            showDeleteAlert = true
        }
    }
    
    private func deleteScore() {
        if let score = scoreToDelete {
            modelContext.delete(score)
            
            do {
                try modelContext.save()
            } catch {
                print("getting error while deleting score")
            }
        }
        scoreToDelete = nil
    }
}
