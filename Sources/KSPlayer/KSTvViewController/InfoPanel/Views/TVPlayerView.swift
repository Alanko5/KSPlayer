//
//  TVPlayerView.swift
//  KSPlayer-iOS
//
//  Created by Marek Labuzik on 03/03/2021.
//

import UIKit

//MARK: - need custom playerView
final class TVPlayerView: VideoPlayerView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.topMaskView.isHidden = true
        self.bottomMaskView.isHidden = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.topMaskView.isHidden = true
        self.bottomMaskView.isHidden = true
    }
    
//    var subtitlesDelay: Double = 0.0
//    override func showSubtile(from subtitle: KSSubtitleProtocol, at time: TimeInterval) {
//        super.showSubtile(from: subtitle, at: time + self.subtitlesDelay)
//    }
    
    public func setSubtitlesBackgorund(color:UIColor) {
        subtitleBackView.backgroundColor = color.withAlphaComponent(0.4)
    }
    
    public var subtitlesDelay: Double {
        get {
            return self.resource?.definitions[self.currentDefinition].options.subtitleDelay ?? 0
        }
        set {
            self.resource?.definitions[self.currentDefinition].options.subtitleDelay = newValue
        }
    }
    
    public var subtitleColor: UIColor {
        get {
            return self.subtitleTextColor
        }
        set {
            self.subtitleTextColor = newValue
        }
    }
    
    public var subtitleBacgroundColor: UIColor {
        get {
            return self.subtitleBackView.backgroundColor ?? .white
        }
        set {
            self.subtitleBackView.backgroundColor = newValue
        }
    }
    
    public var subtitleSize: CGFloat {
        get {
            return self.subtitleLabel.font.pointSize
        }
        set {
            self.subtitleLabel.font = .systemFont(ofSize: newValue)
        }
    }
    
    public var selecetdDefionition: KSPlayerResourceDefinition? {
        get {
            self.resource?.definitions[safe: self.currentDefinition]
        }
        set {
            guard let newValue = newValue,
                  let index = self.resource?.definitions.firstIndex(of: newValue),
                  index != self.currentDefinition else { return }
            self.change(definitionIndex: index)
        }
    }
}
