//
//  TVOSViewController.swift
//  KSPlayer
//
//  Created by Marek Labuzik on 01/02/2021.
//

import UIKit

public enum KSPlayerMediaQuality {
    case sd
    case hd
    case fullHD
    case ultraHD
}

public struct KSPlayerMediaInfo {
    let title: String
    let description: String?
    let imageUrl: URL?
    let duration: String?
    let quality: KSPlayerMediaQuality?
}

public protocol KStvOSViewDelegate: class {
    func existNextResource() -> Bool
    func nextResourceForPlayer() -> KSPlayerResource
    func nextMediaInfoForPlayer() -> KSPlayerMediaInfo
}

@available(tvOS 13.0, *)
final public class KStvOSViewController: UIViewController {
    public weak var delegate:KStvOSViewDelegate?
    
    private(set) var playerView:VideoPlayerView = VideoPlayerView()
    private let progressBar:ProgressToolBarView = ProgressToolBarView()
    private let progressContainer: UIView = UIView()
    private var infoController:KStvOSInfoViewController = KStvOSInfoViewController()
    private let infoControllerContainer: UIView = UIView()
    
    private var isPlaying:Bool {
        get {
            return self.playerView.playerLayer.player?.isPlaying ?? false
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.addGestures()
        self.view.backgroundColor = .black
        self.navigationController?.navigationBar.isHidden = true
        
        self.infoController.start(with: self.playerView.playerLayer.player)
        self.present(newContrller: self.infoController, animation: true)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.playerView.delegate = self
        
    }
    
    public override var preferredUserInterfaceStyle: UIUserInterfaceStyle {
        return .dark
    }
    
    deinit {
        print("Deinit")
    }
    
    //MARK: - Private methods
    private func configureView() {
        self.view.addSubview(self.playerView)
        self.playerView.translatesAutoresizingMaskIntoConstraints = true
        
        self.playerView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.playerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.playerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.playerView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        self.playerView.toolBar.isHidden = true
        self.playerView.toolBar.timeSlider.isHidden = true
    }
    
    private func play() {
        //TODO: need info from player is seekable
        self.progressBar.isSeekable = true
        
        self.playerView.play()
        self.progressBar(show: false)
    }
    
    private func playOrSeek() {
        if self.progressBar.selectedTime != self.progressBar.currentTime {
            self.playerView.seek(time: self.progressBar.selectedTime)
        } else {
            self.playerView.play()
        }
        
        self.progressBar(show: false)
    }
    
    private func pause() {
        self.playerView.pause()
    }
    
    private func stop() {
        self.playerView.resetPlayer()
        DispatchQueue.main.async { [weak self] in
            if self?.navigationController != nil {
                self?.navigationController?.popViewController(animated: true)
            } else {
                self?.dismiss(animated: true, completion: nil)
            }

            self?.playerView.delegate = nil
        }
    }
    
    private func showBuffering() {
        self.progressBar.show(buffering: true)
    }
    
    private func endBuffering() {
        self.progressBar.show(buffering: false)
    }
    
    private func paused() {
        self.progressBar(show: true)
    }
    
    private func error() {
        
    }
    
    private func playNextMovie() {
        
    }
    
    private func progressBar(show: Bool) {
        if show {
            self.view.addSubview(self.progressBar.view)
            self.addChild(self.progressBar)
            self.progressBar.didMove(toParent: self)
            self.progressBar.updateViews()
        } else {
            self.progressBar.willMove(toParent: nil)
            self.progressBar.removeFromParent()
            self.progressBar.view.removeFromSuperview()
        }
    }
}

//MARK: - KS PlayerControllerDelegate
@available(tvOS 13.0, *)
extension KStvOSViewController: PlayerControllerDelegate {
    public func playerController(state: KSPlayerState) {
        switch state {
        case .notSetURL:
            self.stop()
        case .readyToPlay:
            self.play()
        case .buffering:
            self.showBuffering()
        case .bufferFinished:
            self.endBuffering()
        case .paused:
            self.paused()
        case .playedToTheEnd:
            self.playNextMovie()
        case .error:
            self.error()
        }
    }
    
    public func playerController(currentTime: TimeInterval, totalTime: TimeInterval) {
        self.progressBar.update(currentTime: currentTime, totalTime: totalTime)
    }
    
    public func playerController(finish error: Error?) {
        
    }
    
    public func playerController(maskShow: Bool) {
        
    }
    
    public func playerController(action: PlayerButtonType) {
        
    }
    
    public func playerController(bufferedCount: Int, consumeTime: TimeInterval) {
        
    }
}

//MARK: - button actions
@available(tvOS 13.0, *)
extension KStvOSViewController  {
    private func addGestures() {
        let menuPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.menuPressed))
        menuPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue)]
        self.view.addGestureRecognizer(menuPressRecognizer)
        
        let playPausePressRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.playPausePressed))
        playPausePressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.playPause.rawValue)]
        self.view.addGestureRecognizer(playPausePressRecognizer)
        
        let selectPressRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.selectPressed))
        selectPressRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.select.rawValue)]
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(selectPressRecognizer)
    }
    
    private func removeGestures() {
        for gesture in self.view.gestureRecognizers ?? [] {
            self.view.removeGestureRecognizer(gesture)
        }
    }
    
    @objc func menuPressed() {
        if self.isPlaying {
            self.stop()
        } else {
            self.play()
        }
    }
    
    @objc func playPausePressed() {
        if self.isPlaying {
            self.pause()
        } else {
            self.play()
        }
    }
    
    @objc func selectPressed() {
        if self.isPlaying {
            self.pause()
        } else {
            self.playOrSeek()
        }
    }
}

//MARK: - controller public methods
@available(tvOS 13.0, *)
extension KStvOSViewController {
    
    public func set(_ media:KSPlayerResource, preferedAudioLangCode:String? = nil) {
        self.playerView.set(resource: media)
    }
    
    public func set(_ mediaInfo:KSPlayerMediaInfo) {
        
    }
    
    public func setSrt(size:Float? = nil, color:UIColor = .white) {
        
    }
    
}

//MARK: - add remove vontroller
@available(tvOS 13.0, *)
extension KStvOSViewController {
    
    private func present(newContrller:UIViewController, animation:Bool) {
        newContrller.willMove(toParent: self)
        self.view.addSubview(newContrller.view)
        self.addChild(newContrller)
        newContrller.didMove(toParent: self)
        self.removeGestures()
    }
    
    private func dismiss(oldController:UIViewController, animation:Bool) {
        oldController.willMove(toParent: nil)
        oldController.view.removeFromSuperview()
        oldController.removeFromParent()
        oldController.didMove(toParent: nil)
        self.addGestures()
    }
}

