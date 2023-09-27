//
//  GameScene.swift
//  PuffMe
//
//  Created by Filipe Serafini on 25/09/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var puffs: [Puff] = []
    var urchin: Urchin?
    var star: Starfish?
    var player: Player = Player()
    
    var currLifetime: Int = 2
    var spawnRate: CGFloat = 1
    
    var urchinSpawnRate: CGFloat = 22
    
    
    override func didMove(to view: SKView) {
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(generatePuff), SKAction.wait(forDuration: spawnRate)])))
        
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(generateUrchin), SKAction.wait(forDuration: urchinSpawnRate)])))
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        //check puffs lifetime
        for puff in puffs {
            if puff.lifeTime > 5 {
                puff.sprite.removeAllActions()
                explodePuff(puff: puff)
            }
            if puff.lifeTime < 1 {
                savePuff(puff: puff)
            }
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            //touch puff
            if let node = self.atPoint(location) as? SKSpriteNode, node.name == "puff" {
                guard let puff = puffs.first(where: {$0.sprite.hashValue == node.hashValue}) else {return}
                
                puffTouch(puff: puff)
            }
            //touch urchin
            if let node = self.atPoint(location) as? SKSpriteNode, node.name == "urchin" {
                urchinTouch()
            }
            //touch star
        }
    }
    
    func urchinTouch() {
        player.hp -= 1
        removeAnimal(animal: urchin!)
    }
    
    func starTouch() {
        
    }
    func puffTouch(puff: Puff) {
        puff.decreaseSize()
        if puff.lifeTime < 1 {
            savePuff(puff: puff)
        }
    }
    func generatePuff() {
        //create new puff
        let puff = Puff(direction: generateRandomPointWithin(size: size), lifeTime: randomInRange(min: 1, max: UInt32(currLifetime)), position: generateRandomPointWithin(size: size))
        //add puff to screen and array
        addChild(puff.sprite)
        puffs.append(puff)
        
    }
    func generateStar() {
        
    }
    func generateUrchin() {
        //create new urchin
        urchin = Urchin(lifeTime: 5, position: generateRandomPointWithin(size: size))
        addChild(urchin!.sprite)
        
        
        let firstRandomPoint = generateRandomPointWithin(size: size)
        let secondRandomPint = generateRandomPointWithin(size: size)
        let thirdRandomPint = generateRandomPointWithin(size: size)
        let rotationAngle = CGFloat.pi
        let rotationDurantion = 2.0
        
        let appear = SKAction.scale(to: 1, duration: 1)
        let rotationAction = SKAction.repeatForever(SKAction.rotate(byAngle: rotationAngle, duration: rotationDurantion))
        let firstMove = SKAction.move(to: firstRandomPoint, duration: 2.5)
        let secondMove = SKAction.move(to: secondRandomPint, duration: 2.5)
        let thirdMove = SKAction.move(to: thirdRandomPint, duration: 2.5)
        let wait = SKAction.wait(forDuration: 1.5)
        let killUrchin = SKAction.removeFromParent()
        
        let actions = [appear, firstMove, wait, secondMove, wait, thirdMove, wait, wait, killUrchin]
        
        urchin!.sprite.run(SKAction.sequence(actions))
        urchin!.sprite.run(rotationAction)

    }
    
    func moveUrchin() {
        
    }
    
    func savePuff(puff: Puff) {
        removeAnimal(animal: puff)
        player.increaseScore()
    }
    func removeAnimal(animal: Animal) {
        if animal is Puff {
            puffs.removeAll { puff in
                puff.id == animal.id
            }
        }
        animal.sprite.removeFromParent()
    }
    func explodePuff(puff: Puff) {
        removeAnimal(animal: puff)
        player.loseHP()
    }
    func increaseDifficulty() {
        
    }
    func gameOver() {
        
    }
}

