//
//  SoundManager.swift
//  easeFlip
//
//  Created by Sonal on 13/11/25.
//


import AVFoundation


enum SoundFiles: String {
    case error = "error.mp3"
    case flipcard = "flipcard.mp3"
    case guitar_party = "guitar-party.mp3"
    case win_sound = "win-sound.mp3"
}

class SoundManager {
    static let shared = SoundManager()
    private var player: AVAudioPlayer?
    
    private init () {
        
    }

    // MARK: - Play a sound
    func play(soundFile: SoundFiles) {
        stop()
        
        guard let url = Bundle.main.url(forResource: soundFile.rawValue, withExtension: nil) else {
            print("Sound file not found:", soundFile.rawValue)
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Error playing sound:", error)
        }
    }

    // MARK: - Stop playback
    func stop() {
        player?.stop()
        player = nil
    }
}
