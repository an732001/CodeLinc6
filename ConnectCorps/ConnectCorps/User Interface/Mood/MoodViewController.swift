//
//  MoodViewController.swift
//

import UIKit
import Magnetic

enum Mood: String, Decodable, CaseIterable {
    case angry, neutral, sad, afraid, surprised, happy, disgusted

    var color: UIColor {
        switch self {
        case .angry: return UIColor(red: 0.65, green: 0.04, blue: 0.02, alpha: 1)
        case .neutral: return UIColor(red: 1, green: 0.68, blue: 0.47, alpha: 1)
        case .sad: return UIColor(red: 0.26, green: 0.24, blue: 0.96, alpha: 1)
        case .afraid: return UIColor(red: 0.34, green: 0.09, blue: 0.57, alpha: 1)
        case .surprised: return UIColor(red: 1, green: 0.02, blue: 0.71, alpha: 1)
        case .happy: return UIColor(red: 0.07, green: 0.74, blue: 0, alpha: 1)
        case .disgusted: return UIColor(red: 0.42, green: 0.26, blue: 0.18, alpha: 1)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let str = try container.decode(String.self)
        switch str {
        case "Angry": self = .angry
        case "Neutral": self = .neutral
        case "Sad": self = .sad
        case "Fear": self = .afraid
        case "Surprise": self = .surprised
        case "Happy": self = .happy
        case "Disgust": self = .disgusted
        default: throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid mood: \(str)")
        }
    }

    func makeNode() -> Node {
        let node = Node(text: rawValue, image: UIImage(named: rawValue), color: color, radius: CGFloat.random(in: 50...70))
        node.label.fontSize = 18
        return node
    }
}

class MoodViewController: UIViewController {

    @IBOutlet weak var magneticContainer: UIView!
    @IBOutlet weak var doneButton: UIControl!
    
    var magnetic: Magnetic!
    var hasAdded = false

    @IBAction func doneTapped(_ sender: Any) {
        performSegue(withIdentifier: "motionSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.view.backgroundColor = .white

        let magneticView = MagneticView()
        magnetic = magneticView.magnetic
        magnetic.magneticDelegate = self
        magneticContainer.addSubview(magneticView)
        magneticView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            magneticView.leadingAnchor.constraint(equalTo: magneticContainer.leadingAnchor),
            magneticView.topAnchor.constraint(equalTo: magneticContainer.topAnchor),
            magneticView.trailingAnchor.constraint(equalTo: magneticContainer.trailingAnchor),
            magneticView.bottomAnchor.constraint(equalTo: magneticContainer.bottomAnchor),
        ])

        doneButton.buttonify()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !hasAdded {
            Mood.allCases.forEach { mood in
                magnetic.addChild(mood.makeNode())
            }
            hasAdded = true
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        doneButton.layer.cornerRadius = doneButton.frame.width / 2
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MotionViewController
        vc.moods = magnetic.selectedChildren.compactMap { $0.text.map(Mood.init) }.compactMap { $0 }
        if vc.moods.isEmpty {
            vc.moods = [.neutral]
        }
    }

}

extension MoodViewController: MagneticDelegate {

    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        UISelectionFeedbackGenerator().selectionChanged()
    }

    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        UISelectionFeedbackGenerator().selectionChanged()
    }

}
