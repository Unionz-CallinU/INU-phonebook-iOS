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
    playVideo()
  }

  let playerController = AVPlayerViewController()
  
  private func playVideo() {
    guard let path = Bundle.main.path(forResource: "SplashScreen", ofType:"mp4") else { return }
    let player = AVPlayer(url: URL(fileURLWithPath: path))
    
    playerController.showsPlaybackControls = false
    playerController.player = player
    playerController.videoGravity = .resizeAspectFill
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(playerDidFinishPlaying),
                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                           object: playerController.player?.currentItem)
    
    present(playerController, animated: true) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        self.playerController.dismiss(animated: true, completion: nil)
      }
      player.play()
    }
  }
  
  @objc func playerDidFinishPlaying(note: NSNotification) {
    print("Method , video is finished ")
  }
}
