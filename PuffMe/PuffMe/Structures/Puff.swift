//
//  Puff.swift
//  PuffMe
//
//  Created by Thiago Parisotto on 26/09/23.
//

import Foundation
import SpriteKit

class Puff : Animal {
    var changeRate: CGFloat = 1.5
    var speed: CGFloat = 40
    var lifeTime: Int
    var textures: [SKTexture] = []
    
    init(lifeTime: Int, position: CGPoint, size: CGSize) {
        for i in 1..<6 {
            textures.append(SKTexture(imageNamed: "puff\(i)"))
        }
        let sprite = SKSpriteNode(texture: textures[lifeTime - 1])
        sprite.scale(to: CGSize(width: 50, height: 50))
        sprite.position = position
        sprite.name = "puff"
        self.lifeTime = lifeTime
        sprite.zPosition = -1
        super.init(sprite: sprite)
        for _ in 1..<lifeTime {
            sprite.scale(to: CGSize(width: sprite.size.width * changeRate, height: sprite.size.height * changeRate))
        }
        let grow = SKAction.run(increaseSize)
        let wait = SKAction.wait(forDuration: 1)
        let move = puffMove(size: size)
        sprite.run(SKAction.repeatForever(SKAction.sequence([grow, wait])))
        sprite.run(SKAction.repeatForever(move), withKey: "move")
    }
    
    
    func puffMove(size: CGSize) -> SKAction {
        let position = generateRandomPointWithin(size: size)
        let distanceX = sprite.position.x - position.x
        let distanceY = sprite.position.y - position.y
        let distanceTotal = sqrt(distanceX*distanceX + distanceY*distanceY)
        let duration = distanceTotal/speed
        
        return SKAction.move(to: position, duration: duration)
    }
    
    func increaseSize() {
        if(lifeTime < 6){
            let scaleAction = SKAction.scale(by: changeRate, duration: 1)
            let incLifeTime = SKAction.run(increaseLifeTime)
            sprite.run(SKAction.sequence([scaleAction, incLifeTime]))
        }
        //sprite.scale(to: CGSize(width: sprite.size.width * changeRate, height: sprite.size.height * changeRate))
    }
    func increaseLifeTime() {
        lifeTime += 1
        if lifeTime < 6{
            sprite.texture = textures[lifeTime - 1]
        }
    }
    func decreaseSize() {
        lifeTime -= 1
        sprite.scale(to: CGSize(width: sprite.size.width / changeRate, height: sprite.size.height / changeRate))
        if lifeTime > 0 {
            sprite.texture = textures[lifeTime - 1]
        }
    }
}
