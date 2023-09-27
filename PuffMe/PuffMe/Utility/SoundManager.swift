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
    static let shared = SoundManager() // Singleton instance
    
    private var backgroundMusic: SKAudioNode?
    
//    func playBackgroundMusic(filename: String) {
//        if let music = SKAudioNode(fileNamed: filename) {
//            backgroundMusic = music
//            addChild(music)
//        }
//    }
//
//    func stopBackgroundMusic() {
//        backgroundMusic?.removeFromParent()
//    }
//
//    func playSoundEffect(filename: String) {
//        run(SKAction.playSoundFileNamed(filename, waitForCompletion: false))
//    }
}
