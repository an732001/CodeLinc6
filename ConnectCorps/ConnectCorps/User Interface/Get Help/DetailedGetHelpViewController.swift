//
//  DetailedGetHelpViewController.swift
//

import UIKit

struct Person {
    let name: String
    let location: String
}

class CollaborateTableViewController: UITableViewController {

    // tag 11, 12
    let data: [Person] = [
        .init(name: "Dr. K. Sinha", location: "Safdarjung, New Delhi"),
        .init(name: "Dr. D. Moorthy", location: "DLF Phase 3, Gurugram"),
        .init(name: "Dr. J. Nanda", location: "Vasant Kunj, New Delhi"),
        .init(name: "Dr. V. Bhatia", location: "Sector 45, Greater Noida"),
        .init(name: "Dr. S. Ananmay", location: "Saket, New Delhi"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 78
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.view.backgroundColor = .white
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let person = data[indexPath.row]
        (cell.viewWithTag(11) as! UILabel).text = person.name
        (cell.viewWithTag(12) as! UILabel).text = person.location
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

