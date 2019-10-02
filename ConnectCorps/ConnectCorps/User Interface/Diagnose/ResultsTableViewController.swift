//
//  ResultsTableViewController.swift
//

import UIKit

struct Disorder {
    let name: String
    let chance: Int
}

class ResultsTableViewController: UITableViewController {

    var disorders: [Disorder]!

    var isLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delaysContentTouches = false
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.beginRefreshing()
        tableView.contentOffset.y = -tableView.refreshControl!.frame.height
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.tableView.refreshControl?.endRefreshing()
            self.isLoaded = true
            self.tableView.reloadData()
            self.tableView.refreshControl = nil
            UserDefaults.standard.set(true, forKey: "hasResults")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoaded ? disorders.count : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ResultsTableViewCell
        cell.container.color = TweakColor.allCases[indexPath.row % TweakColor.allCases.count]
        let disorder = disorders[indexPath.row]
        cell.disorderLabel.text = disorder.name
        cell.chanceLabel.text = "You have a \(disorder.chance)% chance."
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let idx = tableView.indexPathForSelectedRow!
        (segue.destination as! DetailedResultViewController).disorder = disorders[idx.row]
    }

}
