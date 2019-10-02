//
//  GetHelpViewController.swift
//

import UIKit

class GetHelpViewController: UIViewController {

    @IBOutlet weak var button: UIControl!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        navigationController?.view.backgroundColor = UIColor(white: 0.96, alpha: 1)
//        navigationController?.navigationBar.backgroundColor = UIColor(white: 0.96, alpha: 1)
        button.addTarget(imageView, action: #selector(UIView.touchDown), for: .touchDownAll)
        button.addTarget(imageView, action: #selector(UIView.touchUp), for: .touchUpAll)
        button.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
    }

    @objc func nextTapped() {
        performSegue(withIdentifier: "getHelp", sender: nil)
    }

}
