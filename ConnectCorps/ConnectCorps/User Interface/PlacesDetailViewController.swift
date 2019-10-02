//
//  PlacesDetailViewController.swift
//

import UIKit
import Pulley
import ARKit
import Mapbox
import CoreData
import IntentsUI
import MessageUI
import SafariServices

class PlacesDetailViewController: UIViewController {
    
    static let identifier = "placesDetailVC"
    
    var placemark: Placemark!
        
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var close: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var topSeparatorView: UIView!
    @IBOutlet weak var topGripperView: UIView!
    @IBOutlet weak var bottomSeparatorView: UIView!
    @IBOutlet weak var bottomGripperView: UIView!
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var address: UILabel!
    
    @IBOutlet weak var contactOfficialView: UIView!
    
    @IBOutlet weak var optionsStackView: UIStackView!
    
    @IBOutlet weak var headerSpacingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        placeName.text = placemark.displayName
        detail.text = placemark?.genres?.first ?? placemark.addressLines?.first
        address.text = placemark.addressLines?.joined(separator: "\n")
        navigationController?.navigationBar.prefersLargeTitles = false
        
        setupAccessibility()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup right before the view will appear.
        updateMap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        // Do any layout related work when the interface environment changes.
        optionsStackView.axis = traitCollection.preferredContentSizeCategory.isAccessibilityCategory ? .vertical : .horizontal
        view.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Do any additional setup after the view laid out the subviews.
        close.layer.cornerRadius = close.layer.bounds.width / 2
        close.layer.masksToBounds = true
        
