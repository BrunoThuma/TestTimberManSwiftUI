//
//  ContentView.swift
//  TestTimberManSwiftUI
//
//  Created by Bruno Thuma on 02/04/24.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    var scene: SKScene {
        let scene = GameScene(fileNamed: "GameScene")
        scene!.scaleMode = .fill
        return scene!
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
            
        }
    }
}

#Preview {
    ContentView()
}
