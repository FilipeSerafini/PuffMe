//
//  GameOverScene.swift
//  PuffMe
//
//  Created by Filipe Serafini on 25/09/23.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    var score: Int
    var highscore: Int
    var backToMenu: SKLabelNode?
    var playAgain: SKSpriteNode?
    
    init(size: CGSize, score: Int, highscore: Int) {
        self.highscore = highscore
        self.score = score
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.scale(to: CGSize(width: size.width, height: size.height))
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -2
        addChild(background)
        
        // Create a Title Label
        let titleLabel = SKSpriteNode(imageNamed: "gameOver")
        titleLabel.size = CGSize(width: 300, height: 150)
        titleLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        addChild(titleLabel)
        
        //show score
        let scoreLabel = SKLabelNode(text: "Your score: \(score)")
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = UIColor(named: "scoreColor")
        scoreLabel.fontName = "SFProRounded-Bold"
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 220)
        addChild(scoreLabel)
        
        //show highscore
        let highscoreLabel = SKLabelNode(text: "Highscore: \(highscore)")
        highscoreLabel.fontSize = 24
        highscoreLabel.fontColor = UIColor(named: "highscoreColor")
        highscoreLabel.fontName = "SFProRounded-Bold"
        highscoreLabel.position = CGPoint(x: size.width / 2, y: size.height - 250)
        addChild(highscoreLabel)
        
        let newPlayAgain = SKSpriteNode(imageNamed: "playAgain")
        newPlayAgain.name = "playAgain"
        newPlayAgain.size = CGSize(width: 260, height: 110)
        newPlayAgain.position = CGPoint(x: size.width / 2, y: size.height - 300)
        playAgain = newPlayAgain
        if let playAgain {
            addChild(playAgain)
        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            //restar game button
            if let node = self.atPoint(location) as? SKSpriteNode, node.name == "playAgain" {
                vibrate(intensity: .medium)
                let scene = GameScene(size: CGSize(width: size.width, height: size.height))
                scene.scaleMode = .aspectFill
                
                let transition = SKTransition.fade(withDuration: 1.0)
                self.view?.presentScene(scene, transition: transition)
            }
        }
    }
    
}
