//
//  Utility.swift
//  PuffMe
//
//  Created by Thiago Parisotto on 26/09/23.
//

import Foundation

func generateRandomPointWithin(size: CGSize) -> CGPoint {
    let randomX = CGFloat(arc4random_uniform(UInt32(size.width)))
    let randomY = CGFloat(arc4random_uniform(UInt32(size.height)))
    
    return CGPoint(x: randomX, y: randomY)
}

func randomInRange(min: UInt32, max: UInt32) -> Int {
    return Int(arc4random_uniform(max - min + 1) + min)
}
