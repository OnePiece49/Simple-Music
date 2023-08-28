//
//  PlayerViewModel.swift
//  LAS_MUSIC_009
//
//  Created by Tiến Việt Trịnh on 16/08/2023.
//


import UIKit
import AVFoundation
import RealmSwift

enum StatusNext: Int, CaseIterable {
    case isLastSong
    case replayFromStart
    case normal
}

enum ReplayMode: Int, CaseIterable {
    case none
    case ones
    case all
    
    var image: UIImage? {
        switch self {
        case .none:
            return UIImage(named: AssetConstant.ic_not_replay)?.withRenderingMode(.alwaysOriginal)
        case .ones:
            return UIImage(named: AssetConstant.ic_replay_ones)?.withRenderingMode(.alwaysOriginal)
        case .all:
            return UIImage(named: AssetConstant.ic_replay_all)?.withRenderingMode(.alwaysOriginal)
        }
    }
}

enum RandomMode: Int, CaseIterable {
    case none
    case random
    
    var image: UIImage? {
        switch self {
        case .none:
            return UIImage(named: AssetConstant.ic_not_random)?.withRenderingMode(.alwaysOriginal)
        case .random:
            return UIImage(named: AssetConstant.ic_random_selected)?.withRenderingMode(.alwaysOriginal)
        }
    }
}

class PlayerViewModel {
    
    private let realm = RealmService.shared.realmObj()
    var playlist: PlaylistModel!
    
    var currentIndex: Int?
    var musics: [MusicModel] = []
    
    var replayMode: ReplayMode = .none
    var randomMode: RandomMode = .none
    
    var bindingNewPlaylist: (() -> Void)?
    
    var currentMusic: MusicModel? {
        guard let currentIndex = currentIndex else {return nil}
        return musics[currentIndex]
    }
    
    var imageReplay: UIImage? {
        return replayMode.image
    }
    
    var imageShuffle: UIImage? {
        return randomMode.image
    }
    
    var isOffline: Bool {
        return currentMusic?.sourceType == .offline
    }
    
    var currentURL: URL? {
        return currentMusic?.absolutePath
    }
    
    var currentVideoId: String? {
        return currentMusic?.videoID
    }
    
    func getCurrentPlaylist() -> PlaylistModel {
        let playList = PlaylistModel()
        try? realm?.write({
            playList.musics.append(objectsIn: musics)
        })

        return playList
    }
    
    var imagePosterString: URL? {
        return URL(string: currentMusic?.thumbnailURL ?? "")
    }
    
    var isLastSong: Bool {
        guard let currentIndex = currentIndex else {return false}
        return (currentIndex + 1) == musics.count
    }
    
    var nameArtist: String? {
        return currentMusic?.artist
    }

    var nameMusic: String? {
        return currentMusic?.name
    }
    
    var isLiked: Bool {
        return currentMusic?.isFavorited ?? false
    }
    
    var likeImage: UIImage? {
        return isLiked ? UIImage(named: AssetConstant.ic_heart_fill)?.withRenderingMode(.alwaysOriginal) : UIImage(named: AssetConstant.ic_heart)?.withRenderingMode(.alwaysOriginal)
    }
    
    var numberMusics: Int {
        return musics.count
    }
    
    var replayImage: UIImage? {
        return replayMode.image
    }
    
    var randomImage: UIImage? {
        return randomMode.image
    }
    
    var duration: String {
        guard let currentMusic = currentMusic else {return "0:00"}
        if isOffline {
            return CMTime(seconds: currentMusic.durationDouble, preferredTimescale: 1).getTimeString() ?? "0:00"
        } else {
            return currentMusic.durationString ?? "0:00"
        }
    }
    
    var isVideoType: Bool {
        return currentMusic?.type == .video
    }
    
    func updateReplayMode() {
        if self.replayMode == .none {
            self.replayMode = .ones
        } else if self.replayMode == .ones {
            self.replayMode = .all
        } else if self.replayMode == .all {
            self.replayMode = .none
        }
    }
    
