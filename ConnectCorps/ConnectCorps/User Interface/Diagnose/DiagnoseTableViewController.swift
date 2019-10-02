//
//  DiagnoseTableViewController.swift
//

import UIKit

class DiagnoseTableViewController: UITableViewController {

    // index : value
    var values: [Int: AgreementLevel] = [:]
    let questions: [String] = [
        "How often do you have trouble sleeping at night?",
        "Do you ever feel like you don’t have enough energy?",
        "Do you have trouble concentrating?",
        "How much do you focus on your past actions?",
        "Do you ever have mood swings?",
        "Do you ever find yourself worrying or being afraid for no apparent reason?",
        "Do you sometimes feel distant or cut off from people?"
    ]

    @IBOutlet weak var doneButton: UIControl!

    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        performSegue(withIdentifier: "showResults", sender: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        doneButton.buttonify()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        if let header = tableView.tableHeaderView {
            let newSize = header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            header.frame.size.height = newSize.height
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DiagnoseTableViewCell
        cell.questionLabel.text = questions[indexPath.row]
        cell.agreementLevel = values[indexPath.row, default: .rarely]
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        doneButton.layer.cornerRadius = doneButton.frame.width / 2
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ResultsTableViewController

        let multipliers: [[CGFloat]] = [
            [0.12, 0.12, 0.2, 0.2, 0.11, 0.14, 0.11],
            [0.35, -0.2, 0.43, 0, 0.33, 0, 0.13],
            [0.26, -0.05, 0.15, 0.09, 0.38, 0.19, -0.05]
        ]

        func getSum(mult: [CGFloat]) -> Int {
            let sum = (0..<mult.count)
                .map { (idx: $0, value: values[$0, default: .rarely].rawValue) }
                .map { (CGFloat($0.value) / 5) * mult[$0.idx] }
                .reduce(0, +)
            return Int(sum * 100)
        }

        vc.disorders = [
            Disorder(name: "Depression", chance: getSum(mult: multipliers[0])),
            Disorder(name: "ADHD", chance: getSum(mult: multipliers[1])),
            Disorder(name: "Bipolar Disorder", chance: getSum(mult: multipliers[2])),
        ].sorted { $0.chance > $1.chance }
    }

}

extension DiagnoseTableViewController: DiagnoseTableViewCellDelegate {

    func sliderChanged(in cell: DiagnoseTableViewCell) {
        guard let idx = tableView.indexPath(for: cell) else { return }
        values[idx.row] = cell.agreementLevel
    }

}
