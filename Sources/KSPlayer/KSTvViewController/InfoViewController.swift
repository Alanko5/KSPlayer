//
//  KStvOSInfoViewController.swift
//  KSPlayer
//
//  Created by Marek Labuzik on 02/02/2021.
//

import UIKit
import AVKit

//MARK: - infoViewController
@available(tvOS 13.0, *)
final class KStvOSInfoViewController: UITabBarController {
    private var contentView:UIView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    private var heightConstraint: NSLayoutConstraint?
    
    var player:MediaPlayerProtocol?

    override var preferredUserInterfaceStyle: UIUserInterfaceStyle {
        return .dark
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func start(with player:MediaPlayerProtocol?) {
        self.player = player
        var controllers:[UIViewController] = []
        let vc = KSInfoViewController()
        vc.player = self.player
        controllers.append(vc)
        let vc1 = KSAudioInfoViewController()
        vc1.player = self.player
        controllers.append(vc1)
        self.setViewControllers(controllers, animated: false)
        self.configureTabBarController()
    }
    
    private func configureTabBarController() {
        let appearance = self.tabBar.standardAppearance.copy()
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        appearance.backgroundEffect = nil
        self.tabBar.standardAppearance = appearance
        
        self.view.backgroundColor = .clear
        
        self.delegate = self
    }
    
    private func configureView() {
        self.view.addSubview(self.contentView)
        self.view.sendSubviewToBack(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        self.contentView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.contentView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.contentView.widthAnchor.constraint(equalToConstant: 900).isActive = true

        self.heightConstraint = self.contentView.heightAnchor.constraint(equalToConstant: 200)
        
        self.heightConstraint?.isActive = true
        
        self.contentView.layer.cornerRadius = 32
        self.contentView.clipsToBounds = true
    }
}

@available(tvOS 13.0, *)
extension KStvOSInfoViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let viewController = viewController as? InfoController, viewController.contentView.frame.height != 0 {
            UIView.animate(withDuration: 0.5) {
                self.heightConstraint?.constant = viewController.contentView.frame.height
            }
        }
    }
    
    
}

class InfoController: UIViewController {
    var heightConstraint: NSLayoutConstraint?
    var contentView: ContentView = ContentView()
    var player: MediaPlayerProtocol?
}

protocol ContentViewDelegate: class {
    func didUpdateFrame()
}

final class ContentView: UIView {
    weak var delegate: ContentViewDelegate?
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.frame != .zero {
            self.delegate?.didUpdateFrame()
        }
    }
}

@available(tvOS 13.0, *)
final class KSInfoViewController: InfoController {
    private var coverImage: UIImageView = UIImageView()
    private var titleLabel: UILabel = UILabel()
    private var descLabel: UILabel = UILabel()
    private var stackView: UIStackView = UIStackView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        self.setupContoller()
        self.view.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        self.contentView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.contentView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.contentView.widthAnchor.constraint(equalToConstant: 900).isActive = true
        self.heightConstraint = self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        self.heightConstraint?.isActive = true
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.descLabel)
        self.contentView.addSubview(self.stackView)
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 150).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40).isActive = true
        self.titleLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 600).isActive = true
        
        self.stackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 4).isActive = true
        self.stackView.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor).isActive = true
        self.stackView.rightAnchor.constraint(lessThanOrEqualTo: self.titleLabel.rightAnchor).isActive = true
//        self.stackView.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor).isActive = true
        self.stackView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.stackView.axis = .horizontal
        
        self.descLabel.topAnchor.constraint(equalTo: self.stackView.bottomAnchor, constant: 4).isActive = true
        self.descLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -40).isActive = true
        self.descLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 600).isActive = true
        self.descLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20).isActive = true
        self.descLabel.numberOfLines = 0
        self.testStings()
        
        self.configureColors()
    }
    
    private func setupContoller() {
        self.title = "Info"
    }
    
    private func configureColors() {
        self.titleLabel.textColor = .darkGray
        self.titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        
        self.descLabel.textColor = .darkGray
        self.descLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
    }
    
    private func getLabel(with text:String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return label
    }
    
    private func testStings() {
        self.titleLabel.text = "Lorem ipsum dolor sit amet"
        self.descLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam at mattis urna, ac efficitur ligula. Sed viverra eu turpis quis aliquet. In sed est scelerisque, ultricies leo pulvinar, mollis lacus. In egestas placerat elementum. In placerat tincidunt leo, vel porta leo tincidunt nec. Integer volutpat commodo risus, ut hendrerit erat feugiat sit amet. Mauris dictum sodales fringilla. Aliquam elementum augue sed tortor faucibus vestibulum. Ut tellus diam, dapibus at nibh eget, vehicula eleifend lacus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Ut porttitor et enim vitae malesuada. Nulla sollicitudin fermentum lobortis."
        
        self.stackView.addArrangedSubview(self.getLabel(with: "15 min"))
        self.stackView.setCustomSpacing(8, after: self.stackView.arrangedSubviews.last!)
        self.stackView.addArrangedSubview(self.getLabel(with: "Comedy"))
        self.stackView.setCustomSpacing(8, after: self.stackView.arrangedSubviews.last!)
        self.stackView.addArrangedSubview(self.getLabel(with: "4K"))
        self.stackView.setCustomSpacing(8, after: self.stackView.arrangedSubviews.last!)
    }
    
    public func setInfoPanel(_ data:KSInfoPanelData) {
        
    }
}

final class KSSrtViewController: InfoController {
    
    
}

final class KSVideoViewController: InfoController {
    
    
}

struct KSInfoPanelData {
    var title: String?
    var description: String?
    var duration: String?
    var resolution: String?
    var generes: [String]
    var posterImage: UIImage?
}
