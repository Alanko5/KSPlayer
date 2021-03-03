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
    private let audioPicker = InfoTableView<MediaPlayerTrack,InfoTableCell>()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.readAudioTracks()
    }
    
    private func configureView() {
        self.title = "audio"
        self.view.addSubview(self.contentView)
        self.view.addSubview(self.audioPicker)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.audioPicker.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20).isActive = true
        self.contentView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -20).isActive = true
        self.contentView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20).isActive = true
        self.heightConstraint = self.contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        
        self.audioPicker.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 150).isActive = true
        self.audioPicker.heightAnchor.constraint(equalToConstant: 275).isActive = true
        self.audioPicker.widthAnchor.constraint(equalToConstant: 400).isActive = true
        self.audioPicker.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        self.heightConstraint?.isActive = true
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
    private func readAudioTracks() {
        if let player = self.player {
            let tracks = player.tracks(mediaType: .audio)
            self.audioPicker.set(items: tracks) { (cell, track) in
                cell.set(title: track.title, isSelected: track.isEnabled)
            } selectHandler: { [weak self] selectedTrack in
                self?.player?.select(track: selectedTrack)
            }
        }
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


final class InfoTableView<T, Cell: UITableViewCell>: UITableView, UITableViewDelegate, UITableViewDataSource {
    var items: [T] = [] {
        didSet {
            self.reloadData()
        }
    }
    var selectHandler: ((T) -> Void)?
    var configure: ((Cell, T) -> Void)?
    
    private var selectedIndex:IndexPath?
    
    init(items: [T], configure: @escaping (Cell, T) -> Void, selectHandler: @escaping (T) -> Void) {
        self.items = items
        self.selectHandler = selectHandler
        self.configure = configure
        super.init(frame: .zero, style: .plain)
        self.delegate = self
        self.dataSource = self
        self.register(Cell.self, forCellReuseIdentifier: "Cell")
    }
    
    init() {
        super.init(frame: .zero, style: .plain)
        self.delegate = self
        self.dataSource = self
        self.register(Cell.self, forCellReuseIdentifier: "Cell")
    }
    
    func set(items: [T], configure: @escaping (Cell, T) -> Void, selectHandler: @escaping (T) -> Void) {
        self.items = items
        self.configure = configure
        self.selectHandler = selectHandler
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func scrollToSelectedIndex(animated: Bool = false) {
        if let selectedIndex = self.selectedIndex {
            self.scrollToRow(at: selectedIndex, at: .middle, animated: animated)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! Cell
        let item = items[indexPath.row]
        self.configure?(cell, item)
        if cell.isSelected {
            self.selectedIndex = indexPath
        }
        cell.focusStyle = .custom
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = items[indexPath.row]
        self.selectHandler?(item)
    }
}


final class InfoTableCell: UITableViewCell {
    private let titleLabel: UILabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureViews()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configureViews()
    }
    
    func set(title:String, isSelected:Bool) {
        self.titleLabel.text = isSelected ? "✔" + title : title
        self.isSelected = isSelected
        self.updateFont()
    }
    
    private func configureViews() {
        self.addSubview(self.titleLabel)
        self.titleLabel.frame = self.frame
        self.titleLabel.textColor = .darkGray
        self.titleLabel.font = UIFont.systemFont(ofSize: 31, weight: .regular)
    }
    
    private func updateFont() {
        if self.isSelected {
            self.titleLabel.font = UIFont.systemFont(ofSize: 31, weight: .semibold)
        } else {
            self.titleLabel.font = UIFont.systemFont(ofSize: 31, weight: .regular)
        }
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        if context.nextFocusedView === self {
            coordinator.addCoordinatedAnimations({
                self.titleLabel.textColor = .white
                self.contentView.backgroundColor = .clear
                self.backgroundColor = .clear
            }, completion: nil)
        }
        else {
            coordinator.addCoordinatedAnimations({
                self.titleLabel.textColor = .darkGray
                self.updateFont()
            }, completion: nil)
        }
    }
}
