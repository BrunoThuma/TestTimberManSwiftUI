//
//  PlayerNode.swift
//  TestTimberMan
//
//  Created by Bruno Thuma on 20/03/24.
//

import SpriteKit

class PlayerNode: SKSpriteNode {
    
    var side: Side = .left {
        didSet {
            if side == .left {
                xScale = 1
                position.x = 180
            } else {
                xScale = -1
                position.x = 576
            }
        }
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
