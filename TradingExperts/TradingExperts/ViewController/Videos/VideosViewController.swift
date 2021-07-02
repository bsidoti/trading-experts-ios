//
//  VideosViewController.swift
//  TradingExperts
//
//  Created by Braden Sidoti on 1/9/18.
//  Copyright © 2018 Braden Sidoti. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import youtube_ios_player_helper

class VideosViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    var videos = [TEVideo]()
    
    var playingCell: VideoTableViewCell?
    
    class func storyboardInit() -> VideosViewController {
        let storyboard = UIStoryboard.init(name: "Videos", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "VideosViewController") as! VideosViewController
        return vc
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImage = UIImage(named: "satisfied-members-bg")!
        view.backgroundColor = UIColor(patternImage: bgImage)
        tableView.backgroundColor = UIColor.clear
        
        tableView.register(UINib(nibName: "VideoTableViewCell", bundle: nil), forCellReuseIdentifier: VideoTableViewCell.reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.delegate = self
        tableView.dataSource = self

        refreshControl.addTarget(self, action: #selector(doRefreshControl), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        tableView.refreshControl = refreshControl
//        refreshControl.tintColor = UIColor.te_green
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.refreshControl.beginRefreshing()
        refreshVideos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopPlayingVideo()
    }
    
    
    @objc func doRefreshControl() {
        refreshVideos()
    }
    
    func refreshVideos() {
        NetworkController.shared.getAllVideos(completion: { (result) in
            switch result {
            case .success(let videos):
                self.videos = videos.sorted(by: { (v1, v2) -> Bool in
                    return v1.publishedAt > v2.publishedAt
                })
                
                self.tableView.reloadData()
                
            case .failure(let error):
                let title: String
                print(error)
                if error is NetworkingError {
                    title = "Networking Error"
                } else if error is ParsingError {
                    title = "Parsing Error"
                } else {
                    title = "Error"
                }
                
                let alert = UIAlertController(title: title, message: "Error fetching Videos", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default))
                self.present(alert, animated: true)
            }
            self.refreshControl.endRefreshing()
        })
    }
    
    func stopPlayingVideo() {
        playingCell?.playerView.stopVideo()
        playingCell?.playerView.delegate = nil
        playingCell?.showLoading(loading: false)
    }
}

extension VideosViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        stopPlayingVideo()
        
        let cell = tableView.cellForRow(at: indexPath) as! VideoTableViewCell
        let video = videos[indexPath.row]
        
        playingCell = cell
        cell.showLoading(loading: true)
        
        cell.playerView.delegate = self
        cell.playerView.load(withVideoId: video.id, playerVars: ["origin": "http://www.youtube.com"])
        cell.playerView.playVideo()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.reuseIdentifier, for: indexPath) as! VideoTableViewCell
        cell.setup(video: videos[indexPath.row])
        return cell
    }
    
    //
    // this should only get called if the user minimizes the playing video
    // since we can't detect this easily, use this as a hack to stop the video
    //
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let cell = playingCell {
            cell.playerView.playerState { (state, error) in
                guard error != nil else {
                    print("YT PLAYER ERROR")
                    return
                }
                
                cell.playerView.stopVideo()
                self.playingCell = nil
            }
        }
    }
}

extension VideosViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print(error)
    }
    
    /*
     kYTPlayerStateUnstarted,
     kYTPlayerStateEnded,
     kYTPlayerStatePlaying,
     kYTPlayerStatePaused,
     kYTPlayerStateBuffering,
     kYTPlayerStateCued,
     kYTPlayerStateUnknown
     */
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        let stateName: String
        switch state {
        case .buffering:
            stateName = "buffering"
            
        case .ended:
            stateName = "ended"
            
            playingCell?.showLoading(loading: false)
            playingCell = nil
        case .paused:
            stateName = "paused"
            
            playingCell?.showLoading(loading: false)
            playingCell = nil
        case .playing:
            stateName = "playing"
            
            
            playingCell?.showLoading(loading: false)
        case .unstarted:
            stateName = "unstarted"
            
            
            playingCell?.showLoading(loading: false)
            let ac = UIAlertController(title: "Error", message: "Video not found", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        case .cued:
            stateName = "cued"
            
        // not sure when this state is triggered
        case .unknown:
            stateName = "unknown"
            // not sure when this state is triggered
            
            playingCell?.showLoading(loading: false)
            let ac = UIAlertController(title: "Error", message: "Unkown Error", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            
        @unknown default:
            stateName = "unknown"
            // not sure when this state is triggered
            
            playingCell?.showLoading(loading: false)
            let ac = UIAlertController(title: "Error", message: "Unkown Error", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        }
        
        print(stateName)
    }
}
