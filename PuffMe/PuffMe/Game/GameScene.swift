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
    var spawnRate: CGFloat = 1.8
    
    //urchin variables
    var urchinSpawnRate: CGFloat = 20
    
    //star variables
    var starSpeed = 5.0
    var starSpawnTime = 60.0
    
    //game variables
    var scoreLabel: SKLabelNode?
    var highscore = UserDefaults.standard.value(forKey: "highscore") as? Int ?? 0
    
    //pause menu buttons
    var pauseLabel: SKSpriteNode
    var pauseBackToMenu: SKSpriteNode
    var pauseResume: SKSpriteNode
    
    override init(size: CGSize) {
        //configure pause menu buttons
        
        pauseLabel = SKSpriteNode(texture: SKTexture(imageNamed: "pauseLabel"))
        pauseLabel.scale(to: CGSize(width: 274, height: 70))
        pauseLabel.name = "pauseLabel"
        pauseLabel.position = CGPoint(x: size.width/2 ,y: size.height - 130)
        
        pauseBackToMenu = SKSpriteNode(imageNamed: "returnMenu")
        pauseBackToMenu.size = CGSize(width: 260, height: 100)
        pauseBackToMenu.position = CGPoint(x: size.width/2, y: pauseLabel.position.y - pauseLabel.size.height - 10)
        pauseBackToMenu.name = "pauseBackToMenu"
        
        pauseResume = SKSpriteNode(imageNamed: "pauseContinue")
        pauseResume.size = CGSize(width: 260, height: 100)
        pauseResume.position = CGPoint(x: size.width/2, y: pauseBackToMenu.position.y - pauseBackToMenu.size.height/2 - 30)
        pauseResume.name = "pauseResume"
        
        
        
        let pauseButtonTexture = SKTexture(imageNamed: "pauseButton")
        let pauseButton = SKSpriteNode(texture: pauseButtonTexture)
        
        pauseButton.name = "pauseButton"
        pauseButton.size = CGSize(width: 50, height: 50)
        pauseButton.position = CGPoint(x: 63, y: 18 + pauseButton.size.height/2)
        pauseButton.zPosition = 1 // Adjust this value to make sure the button is above other nodes.
        
        super.init(size: size)
        addChild(pauseButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        
        
        
        SoundManager.shared.playBackgroundMusic(filename: "gameSound")
        
        let background = SKSpriteNode(imageNamed: "background")
        background.scale(to: CGSize(width: size.width, height: size.height))
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -2
        addChild(background)
        //generates the score
        generateScoreLabel()
        
        //generates the lifes
        createLifes()
        
        
        //generates puffs based on spawn rate
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(generatePuff), SKAction.wait(forDuration: spawnRate)])), withKey: "spawnPuffs")
        //generates urchins based on spawn rate
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: urchinSpawnRate), SKAction.run(generateUrchin)])), withKey: "spawnUrchin")
        //generates stars bases on spawn rate
        run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: starSpawnTime), SKAction.run(generateStar)])))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        //generates star if player hp is not full
        if player.hp < 3 && star == nil {
            run(SKAction.sequence([SKAction.run(generateStar), SKAction.wait(forDuration: starSpawnTime)]))
        }
        
        //checks for playes life
        checkLifes()
        
        //updates score
        self.scoreLabel?.text = "Score: \(player.score)"
        
        //check puffs lifetime
        for puff in puffs {
            if puff.lifeTime > 5 && !puff.isExploding {
                puff.sprite.removeAllActions()
                explodePuff(puff: puff)
            }
            if puff.lifeTime < 1 {
                puff.sprite.removeAllActions()
                savePuff(puff: puff)
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
            if(!isPaused){
                //touch puff
                if let node = self.atPoint(location) as? SKSpriteNode, node.name == "puff" {
                    guard let puff = puffs.first(where: {$0.sprite.hashValue == node.hashValue}) else {return}
                    SoundManager.shared.playSoundEffect(filename: "puff")
                    puffTouch(puff: puff)
                }
                //touch urchin
                if let node = self.atPoint(location) as? SKSpriteNode, node.name == "urchin" {
                    urchinTouch()
                }
                //touch star
                if let node = self.atPoint(location) as? SKSpriteNode, node.name == "starfish" {
                    starTouch()
                }
            }
            
            //pause Button
            if let node = self.atPoint(location) as? SKSpriteNode, node.name == "pauseButton" {
                vibrate(intensity: .medium)
                if isPaused {
                    removeChildren(in: [pauseResume, pauseBackToMenu, pauseLabel])
                }
                else {
                    addChild(pauseResume)
                    addChild(pauseBackToMenu)
                    addChild(pauseLabel)
                }
                isPaused.toggle()
                
            }
            else
            if let node = self.atPoint(location) as? SKSpriteNode, node.name == "pauseResume" {
                vibrate(intensity: .medium)
                removeChildren(in: [pauseResume, pauseBackToMenu, pauseLabel])
                isPaused.toggle()
            }
            else
            if let node = self.atPoint(location) as? SKSpriteNode, node.name == "pauseBackToMenu" {
                vibrate(intensity: .medium)
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
        vibrate(intensity: .heavy)
        player.hp -= 1
        removeAnimal(animal: urchin!)
    }
    
    func starTouch() {
        vibrate(intensity: .medium)
        player.hp += 1
        removeAnimal(animal: star!)
    }
    
    func puffTouch(puff: Puff) {
        vibrate(intensity: .light)
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
    }
    
    func generateStar() {
        //creates new star
        if player.hp < 3 {
            star = Starfish()
            addChild(star!.sprite)
            
            //sequence of actions
            
            let move = SKAction.moveTo(x: size.width + star!.sprite.size.width / 2, duration: starSpeed)
            let removeFromParent = SKAction.removeFromParent()
            let actions = [move, removeFromParent]
            let rotateAction = SKAction.rotate(byAngle: .pi, duration: starSpeed)
            
            star!.sprite.run(SKAction.repeatForever(rotateAction))
            star!.sprite.run(SKAction.sequence(actions))
        }
    }
    
    func generateUrchin() {
        //create new urchin
        urchin = Urchin()
        addChild(urchin!.sprite)
        
        
        let firstRandomPoint = generateRandomPointWithin(size: size)
        let secondRandomPint = generateRandomPointWithin(size: size)
        let thirdRandomPint = generateRandomPointWithin(size: size)
        let rotationAngle = CGFloat.pi
        let rotationDurantion = 2.0
        
        //let appear = SKAction.scale(to: 1, duration: 1)
        let rotationAction = SKAction.repeatForever(SKAction.rotate(byAngle: rotationAngle, duration: rotationDurantion))
        let firstMove = SKAction.move(to: firstRandomPoint, duration: 2.5)
        let secondMove = SKAction.move(to: secondRandomPint, duration: 2.5)
        let thirdMove = SKAction.move(to: thirdRandomPint, duration: 2.5)
        let wait = SKAction.wait(forDuration: 1.5)
        let killUrchin = SKAction.removeFromParent()
        
        let actions = [/*appear,*/ firstMove, wait, secondMove, wait, thirdMove, wait, wait, killUrchin]
        
        urchin!.sprite.run(SKAction.sequence(actions))
        urchin!.sprite.run(rotationAction)
        
    }
    
    func savePuff(puff: Puff) {
        self.removeAnimal(animal: puff)
        player.increaseScore()
        
        //updates difficulty
        if player.score % 100 == 0 && player.score != 0 && spawnRate > 0.5 {
            increaseDifficulty()
        }
    }
    
    func removeAnimal(animal: Animal) {
        if animal is Puff {
            puffs.removeAll { puff in
                puff.id == animal.id
            }
        }
        animal.sprite.removeAllActions()
        animal.sprite.removeFromParent()
    }
    
    func explodePuff(puff: Puff) {
        let action = SKAction.run {
            self.removeAnimal(animal: puff)
        }
        run(SKAction.sequence([SKAction.run(puff.explode), SKAction.wait(forDuration: 0.1), action]))
        vibrate(intensity: .heavy)
        player.loseHP()
        SoundManager.shared.playSoundEffect(filename: "plop")
    }
    
    func increaseDifficulty() {
        spawnRate *= 0.9
        urchinSpawnRate *= 0.9
        if self.action(forKey: "spawnPuffs") != nil{
            let updatedSpawnAction = SKAction.sequence([
                SKAction.run(generatePuff),
                SKAction.wait(forDuration: spawnRate)
            ])
            let updatedSpawnForeverAction = SKAction.repeatForever(updatedSpawnAction)
            self.run(updatedSpawnForeverAction, withKey: "spawnPuffs")
        }
        if self.action(forKey: "spawnUrchin") != nil{
            let updatedSpawnAction = SKAction.sequence([
                SKAction.run(generateUrchin),
                SKAction.wait(forDuration: urchinSpawnRate)
            ])
            let updatedSpawnForeverAction = SKAction.repeatForever(updatedSpawnAction)
            self.run(updatedSpawnForeverAction, withKey: "spawnUrchin")
        }
        
    }
    
    func gameOver() {
        if(player.score > highscore) {
            highscore = player.score
            UserDefaults.standard.setValue(player.score, forKey: "highscore")
            
        }
        
        let scene = GameOverScene(size: CGSize(width: size.width, height: size.height), score: player.score, highscore: highscore)
        scene.scaleMode = .aspectFill
        
        let transition = SKTransition.fade(withDuration: 1.0)
        self.view?.presentScene(scene, transition: transition)
    }
    
    
    func generateScoreLabel() {
        let highscoreLabel = SKLabelNode(text: "Highscore: \(highscore)")
        highscoreLabel.position = CGPoint(x: 111, y: size.height - 65)
        highscoreLabel.zPosition = 2
        highscoreLabel.horizontalAlignmentMode = .center
        highscoreLabel.fontSize = 18
        highscoreLabel.fontColor = UIColor(named: "highscoreColor")
        //highscoreLabel.fontName = "SFProRounded-Bold"
        
        self.scoreLabel = SKLabelNode(text: "Score: 0")
        self.scoreLabel?.position = CGPoint(x: 100, y: size.height - 40)
        self.scoreLabel?.zPosition = 2
        self.scoreLabel?.horizontalAlignmentMode = .center
        
        self.scoreLabel?.fontSize = 30
        self.scoreLabel?.fontColor = UIColor(named: "scoreColor")
        // self.scoreLabel?.fontName = "SFProRounded-Bold"
        
        if let scoreLabel = self.scoreLabel {
            addChild(scoreLabel)
            addChild(highscoreLabel)
        }
    }
    
    func createLifes() {
        lifes = []
        for i in 0..<player.hp {
            let life = SKSpriteNode(texture: SKTexture(imageNamed: "star"))
            life.scale(to: CGSize(width: 35, height: 35))
            life.position = CGPoint(x: size.width - 50 - (CGFloat(i) * 40), y: self.size.height - 50)
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
                life.texture = SKTexture(imageNamed: "emptyStar")
            }
            createLifes()
        }
    }
}

