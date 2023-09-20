//
//  SplashScreenController.swift
//  INUPhoneBook
//
//  Created by 최용헌 on 2023/08/08.
//

import UIKit

import AVKit
import AVFoundation

class SplashViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.playVideo()
  }

  let playerController = AVPlayerViewController()
  
  private func playVideo() {
    guard let path = Bundle.main.path(forResource: "SplashScreen",
                                      ofType: "mp4") else { return }
    let player = AVPlayer(url: URL(fileURLWithPath: path))
    
    playerController.showsPlaybackControls = false
    playerController.player = player
    playerController.videoGravity = .resizeAspectFill
    
    present(playerController, animated: true) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        self.playerController.dismiss(animated: false, completion: nil)
      }
      player.play()
    }
  }
  

}
