//
//  DetailedDiagnosisViewController.swift
//

import UIKit

class DetailedDiagnosisViewController: UIViewController {

    var questions: [String]!
    @IBOutlet weak var speechBubbleBG: UIView!
    @IBOutlet weak var bubbleLabel: UILabel!
    
    @IBAction func buttonTapped(_ sender: Any) {
        if questions.count > 1 {
            performSegue(withIdentifier: "showNextDetail", sender: nil)
        } else {
            performSegue(withIdentifier: "sallySegue", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bubbleLabel.text = questions[0]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailedDiagnosisViewController else { return }
        questions.removeFirst()
        vc.questions = questions
    }

}
