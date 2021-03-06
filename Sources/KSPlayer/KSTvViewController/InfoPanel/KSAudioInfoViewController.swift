//
//  KSAudioInfoViewController.swift
//  KSPlayer-tvOS
//
//  Created by Marek Labuzik on 02/03/2021.
//

import UIKit
import AVKit

@available(tvOS 13.0, *)
final class KSAudioInfoViewController: InfoController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for subview in self.contentView.arrangedSubviews {
            self.contentView.removeArrangedSubview(subview)
        }
        self.audioTrackTable()
    }
    
    override func configureView() {
        super.configureView()
        self.title = "Audio"
        
    }
    
    func showAirplay() {
        let routePickerView = AVRoutePickerView(frame: CGRect(x: 200, y: 200, width: 100, height: 100))
        routePickerView.routePickerButtonStyle = .custom
        routePickerView.backgroundColor = UIColor.clear
        routePickerView.delegate = self
        self.view.addSubview(routePickerView)
        
    }
    
    private var playerForSupportLoundSounds: KSMEPlayer? {
        get {
            guard let player = self.player as? KSMEPlayer else { return nil}
            return player
        }
    }
}

@available(tvOS 13.0, *)
extension KSAudioInfoViewController {
    private func audioTrackTable() {
        guard let player = self.player?.playerLayer.player else { return }

        let tracks = player.tracks(mediaType: .audio)
        let audioPicker = InfoTableView(items: tracks, with: "Audio") { (cell, value) in
            cell.set(title: value.title, isSelected: value.isEnabled)
        } selectHandler: { [weak self] (newValue) in
            self?.player?.playerLayer.player?.select(track: newValue)
        }
        let preferedConstant = audioPicker.tableViewWidth(for: tracks.map({ $0.title }))
        self.contentView.addArrangedSubview(audioPicker)
        audioPicker.translatesAutoresizingMaskIntoConstraints = false
        audioPicker.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
        audioPicker.widthAnchor.constraint(equalToConstant: preferedConstant).isActive = true
    }
}

@available(tvOS 13.0, *)
extension KSAudioInfoViewController: AVRoutePickerViewDelegate {
    func routePickerViewWillBeginPresentingRoutes(_ routePickerView: AVRoutePickerView) {
        print(routePickerView)
    }
    func routePickerViewDidEndPresentingRoutes(_ routePickerView: AVRoutePickerView) {
        print(routePickerView)
    }
}


extension MediaPlayerTrack {
    var title:String {
        let codecName = self.codecType.string.uppercased().trimmingCharacters(in: .whitespaces)
        return self.name + "[ \(self.language ?? "") - \(codecName) - \(self.channels ?? 0) ]"
    }
}
