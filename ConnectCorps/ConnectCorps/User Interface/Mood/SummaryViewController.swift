//
//  SummaryViewController.swift
//

import UIKit
import Magnetic

class SummaryViewController: UIViewController {

    @IBOutlet weak var moodsContainer: UIView!
    @IBOutlet weak var moodContainer: UIView!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var talkControl: UIControl!
    @IBOutlet weak var talkImageView: UIImageView!

    var moodsMagnetic: Magnetic!
    var moodMagnetic: Magnetic!

    var hasShown = false
    
    @IBAction func talkTapped(_ sender: Any) {
        tabBarController?.performSegue(withIdentifier: "showSally", sender: nil)
    }
    
    var detectedShake: Bool!
    var moods: [Mood]!
    var actualMood: Mood!

    override func viewDidLoad() {
        super.viewDidLoad()
        talkControl.addTarget(talkImageView, action: #selector(UIView.touchDown), for: .touchDownAll)
        talkControl.addTarget(talkImageView, action: #selector(UIView.touchUp), for: .touchUpAll)

        let moodsMagView = MagneticView()
//        moodsMagView.layer.zPosition = -1
        moodsMagView.isUserInteractionEnabled = false
        moodsMagView.translatesAutoresizingMaskIntoConstraints = false
        moodsMagnetic = moodsMagView.magnetic
        view.addSubview(moodsMagView)

        let moodMagView = MagneticView()
//        moodMagView.layer.zPosition = -1
        moodMagView.isUserInteractionEnabled = false
        moodMagView.translatesAutoresizingMaskIntoConstraints = false
        moodMagnetic = moodMagView.magnetic
        view.addSubview(moodMagView)

        NSLayoutConstraint.activate([
            moodsMagView.leadingAnchor.constraint(equalTo: moodsContainer.leadingAnchor),
            moodsMagView.topAnchor.constraint(equalTo: moodsContainer.topAnchor),
            moodsMagView.trailingAnchor.constraint(equalTo: moodsContainer.trailingAnchor),
            moodsMagView.bottomAnchor.constraint(equalTo: moodsContainer.bottomAnchor),

            moodMagView.leadingAnchor.constraint(equalTo: moodContainer.leadingAnchor),
            moodMagView.topAnchor.constraint(equalTo: moodContainer.topAnchor),
            moodMagView.trailingAnchor.constraint(equalTo: moodContainer.trailingAnchor),
            moodMagView.bottomAnchor.constraint(equalTo: moodContainer.bottomAnchor),
        ])

        var str = detectedShake ? "In addition, we detected your hands shaking, which may be indicative of the beginnings of a panic attack.\n\n" : ""
        str += "Would you like to talk to Sally about your diagnosis?"

        endLabel.text = str
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !hasShown {
            moods.forEach {
                moodsMagnetic.addChild($0.makeNode())
            }
            moodMagnetic.addChild(actualMood.makeNode())
            hasShown = true
        }
    }

}
