//
//  DashboardViewController.swift
//  ConnectCorps
//
//  Created by Harish Yerra on 9/29/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import UIKit
import CoreLocation
import MapboxGeocoder

class DashboardViewController: UITableViewController {
    static let identifier = "dashboardVC"
    
    var houses: [House] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let events: [Event] = [
        Event(id: 3, name: "Greensboro Career Fair", location: CLLocation(latitude: 10, longitude: 10), time: Date(), cost: 3.0),
        Event(id: 3, name: "Adult Education Fair", location: CLLocation(latitude: 10, longitude: 10), time: Date(), cost: 3.0),
        Event(id: 3, name: "Veteran Jobs Fair", location: CLLocation(latitude: 10, longitude: 10), time: Date(), cost: 3.0)
    ]
    var contacts: [Contact] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Dashboard"
        navigationController?.navigationBar.prefersLargeTitles = true
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
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Houses"
        case 1:
            return "Events"
        case 2:
            return "Contacts"
        default:
            fatalError("Unexpected sections")
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return houses.count
        case 1:
            return events.count
        case 2:
            return contacts.count
        default:
            fatalError("Unknown section number")
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DashboardTableViewCell.reuseIdentifier, for: indexPath) as! DashboardTableViewCell
        switch indexPath.section {
        case 0:
            let house = houses[indexPath.row]
            cell.titleLabel?.text = house.name
            cell.secondaryLabel?.text = "5.0 mi"
            cell.accessoryType = .disclosureIndicator
        case 1:
            let event = events[indexPath.row]
            cell.titleLabel?.text = event.name
            cell.secondaryLabel?.text = "Saturday, August 23rd"
            cell.accessoryType = .none
        case 2:
            let contact = contacts[indexPath.row]
            cell.titleLabel?.text = contact.name
            cell.secondaryLabel?.text = contact.phoneNumber
            cell.accessoryType = .detailButton
        default:
            fatalError("Unknown section number")
        }
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
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
        }
        
        if indexPath.section == 2 {
            let contact = contacts[indexPath.row]
            UIApplication.shared.open(URL(string: "tel://\(contact.phoneNumber)")!, options: [:]) { completed in
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
}

