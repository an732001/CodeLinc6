//
//  CCPulleyViewController.swift
//  ConnectCorps
//
//  Created by Harish Yerra on 9/29/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import UIKit
import Pulley

class CCPulleyViewController: PulleyViewController {
    static let identifier = "pulleyVC"
    
    var placemark: Placemark!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "placesDetailSegue") {
            let childViewController = segue.destination as! PlacesDetailViewController
            childViewController.placemark = placemark
        }
    }
}
