//
//  TalkToSallyViewController.swift
//

import UIKit

class TalkToSallyViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var control: UIControl!

    @IBAction func talkTapped(_ sender: Any) {
        performSegue(withIdentifier: "alsoShowSally", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        control.addTarget(imageView, action: #selector(UIView.touchDown), for: .touchDownAll)
        control.addTarget(imageView, action: #selector(UIView.touchUp), for: .touchUpAll)
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
