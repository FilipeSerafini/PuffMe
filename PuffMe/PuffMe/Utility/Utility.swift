//
//  Utility.swift
//  PuffMe
//
//  Created by Thiago Parisotto on 26/09/23.
//

import Foundation
import UIKit

func generateRandomPointWithin(size: CGSize) -> CGPoint {
    let randomX = CGFloat(arc4random_uniform(UInt32(size.width)))
    let randomY = CGFloat(arc4random_uniform(UInt32(size.height)))
    
    return CGPoint(x: randomX, y: randomY)
}

func randomInRange(min: UInt32, max: UInt32) -> Int {
    return Int(arc4random_uniform(max - min + 1) + min)
}
func vibrate(intensity: UIImpactFeedbackGenerator.FeedbackStyle) {
    // Check if the device supports haptic feedback
    if #available(iOS 10.0, *) {
        // Create a feedback generator
        let generator = UIImpactFeedbackGenerator(style: intensity)
        
        // Trigger haptic feedback
        generator.impactOccurred()
    }
}
func squared(x: CGFloat, y: Int) -> CGFloat{
    var result = x
    for _ in 1...y {
        result *= x
    }
    return x
}
