//
//  ContentView.swift
//  TestTimberManSwiftUI
//
//  Created by Bruno Thuma on 02/04/24.
//

import SwiftUI
import SpriteKit
import GoogleMobileAds

struct ContentView: View {
    var scene: SKScene {
        let scene = GameScene(fileNamed: "GameScene")
        scene!.scaleMode = .fill
        return scene!
    }
    
    @State var adHeight: CGFloat = 0
    @State var adWidth: CGFloat = 0
    
    func setFrame() {
        //Get the frame of the safe area
        let safeAreaInsets = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero
        let frame = UIScreen.main.bounds.inset(by: safeAreaInsets)
        
        //Use the frame to determine the size of the ad
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.width)
        
        //Set the ads frame
        self.adWidth = adSize.size.width
        self.adHeight = adSize.size.height
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
            
            VStack {
                Spacer()
                
                BannerAd(adUnitId: "ca-app-pub-3940256099942544/9214589741")
                    .frame(width: adWidth, height: adHeight, alignment: .center)
                    .onAppear {
                        setFrame()
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                        setFrame()
                    }
            }
        }
    }
}

#Preview {
    ContentView()
}
