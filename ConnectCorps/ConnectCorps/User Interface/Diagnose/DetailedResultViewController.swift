//
//  DetailedResultViewController.swift
//

import UIKit

class DetailedResultViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var nextButton: UIControl!

    var disorder: Disorder!

    @IBAction func nextTapped(_ sender: Any) {
        performSegue(withIdentifier: "detailedDiagnosis", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = disorder.name

        let titleFont = UIFont(name: "CirceRounded-Regular", size: 42)!
        let bodyFont = UIFont(name: "CirceRounded-Regular5", size: 33)!
        let boldFont = UIFont(name: "CirceRounded-Regular", size: 33)!

        let str = NSMutableAttributedString()
        func append(_ string: String, font: UIFont) {
            str.append(NSAttributedString(string: string, attributes: [.font: font]))
        }

        append("Symptoms\n", font: titleFont)
        append("You exhibit ", font: bodyFont)
        append("7", font: boldFont)
        append(" common symptoms of \(disorder.name) and ", font: bodyFont)
        append("3", font: boldFont)
        append(" uncommon ones. These include\n\t– nervousness\n\t– rapid heart rate\n\n", font: bodyFont)

        append("Treatment\n", font: titleFont)
        append("These symptoms can be treated with the assistance of ", font: bodyFont)
        append("Sally", font: boldFont)
        append(" or ", font: bodyFont)
        append("Get Help", font: boldFont)
        append(".", font: bodyFont)

        textView.attributedText = str

        nextButton.buttonify()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nextButton.layer.cornerRadius = nextButton.frame.width / 2
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailedDiagnosisViewController
        vc.questions = [
            "Do you have little interest or pleasure in doing things?",
            "Are you feeling down, depressed, or hopeless?",
            "Do you have trouble falling or staying asleep, or do you sleep too much?",
            "Have you been feeling tired or lethargic in the last two weeks?",
            "In the past two weeks, have you had a poor appetite or have you been overeating?",
            "Have you been having trouble concentrating on things, such as reading the newspaper or watching television?",
            "Do you have thoughts that you would be better off dead, or of hurting yourself in some way?"
        ]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
