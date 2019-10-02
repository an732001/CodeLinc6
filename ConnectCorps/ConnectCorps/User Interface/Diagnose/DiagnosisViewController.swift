//
//  DiagnosisViewController.swift
//

import UIKit

class DiagnosisViewController: UIViewController {

    @IBOutlet weak var diagnoseButton: UIControl!
    @IBOutlet weak var historyButton: UIControl!
    
    @IBAction func diagnoseTapped(_ sender: Any) {
        performSegue(withIdentifier: "diagnose", sender: nil)
    }
    
    @IBAction func historyTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Error", message: "You have not completed any diagnoses in the past.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        diagnoseButton.buttonify()
        historyButton.buttonify()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.hidesShadow = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        diagnoseButton.layer.cornerRadius = diagnoseButton.frame.width / 2
        historyButton.layer.cornerRadius = historyButton.frame.width / 2
    }

}
