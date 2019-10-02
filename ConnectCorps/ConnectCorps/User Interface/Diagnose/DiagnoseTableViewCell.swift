//
//  DiagnoseTableViewCell.swift
//

import UIKit

enum AgreementLevel: Int {
    case never
    case rarely
    case sometimes
    case often
    case always

    var textValue: String {
        switch self {
        case .never: return "Never"
        case .rarely: return "Rarely"
        case .sometimes: return "Sometimes"
        case .often: return "Often"
        case .always: return "Always"
        }
    }
}

protocol DiagnoseTableViewCellDelegate: class {
    func sliderChanged(in cell: DiagnoseTableViewCell)
}

class DiagnoseTableViewCell: UITableViewCell {

    weak var delegate: DiagnoseTableViewCellDelegate?

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var feelingLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var borderView: UIView!

    var prevAgreementLevel: AgreementLevel?
    var agreementLevel: AgreementLevel {
        get { return AgreementLevel(rawValue: Int(slider.value))! }
        set {
            slider.value = Float(newValue.rawValue)
            updateAgreementLevelLabel()
        }
    }

    @IBAction func sliderChanged(_ sender: Any) {
        slider.value = round(slider.value)
        updateAgreementLevelLabel()
        delegate?.sliderChanged(in: self)

        if prevAgreementLevel != agreementLevel && prevAgreementLevel != nil {
            UISelectionFeedbackGenerator().selectionChanged()
        }
        prevAgreementLevel = agreementLevel
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.cornerRadius = 25
        borderView.layer.borderWidth = 2
        borderView.layer.borderColor = UIColor(white: 0.27, alpha: 1).cgColor
    }

    func updateAgreementLevelLabel() {
        feelingLabel.text = agreementLevel.textValue
    }
    
}
