//
//  DashboardUIViewController.swift
//  ConnectCorps
//
//  Created by Harish Yerra on 9/29/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import UIKit
import CoreLocation
import MapboxGeocoder

class DashboardUIViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var temporarySheltersCollectionView: UICollectionView!
    
    @IBOutlet weak var contactCollectionView: UICollectionView!
    var houses: [House] = [] {
        didSet {
            temporarySheltersCollectionView?.reloadData()
        }
    }
    let events: [Event] = [
        Event(id: 3, name: "asdf", location: CLLocation(latitude: 10, longitude: 10), time: Date(), cost: 3.0),
        Event(id: 3, name: "asdf", location: CLLocation(latitude: 10, longitude: 10), time: Date(), cost: 3.0),
        Event(id: 3, name: "asdf", location: CLLocation(latitude: 10, longitude: 10), time: Date(), cost: 3.0)
    ]
    var contacts: [Contact] = [] {
        didSet {
            contactCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "John Smith"
        navigationController?.navigationBar.prefersLargeTitles = true
        temporarySheltersCollectionView.delegate = self
        temporarySheltersCollectionView.dataSource = self
        contactCollectionView.delegate = self
        contactCollectionView.dataSource = self
        (temporarySheltersCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        (contactCollectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        ConnectCoreClient.shared.fetchHouses() { result in
            if case let .success(houses) = result {
                self.houses = houses
            }
        }.resume()
        
        ConnectCoreClient.shared.fetchContact() { result in
            if case let .success(contacts) = result {
                self.contacts = contacts
            }
        }.resume()
    }
    

    // MARK: - Data source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == temporarySheltersCollectionView {
            return houses.count
        } else if collectionView == contactCollectionView {
            return contacts.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == temporarySheltersCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
            cell.homeImageView.image = UIImage(named: "housing-\(Int.random(in: 1...8))")
            return cell
        } else if collectionView == contactCollectionView {
            let contact = contacts[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCollectionViewCell.reuseIdentifier, for: indexPath) as! ContactCollectionViewCell
            cell.profilePicture.image = UIImage(named: "contact-\(1)")
            cell.nameLabel.text = contact.name
            return cell
        } else {
            fatalError()
        }
        
    }
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == temporarySheltersCollectionView {
            let house = houses[indexPath.row]
            guard let location = house.location else { return }
            let reverseGeocodeOptions = ReverseGeocodeOptions(location: location)
            let placemark = Geocoder.shared.geocode(reverseGeocodeOptions) { (placemarks, attribution, error) in
                guard let placemark = placemarks?.first else {
                    return
                }
                let pulleyVC = self.storyboard!.instantiateViewController(identifier: CCPulleyViewController.identifier) as! CCPulleyViewController
                pulleyVC.placemark = placemark
                self.navigationController?.pushViewController(pulleyVC, animated: true)
            }
            placemark.resume()
        } else if collectionView == contactCollectionView {
            let contact = contacts[indexPath.row]
            UIApplication.shared.open(URL(string: "tel://\(contact.phoneNumber)")!, options: [:]) { completed in
            }
        }
    }

}
