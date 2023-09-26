//
//  Player.swift
//  PuffMe
//
//  Created by Thiago Parisotto on 26/09/23.
//

import Foundation

class Player {
    var hp = 3
    var score = 0
    var highscore = 0 // userdefault depois
    
    func restoreHP() {
        
    }
    func loseHP() {
        hp -= 1
    }
    func increaseScore() {
        score += 10
    }
}
