//
//  AudioManager.swift
//  Spotify
//
//  Created by Salvador on 05/02/23.
//

import Foundation
import AVFoundation

class AudioManager {
    
    static let sharedInstance = AudioManager()
    
    init() {
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(playerDidFinishPlaying),
                         name: .AVPlayerItemDidPlayToEndTime,
                         object: nil
            )
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        nextTrack()
    }
    
    var player: AVPlayer?
    
    var currentTrack: AudioTrack?
    
    var currentTrackIndex: Int {
        return playlist?.firstIndex(where: {$0.name == currentTrack?.name}) ?? 0
    }
    
    var playlist: [AudioTrack]?

    var repeatActive = false
    var shuffleActive = false
    
    func setPlaylist(list: [AudioTrack]) {
        self.playlist = list
    }
    
    func playTrack(track: AudioTrack) {
        guard let url = URL(string: track.previewUrl ?? "") else {
            return
        }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            let playerItem: AVPlayerItem = AVPlayerItem(url: url)
            
            player?.pause()
            player = AVPlayer(playerItem: playerItem)
            
            player?.play()
            player?.volume = 1
            self.currentTrack = track
            NotificationCenter.default.post(name: Notification.Name("song"), object: track)
        } catch {

        }
    }
    
    public func nextTrack() {

        if repeatActive, let playlist = playlist  {
            playTrack(track: playlist[currentTrackIndex])
            return
        }

        if currentTrack != nil, let playlist = playlist {

            if repeatActive {
                playTrack(track: playlist[currentTrackIndex])
                return
            }

            if shuffleActive {
                var index = currentTrackIndex

                while index == currentTrackIndex {
                    index = Int.random(in: 1..<playlist.count)
                }

                playTrack(track: playlist[index])
                return
            }

            let index = currentTrackIndex + 1
            if index >= 0 && index < playlist.count {
                playTrack(track: playlist[index])
            }
        }
    }
    
    public func previousTrack() {
        if currentTrack != nil, let playlist = playlist {
            let index = currentTrackIndex - 1
            if index >= 0 && index < playlist.count {
                playTrack(track: playlist[index])
            }
        }
    }
    
    public func isPlaying() -> Bool {
        if player?.timeControlStatus == .playing {
            return true
        }
        return false
    }
    
    public func pause() {
        if let player = player {
            player.pause()
        }
    }
    
    public func resume() {
        if let player = player {
            player.play()
        }
    }
    
}
