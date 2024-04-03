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
    #if DEBUG
    let bannerAdId =  "ca-app-pub-3940256099942544/2435281174"
    let rewardAdId = "ca-app-pub-3940256099942544/5224354917"
    #else
    let bannerAdId = "Seu id de banner"
    let rewardAdId = "Seu id de reward"
    #endif
    
    @State var shouldPresentRewardAd = false {
        didSet {
            print(shouldPresentRewardAd)
        }
    }
    
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
            
            VStack() {
                Button(action: {
                    shouldPresentRewardAd = true
                }, label: {
                    Text("Present Reward")
                })
                .buttonStyle(BorderedProminentButtonStyle())
                Spacer()
                BannerAd(adUnitId: bannerAdId)
                    .frame(width: GADAdSizeBanner.size.width,
                           height: GADAdSizeBanner.size.height)
            }
            if shouldPresentRewardAd {
                RewardedAdView(
                    isPresented: $shouldPresentRewardAd,
                    adUnitId: rewardAdId,
                    rewardFunc: {
                    print("did present reward video")
                })
            }
            
            
        }
        .onAppear {
            RewardedAd.shared.loadAd(withAdUnitId: "ca-app-pub-3940256099942544/5224354917")
            print("Loading intersticial ad")
            
        }
    }
}

#Preview {
    ContentView()
}
