//
//  TutorialScene.swift
//  PuffMe
//
//  Created by Thiago Parisotto on 28/09/23.
//

import Foundation
import SpriteKit

class TutorialScene: GameScene {
    var title: String
    var image: String
    var tutorialDescription: String
    init(title: String, image: String, tutorialDescription: String, size: CGSize) {
        self.image = image
        self.title = title
        self.tutorialDescription = tutorialDescription
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(color: .black, size: size)
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -2
        addChild(background)
    }
}
