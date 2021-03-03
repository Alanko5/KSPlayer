//
//  MasterViewController.swift
//  Demo
//
//  Created by kintan on 2018/4/15.
//  Copyright © 2018年 kintan. All rights reserved.
//

import KSPlayer
import UIKit
class TableViewCell: UITableViewCell {
    var nameLabel: UILabel
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        nameLabel = UILabel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MasterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var objects = [KSPlayerResource]()
    var tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        tableView.delegate = self
        tableView.dataSource = self
        if let path = Bundle.main.path(forResource: "567082ac3ae39699f68de4fd2b7444b1e045515a", ofType: "mp4") {
            objects.append(KSPlayerResource(url: URL(fileURLWithPath: path), name: "Local video"))
        }
        if let path = Bundle.main.path(forResource: "google-help-vr", ofType: "mp4") {
            let options = KSOptions()
            options.display = .vr
            objects.append(KSPlayerResource(url: URL(fileURLWithPath: path), options: options, name: "Local panoramic video"))
        }
        if let path = Bundle.main.path(forResource: "Polonaise", ofType: "flac") {
            objects.append(KSPlayerResource(url: URL(fileURLWithPath: path), name: "Local audio "))
        }
        if let path = Bundle.main.path(forResource: "video-h265", ofType: "mkv") {
            objects.append(KSPlayerResource(url: URL(fileURLWithPath: path), name: "h265 mkv video"))
        }
        if let url = URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4") {
            let res0 = KSPlayerResourceDefinition(url: url, definition: "HD")
            let res1 = KSPlayerResourceDefinition(url: URL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8")!, definition: "SD")
            let asset = KSPlayerResource(name: "http video", definitions: [res0, res1], cover: URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Big_buck_bunny_poster_big.jpg/848px-Big_buck_bunny_poster_big.jpg"))
            objects.append(asset)
        }

        if let url = URL(string: "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8") {
            objects.append(KSPlayerResource(url: url, options: KSOptions(), name: "m3u8 video"))
        }

        if let url = URL(string: "http://aldirect.hls.huya.com/huyalive/30765679-2504742278-10757786168918540288-3049003128-10057-A-0-1_1200.m3u8") {
            objects.append(KSPlayerResource(url: url, options: KSOptions(), name: "Live streaming "))
        if let url = URL(string: "https://bitmovin-a.akamaihd.net/content/dataset/multi-codec/hevc/stream_fmp4.m3u8") {
            objects.append(KSPlayerResource(url: url, options: KSOptions(), name: "fmp4"))
        }

        if let url = URL(string: "http://116.199.5.51:8114/00000000/hls/index.m3u8?Fsv_chan_hls_se_idx=188&FvSeid=1&Fsv_ctype=LIVES&Fsv_otype=1&Provider_id=&Pcontent_id=.m3u8") {
            objects.append(KSPlayerResource(url: url, options: KSOptions(), name: "tvb video"))
        }

        if let url = URL(string: "http://dash.edgesuite.net/akamai/bbb_30fps/bbb_30fps.mpd") {
            objects.append(KSPlayerResource(url: url, options: KSOptions(), name: "dash video"))
        }
        if let url = URL(string: "https://devstreaming-cdn.apple.com/videos/wwdc/2019/244gmopitz5ezs2kkq/244/hls_vod_mvp.m3u8") {
            let options = KSOptions()
            options.formatContextOptions["timeout"] = 0
            objects.append(KSPlayerResource(url: url, options: options, name: "https video"))
        }

        if let url = URL(string: "rtsp://wowzaec2demo.streamlock.net/vod/mp4:BigBuckBunny_115k.mov") {
            let options = KSOptions()
            options.formatContextOptions["timeout"] = 0
            objects.append(KSPlayerResource(url: url, options: options, name: "rtsp video"))
        }

        if let path = Bundle.main.path(forResource: "Polonaise", ofType: "flac") {
            objects.append(KSPlayerResource(url: URL(fileURLWithPath: path), name: "Music player interface"))
        }

        tableView.rowHeight = 50
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View

    func numberOfSections(in _: UITableView) -> Int {
        1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        objects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let cell = cell as? TableViewCell {
            cell.nameLabel.text = objects[indexPath.row].name
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if #available(tvOS 13.0, *), UIDevice.current.userInterfaceIdiom == .tv {
            let controller = KStvOSViewController()
            controller.set(objects[indexPath.row])
            navigationController?.pushViewController(controller, animated: true)
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        if let split = splitViewController, let nav = split.viewControllers.last as? UINavigationController, let detail = nav.topViewController as? DetailProtocol {
            detail.resource = objects[indexPath.row]
            #if os(iOS)
            detail.navigationItem.leftBarButtonItem = split.displayModeButtonItem
            detail.navigationItem.leftItemsSupplementBackButton = true
            #endif
            split.preferredDisplayMode = .primaryHidden
            return
        }
        let controller: DetailProtocol
        if indexPath.row == objects.count - 1 {
            controller = AudioViewController()
        } else {
            controller = DetailViewController()
        }
        controller.resource = objects[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
