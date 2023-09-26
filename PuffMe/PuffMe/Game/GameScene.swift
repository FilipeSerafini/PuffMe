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
    
    
    
    override func didMove(to view: SKView) {
        let pauseButtonTexture = SKTexture(imageNamed: "pauseButton")
        let pauseButton = SKSpriteNode(texture: pauseButtonTexture)
        pauseButton.name = "pauseButton"
        pauseButton.position = CGPoint(x: size.width - pauseButton.size.width / 2, y: size.height - pauseButton.size.height / 2)
        pauseButton.zPosition = 1 // Adjust this value to make sure the button is above other nodes.
        addChild(pauseButton)

        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(generatePuff), SKAction.wait(forDuration: spawnRate)])))
    }
    
    override func update(_ currentTime: TimeInterval) {
        if(!isPaused){
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
            
            //check player Hp
            if player.hp <= 0 {
                gameOver()
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            //pause Button
            if let node = self.atPoint(location) as? SKSpriteNode, node.name == "pauseButton" {
                if isPaused {
                    node.texture = SKTexture(imageNamed: "pauseButton")
                }
                else {
                    node.texture = SKTexture(imageNamed: "playButton")
                }
                isPaused.toggle()
                
            }
            if(!isPaused){
                //touch puff
                if let node = self.atPoint(location) as? SKSpriteNode, node.name == "puff" {
                    guard let puff = puffs.first(where: {$0.sprite.hashValue == node.hashValue}) else {return}
                    
                    puffTouch(puff: puff)
                }
                //touch urchin
                //touch star
            }
        }
    }
    
    func urchinTouch() {
        
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
        let puff = Puff(lifeTime: randomInRange(min: 1, max: UInt32(currLifetime)), position: generateRandomPointWithin(size: size), size: size)
        //add puff to screen and array
        addChild(puff.sprite)
        puffs.append(puff)
        puff.puffMove(size: size)
        
    }
    func generateStar() {
        
    }
    func generateUrchin() {
        
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
        let scene = GameOverScene(size: CGSize(width: size.width, height: size.height), score: player.score)
        scene.scaleMode = .aspectFill
        
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(scene, transition: transition)
    }
}

