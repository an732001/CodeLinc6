//
//  MotionViewController.swift
//

import UIKit
import AVKit

class MotionViewController: UIViewController {

    var detectedShake = false
    var moods: [Mood]!

    var isCancelled = false

    @IBOutlet weak var videoContainer: UIView!
    @IBOutlet weak var timeLabel: UILabel!

    var videoLayer: AVPlayerLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = Bundle.main.url(forResource: "Hand Shaking", withExtension: "mp4")!
        let avPlayer = AVPlayer(url: url)
        avPlayer.actionAtItemEnd = .none

        videoLayer = AVPlayerLayer(player: avPlayer)
        videoLayer.videoGravity = .resizeAspect
        videoContainer.layer.addSublayer(videoLayer)

        avPlayer.play()

        NotificationCenter.default.addObserver(self, selector: #selector(replay), name: .AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem!)
    }

    @objc func replay(notification: Notification) {
        let item = notification.object as! AVPlayerItem
        item.seek(to: .zero, completionHandler: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let totTime = 7
        for i in (0...totTime).reversed() {
            let delay = totTime - i
            let interval = DispatchTimeInterval.seconds(delay)
            DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
                guard !self.isCancelled else { return }
                self.timeLabel?.text = "\(i) second\(i == 1 ? "" : "s")"
                if i == 0 {
                    self.performSegue(withIdentifier: "cameraSegue", sender: nil)
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoLayer?.frame = videoContainer.layer.bounds
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        isCancelled = true
    }

    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionBegan(motion, with: event)

        guard motion == .motionShake else { return }
        detectedShake = true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! CameraViewController).detectedShake = detectedShake
        (segue.destination as! CameraViewController).moods = moods
    }

}
