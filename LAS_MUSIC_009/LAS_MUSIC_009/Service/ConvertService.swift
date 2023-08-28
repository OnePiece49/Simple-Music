//
//  ConvertService.swift
//  LAS_MUSIC_009
//
//  Created by Tiến Việt Trịnh on 22/08/2023.
//

import UIKit

class ConvertService {
    static let shared = ConvertService()
    
    func convertYTSearchToMSModel(ytSearch: YTMusicModel) -> MusicModel {
        let music = MusicModel()
        music.sourceType = .online
        music.name = ytSearch.videoTitle ?? "Updating"
        music.videoID = ytSearch.videoId
        music.durationString = ytSearch.duration
        music.artist = ytSearch.artist
        music.thumbnailURL = ytSearch.thumnailUrl
        music.creationDate = Date().timeIntervalSince1970
        music.type = .video
        return music
    }
    
    func convertArrYTSearchToArrMSModel(ytSearchs: [YTMusicModel]) -> [MusicModel] {
        var musics: [MusicModel] = []
        ytSearchs.forEach { youtube in
            let music = self.convertYTSearchToMSModel(ytSearch: youtube)
            musics.append(music)
        }
    
        return musics
    }
}
