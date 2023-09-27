//
//  GameScene.swift
//  PuffMe
//
//  Created by Filipe Serafini on 25/09/23.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    //characters
    var puffs: [Puff] = []
    var urchin: Urchin?
    var star: Starfish?
    var player: Player = Player()
    var lifes: [SKSpriteNode] = []
    
    //puff variables
    var currLifetime: Int = 2
    var spawnRate: CGFloat = 1
    
    //star variables
    var starSpeed = 5.0
    var starSpawnTime = 10.0
    
    //game variables
    var scoreLabel: SKLabelNode?
    
    
    //pause menu buttons
    var pauseLabel: SKLabelNode
    var pauseBackToMenu: SKSpriteNode
    var pauseResume: SKSpriteNode
    
    override init(size: CGSize) {
        //configure pause menu buttons
        pauseLabel = SKLabelNode(text: "Paused")
        pauseLabel.fontName = "Helvetica-Bold"
        pauseLabel.fontSize = 48
        pauseLabel.fontColor = .blue
        pauseLabel.name = "pauseLabel"
        pauseLabel.position = CGPoint(x: size.width/2 ,y: size.height - 100)
        
        pauseResume = SKSpriteNode(color: .cyan, size: CGSize(width: 300, height: 50))
        pauseResume.position = CGPoint(x: size.width/2, y: pauseLabel.position.y - pauseLabel.fontSize - 30)
        pauseResume.name = "pauseResume"
        
        pauseBackToMenu = SKSpriteNode(color: .blue, size: CGSize(width: 300, height: 50))
        pauseBackToMenu.position = CGPoint(x: size.width/2, y: pauseResume.position.y - pauseResume.size.height - 20)
        pauseBackToMenu.name = "pauseBackToMenu"
        
        let pauseButtonTexture = SKTexture(imageNamed: "pauseButton")
        let pauseButton = SKSpriteNode(texture: pauseButtonTexture)
        
        pauseButton.name = "pauseButton"
        pauseButton.size = CGSize(width: 50, height: 50)
        pauseButton.position = CGPoint(x: size.width - pauseButton.size.width, y: size.height - pauseButton.size.height)
        pauseButton.zPosition = 1 // Adjust this value to make sure the button is above other nodes.
        
        
        super.init(size: size)
        addChild(pauseButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        //generates the score
        generateScoreLabel()
        
        //generates the lifes
        createLifes()
        
        //generates puffs based on spawn rate
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(generatePuff), SKAction.wait(forDuration: spawnRate)])))
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !isPaused{
            //generates star if player hp is not full
            if player.hp < 3 && star == nil {
                run(SKAction.repeatForever(SKAction.sequence([SKAction.run(generateStar), SKAction.wait(forDuration: starSpawnTime)])))
            }
            
            //checks for playes life
            checkLifes()
            
            //updates score
            self.scoreLabel?.text = "Score: \(player.score)"
            
            //check puffs lifetime
            for puff in puffs {
                if puff.lifeTime > 5 {
                    puff.sprite.removeAllActions()
                    explodePuff(puff: puff)
                }
                if puff.lifeTime < 1 {
                    savePuff(puff: puff)
                }
                
                //check player Hp
                if player.hp <= 0 {
                    gameOver()
                }
            }
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if(!isPaused){
                //touch puff
                if let node = self.atPoint(location) as? SKSpriteNode, node.name == "puff" {
                    guard let puff = puffs.first(where: {$0.sprite.hashValue == node.hashValue}) else {return}
                    
                    puffTouch(puff: puff)
                }
                //touch urchin
                
                //touch star
                if let node = self.atPoint(location) as? SKSpriteNode, node.name == "starfish" {
                    starTouch()
                }
            }
            //pause Button
            if let node = self.atPoint(location) as? SKSpriteNode, node.name == "pauseButton" {
                if isPaused {
                    removeChildren(in: [pauseResume, pauseBackToMenu, pauseLabel])
                }
                else {
                    node.texture = SKTexture(imageNamed: "playButton")
                    addChild(pauseResume)
                    addChild(pauseBackToMenu)
                    addChild(pauseLabel)
                }
                isPaused.toggle()
                
            }
            else
            if let node = self.atPoint(location) as? SKSpriteNode, node.name == "pauseResume" {
                removeChildren(in: [pauseResume, pauseBackToMenu, pauseLabel])
                isPaused.toggle()
            }
            else
            if let node = self.atPoint(location) as? SKSpriteNode, node.name == "pauseBackToMenu" {
                removeChildren(in: [pauseResume, pauseBackToMenu, pauseLabel])
                isPaused.toggle()
                let scene = MenuScene(size: CGSize(width: size.width, height: size.height))
                scene.scaleMode = .aspectFill
                
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(scene, transition: transition)
            }
            
        }
    }
    
    func urchinTouch() {
        
    }
    
    func starTouch() {
        player.hp += 1
        removeAnimal(animal: star!)
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
        //creates new star
        star = Starfish(lifeTime: 1)
        addChild(star!.sprite)
        
        //sequence of actions
        let appear = SKAction.scale(to: 0.3, duration: 0.5)
        let move = SKAction.moveTo(x: size.width + star!.sprite.size.width / 2, duration: starSpeed)
        let removeFromParent = SKAction.removeFromParent()
        let actions = [appear, move, removeFromParent]
        let rotateAction = SKAction.rotate(byAngle: .pi, duration: starSpeed)
        
        star!.sprite.run(SKAction.repeatForever(rotateAction))
        star!.sprite.run(SKAction.sequence(actions))
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
    
    
    func generateScoreLabel() {
        self.scoreLabel = SKLabelNode(text: "Score: 0")
        self.scoreLabel?.position = CGPoint(x: size.width/2, y: size.height - 20)
        self.scoreLabel?.zPosition = 2
        self.scoreLabel?.fontSize = 20
        self.scoreLabel?.fontColor = .white
        self.scoreLabel?.fontName = "Helvetica-Bold"
        
        if let scoreLabel = self.scoreLabel {
            addChild(scoreLabel)
        }
    }
    
    func createLifes() {
        lifes = []
        for i in 0..<player.hp {
            let life = SKSpriteNode(color: .red, size: CGSize(width: 20, height: 20))
            life.position = CGPoint(x: 50 + (CGFloat(i) * 40), y: self.size.height - 50)
            lifes.append(life)
            addChild(life)
        }
    }
    func checkLifes() {
        if player.hp < 1 {
            player.hp = 3
            gameOver()
        }
        if player.hp != lifes.count {
            for life in lifes {
                life.removeFromParent()
            }
            createLifes()
        }
    }
}

