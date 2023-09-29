//
//  SoundManager.swift
//  PuffMe
//
//  Created by Marina Yamaguti on 27/09/23.
//

import SpriteKit
import Foundation
import AVFoundation

class SoundManager {
    
    static let shared = SoundManager()
    
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var soundEffectPlayer: AVAudioPlayer?

    private var isBackgroundMusicPaused = false
    
    
    private init() {}
    
    func playBackgroundMusic(filename: String) {
        if let url = Bundle.main.url(forResource: filename, withExtension: "mp3") {
            do {
                backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundMusicPlayer?.numberOfLoops = -1  // Loop indefinitely
                backgroundMusicPlayer?.volume = 0.05
                backgroundMusicPlayer?.prepareToPlay()
                backgroundMusicPlayer?.play()
            } catch {
                print("Error playing background music: \(error.localizedDescription)")
            }
        }
    }
    
    func pauseBackgroundMusic() {
        if backgroundMusicPlayer?.isPlaying == true {
            backgroundMusicPlayer?.pause()
            isBackgroundMusicPaused = true
        }
    }
    
    func continueBackgroundMusic() {
        if isBackgroundMusicPaused {
            backgroundMusicPlayer?.play()
            isBackgroundMusicPaused = false
        }
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
        isBackgroundMusicPaused = false
    }
    func playSoundEffect(filename: String) {
            if let url = Bundle.main.url(forResource: filename, withExtension: "mp3") {
                do {
                    soundEffectPlayer = try AVAudioPlayer(contentsOf: url)
                    soundEffectPlayer?.numberOfLoops = 0  // Play sound once
                    soundEffectPlayer?.volume = 1.0  // Adjust the volume as needed
                    soundEffectPlayer?.prepareToPlay()
                    soundEffectPlayer?.play()
                } catch {
                    print("Error playing sound effect: \(error.localizedDescription)")
                }
            }
        }
}