    func shuffle() {
        switch randomMode {
        case .none:
            self.musics = playlist.musics.shuffled()
            self.randomMode = .random
        case .random:
            self.musics = playlist.musics.toArray(ofType: MusicModel.self)
            self.randomMode = .none
        }
        
        if isOffline {
            self.currentIndex = musics.firstIndex(where: { ms in
                return currentMusic?.id == ms.id
            })
        } else {
            self.currentIndex = musics.firstIndex(where: { ms in
                return currentMusic?.videoID == ms.videoID
            })
        }
        
    }
    
    func playMusic(music: MusicModel) -> Bool {
        print("DEBUG: \(music.name) kkkkkkkkkkkkk =======")
        self.currentIndex = musics.firstIndex(where: { ms in
            if self.isOffline {
                return music.absolutePath == ms.absolutePath
            } else {
                return music.videoID == ms.videoID
            }
            
        })
        
        return true
    }
    
    func itemDidFinishPlay() -> StatusNext {
        switch replayMode {
        case .all, .none:
            let status = nextSong()
            return status
        case .ones:
            return .normal
        }
    }
    
    func nextSong() -> StatusNext {
        switch replayMode {
        case .none:
            guard var currentItem = currentIndex else { return .normal}
            if currentItem == (numberMusics - 1) {
                return .isLastSong
            }
            
            currentItem += 1
            self.currentIndex = currentItem
            return .normal
            
        case .ones, .all:
            guard var currentItem = currentIndex else {return .normal}
            if currentItem == (numberMusics - 1) {
                self.currentIndex = 0
                return .normal
            }
            
            currentItem += 1
            self.currentIndex = currentItem
            return .normal
            
        }
    }
    
    func convertVideo(type: ConvertAudioType, completion: @escaping((_ success: Bool) -> Void)) {
        ConvertAudioManager.shared.convertAudio(inputUrl: self.currentURL!,
                                                type: type) { success, outputUrl in
            DispatchQueue.main.async {
                if success {
                    let asset = AVAsset(url: outputUrl!)
                    let music = MusicModel()
                    
                    music.name = outputUrl?.lastPathComponent ?? ""
                    music.durationDouble = asset.duration.seconds
                    music.sourceType = .offline
                    music.type = .audio
                    music.relativePath = outputUrl?.path.replacingOccurrences(of: URL.document().path, with: "")
                    music.creationDate = Date().timeIntervalSince1970
                    
                    try? self.realm?.write({
                        self.realm?.add(music)
                        RealmService.shared.audioConvertPlaylist()?.musics.append(music)
                    })
                }
                
                completion(success)
            }
        }
    }
    
    func backSong() -> Bool {
        guard var currentItem = currentIndex else {
            return false}
        if currentItem == 0 {
            return false
        }
        
        currentItem -= 1
        self.currentIndex = currentItem
        return true
    }
    
    func unfavouriteMusic(music: MusicModel) {
        
        try? realm?.write({
            musics.forEach { ms in
                if music.sourceType == .offline && music.id == ms.id {
                    music.isFavorited = false
                } else if music.sourceType == .online && music.videoID == ms.videoID {
                    music.isFavorited = false
                }
            }
        })
        
    }
    
    func likeMusic() -> Bool{
        guard let currentMusic = currentMusic else {return false}
        var success = false
        if isLiked {
            success = RealmService.shared.removeFromFavoutite(music: currentMusic)
            try? realm?.write({
                self.currentMusic?.isFavorited = false
            })
        } else {
            success = RealmService.shared.saveToFavourite(music: currentMusic, shoudSave: !isOffline)
            try? realm?.write({
                self.currentMusic?.isFavorited = true
            })
            
        }
        return success
    }
    
    func newPlaylist(playlist: PlaylistModel, currentMusic: MusicModel) {
        self.playlist = playlist
        self.randomMode = .none
        self.musics = self.playlist.musics.toArray(ofType: MusicModel.self)
        self.currentIndex = playlist.musics.firstIndex(where: { ms in
            return currentMusic.id == ms.id
        })
        
        self.bindingNewPlaylist?()
    }
    
    init(playlist: PlaylistModel, currentMusic: MusicModel) {
        self.playlist = playlist
        self.musics = self.playlist.musics.toArray(ofType: MusicModel.self)
        self.currentIndex = playlist.musics.firstIndex(where: { ms in
            return currentMusic.id == ms.id
        })
    }
}

