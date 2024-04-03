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
    
    @State var shouldPresentRewardAd = false
    
#if DEBUG
    let bannerAdId = "ca-app-pub-3940256099942544/2435281174"
    let rewardAdId = "ca-app-pub-3940256099942544/5224354917"
#else
    let bannerAdId = "Banner id real" // Nao use meu id
    let rewardAdId = "Seu id de reward"
#endif
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene)
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
            VStack {
                Button {
                    shouldPresentRewardAd = true
                } label: {
                    Text("Receba um premio")
                }
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
                    print("voce ganhou seu premio")
                })
            }
        }
        .onAppear {
            RewardedAd.shared.loadAd(withAdUnitId: rewardAdId)
        }
    }
}

#Preview {
    ContentView()
}
