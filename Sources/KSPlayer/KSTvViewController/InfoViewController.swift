//
//  KStvOSInfoViewController.swift
//  KSPlayer
//
//  Created by Marek Labuzik on 02/02/2021.
//

import UIKit

//MARK: - infoViewController
@available(tvOS 13.0, *)
final class KStvOSInfoViewController: UITabBarController {
    override var preferredUserInterfaceStyle: UIUserInterfaceStyle {
        return .dark
    }
    
    func pokus() {
        var controllers:[UIViewController] = []
        let vc = KSInfoViewController()
        vc.title = "First"
        controllers.append(vc)
        let vc1 = KSAudioViewController()
        vc1.title = "Second"
        controllers.append(vc1)
        self.setViewControllers(controllers, animated: false)
        
    }
    
    
}

protocol InfoController {
    var heightConstraint: NSLayoutConstraint? { get }
    var contentView: UIView { get set}
}

final class KSInfoViewController: UIViewController, InfoController {
    var contentView: UIView = UIView()
    var heightConstraint: NSLayoutConstraint?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        self.view.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.backgroundColor = .blue
        
        self.contentView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        self.contentView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.contentView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.contentView.widthAnchor.constraint(equalToConstant: 900).isActive = true
        self.heightConstraint = self.contentView.heightAnchor.constraint(equalToConstant: 800)
        
        self.heightConstraint?.isActive = true
    }
}

final class KSAudioViewController: UIViewController, InfoController {
    var contentView: UIView = UIView()
    var heightConstraint: NSLayoutConstraint?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    private func configureView() {
        self.view.addSubview(self.contentView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.backgroundColor = .black
        
        self.contentView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        self.contentView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.contentView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.contentView.widthAnchor.constraint(equalToConstant: 900).isActive = true
        self.heightConstraint = self.contentView.heightAnchor.constraint(equalToConstant: 900)
        
        self.heightConstraint?.isActive = true
    }
    
}

final class KSSrtViewController: UIViewController, InfoController {
    var contentView: UIView = UIView()
    var heightConstraint: NSLayoutConstraint?
    
    
}

final class KSVideoViewController: UIViewController, InfoController {
    var contentView: UIView = UIView()
    var heightConstraint: NSLayoutConstraint?
    
    
}

