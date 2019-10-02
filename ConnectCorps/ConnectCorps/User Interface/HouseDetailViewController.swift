//
//  HouseDetailViewController.swift
//  ConnectCorps
//
//  Created by Harish Yerra on 9/29/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import UIKit
import MapKit

class HouseDetailViewController: UIViewController {
    
    static let identifier = "houseDetailVC"
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var houseImageView: UIImageView!
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var house: House!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func call(_ sender: Any) {
        UIApplication.shared.open(URL(string: "tel://\(house.phoneNumber)")!)
    }
}