        activityHeightConstraint.constant = activityIndicator.intrinsicContentSize.height + 15
        activityIndicator.layer.cornerRadius = activityIndicator.bounds.height / 8
        activityIndicator.layer.masksToBounds = true
    }
    
    // MARK: - Update map
    
    private func updateMap() {
        guard let mapViewController = (pulleyViewController?.primaryContentViewController as? MapViewController) else { return }
        guard let mapView = mapViewController.mapView else { return }
        mapView.removeAnnotations(mapView.annotations ?? [])
        
        if let latitude = placemark.latitude, let longitude = placemark.longitude {
            let coordinate = CLLocationCoordinate2D(latitude: latitude.doubleValue, longitude: longitude.doubleValue)
            mapViewController.annotationBackgroundColor = placemark.relativeScope.displayColor
            mapViewController.annotationImage = UIImage(named: "\(placemark.maki ?? "marker")-15", in: Bundle(identifier: "com.harishyerra.AerivoKit"), compatibleWith: traitCollection)
            
            let pointAnnotation = MGLPointAnnotation()
            pointAnnotation.coordinate = coordinate
            pointAnnotation.title = placemark.displayName
            pointAnnotation.subtitle = placemark.genres?.first
            mapView.addAnnotation(pointAnnotation)
            
            let camera = MGLMapCamera()
            camera.centerCoordinate = coordinate
            camera.altitude = 8000
            mapView.fly(to: camera) {
                mapView.setCenter(coordinate, animated: true)
            }
        }
    }
    
    // MARK: - Accessibility
    
    private func setupAccessibility() {
        let headerElement = UIAccessibilityElement(accessibilityContainer: headerView)
        headerElement.accessibilityTraits = .staticText
        headerElement.accessibilityLabel = (placeName.text?.appending(" ") ?? "") + (detail.text ?? "")
        headerElement.accessibilityFrameInContainerSpace = headerView.bounds
        headerView.accessibilityElements = [topGripperView, headerElement, close]
        
        contactOfficialView.subviews.forEach { $0.accessibilityIgnoresInvertColors = true }
        
        optionsStackView.subviews.forEach {
            $0.subviews.forEach { subview in
                if let subview = subview as? UIStackView {
                    subview.subviews.forEach { $0.accessibilityIgnoresInvertColors = true }
                }
            }
        }
        
        topGripperView.accessibilityCustomActions = [UIAccessibilityCustomAction(name: NSLocalizedString("Expand", comment: "Action for expanding the card overlay screen."), target: self, selector: #selector(expand)), UIAccessibilityCustomAction(name: NSLocalizedString("Collapse", comment: "Action for collapsing the card overlay screen."), target: self, selector: #selector(collapse))]
        bottomGripperView.accessibilityCustomActions = [UIAccessibilityCustomAction(name: NSLocalizedString("Expand", comment: "Action for expanding the card overlay screen."), target: self, selector: #selector(expand)), UIAccessibilityCustomAction(name: NSLocalizedString("Collapse", comment: "Action for collapsing the card overlay screen."), target: self, selector: #selector(collapse))]
    }
    
    
    // MARK: - Actions
    
    @IBAction func directions(_ sender: Any) {
        
    }
    
    @IBAction func showInfo(_ sender: UIButton) {
        if let wikiID = placemark?.wikidataItemIdentifier {
            guard let url = URL(string: "https://www.wikidata.org/wiki/\(wikiID)") else { return }
            let webViewController = SFSafariViewController(url: url)
            webViewController.preferredControlTintColor = UIColor(named: "System Green Color")
            present(webViewController, animated: true)
        } else {
            guard var urlComps = URLComponents(string: "https://www.google.com/search") else { return }
            let searchQuery = URLQueryItem(name: "q", value: placemark.qualifiedName ?? placemark.displayName)
            urlComps.queryItems = [searchQuery]
            guard let url = urlComps.url else { return }
            let webViewController = SFSafariViewController(url: url)
            webViewController.preferredControlTintColor = UIColor(named: "System Green Color")
            present(webViewController, animated: true)
        }
    }
    
    @IBAction func showAR(_ sender: UIButton) {
        guard ARWorldTrackingConfiguration.isSupported else { return }
        let arPlacesVC = storyboard?.instantiateViewController(withIdentifier: ARPlacesViewController.identifier) as! ARPlacesViewController
        guard let latitude = placemark.latitude?.doubleValue else { return }
        guard let longitude = placemark.longitude?.doubleValue else { return }
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        arPlacesVC.location = location
        self.pulleyViewController?.setDrawerPosition(position: .open, animated: true)
        present(arPlacesVC, animated: true)
    }
    
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}

// MARK: - Pulley drawer delegate

extension PlacesDetailViewController: PulleyDrawerViewControllerDelegate {
    @objc func expand() -> Bool {
        return pulleyViewController?.expand() ?? false
    }
    
    @objc func collapse() -> Bool {
        return pulleyViewController?.collapse() ?? false
    }
    
    func supportedDrawerPositions() -> [PulleyPosition] {
        if let presentedVC = presentedViewController as? PulleyDrawerViewControllerDelegate {
            if let supportedPositions = presentedVC.supportedDrawerPositions?() {
                return supportedPositions
            }
        }
        
        return PulleyPosition.all
    }
    
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        if let presentedVC = presentedViewController as? PulleyDrawerViewControllerDelegate {
            if let height = presentedVC.collapsedDrawerHeight?(bottomSafeArea: bottomSafeArea) {
                return height
            }
        }
        
        view.layoutIfNeeded()
        return headerView.bounds.height - headerSpacingConstraint.constant + bottomSafeArea
    }
    
    func partialRevealDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        if let presentedVC = presentedViewController as? PulleyDrawerViewControllerDelegate {
            if let height = presentedVC.partialRevealDrawerHeight?(bottomSafeArea: bottomSafeArea) {
                return height
            }
        }
        
        return 264 + bottomSafeArea
    }
    
    func drawerPositionDidChange(drawer: PulleyViewController, bottomSafeArea: CGFloat) {
        loadViewIfNeeded()
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomSafeArea, right: 0)
        
        headerSpacingConstraint.constant = drawer.drawerPosition == .collapsed ? bottomSafeArea : 0
        
        if drawer.drawerPosition != .open {
            presentedViewController?.dismiss(animated: true)
        }
        
        topGripperView.accessibilityValue = drawer.drawerPosition.localizedDescription
        bottomGripperView.accessibilityValue = drawer.drawerPosition.localizedDescription
        
        close.accessibilityFrame = view.convert(close.frame.insetBy(dx: -20, dy: -20), to: UIApplication.shared.keyWindow)
        topGripperView.accessibilityFrame = view.convert(topGripperView.frame.insetBy(dx: -20, dy: -30), to: UIApplication.shared.keyWindow)
        bottomGripperView.accessibilityFrame = view.convert(bottomGripperView.frame.insetBy(dx: -20, dy: -30), to: UIApplication.shared.keyWindow)
    }
    
    func drawerDisplayModeDidChange(drawer: PulleyViewController) {
        if let presentedVC = presentedViewController as? PulleyDrawerViewControllerDelegate { presentedVC.drawerDisplayModeDidChange?(drawer: drawer) }
        
        if drawer.currentDisplayMode == .drawer {
            topGripperView.alpha = 1
            bottomGripperView.alpha = 0
        } else {
            topGripperView.alpha = 0
            bottomGripperView.alpha = 1
        }
        
        if drawer.currentDisplayMode == .panel {
            topSeparatorView.isHidden = drawer.drawerPosition == .collapsed
            bottomSeparatorView.isHidden = drawer.drawerPosition == .collapsed
        } else {
            topSeparatorView.isHidden = false
            bottomSeparatorView.isHidden = true
        }
    }
}

extension PulleyPosition {
    var localizedDescription: String? {
        switch self {
        case .collapsed:
            return NSLocalizedString("Collapsed", comment: "Represents the collapsed position of an interface element.")
        case .partiallyRevealed:
            return NSLocalizedString("Partially Revealed", comment: "Represents the partially revealed position of an interface element.")
        case .open:
            return NSLocalizedString("Open", comment: "Represents the open position of an interface element.")
        case .closed:
            return NSLocalizedString("Closed", comment: "Represents the closed position of an interface element.")
        default:
            return nil
        }
    }
}

extension PulleyViewController {
    func expand() -> Bool {
        switch drawerPosition {
        case .collapsed:
            setDrawerPosition(position: .partiallyRevealed, animated: true)
            return true
        case .partiallyRevealed:
            setDrawerPosition(position: .open, animated: true)
            return true
        default:
            return false
        }
    }
    
    func collapse() -> Bool {
        switch drawerPosition {
        case .partiallyRevealed:
            setDrawerPosition(position: .collapsed, animated: true)
            return true
        case .open:
            setDrawerPosition(position: .partiallyRevealed, animated: true)
            return true
        default:
            return false
        }
    }
}
