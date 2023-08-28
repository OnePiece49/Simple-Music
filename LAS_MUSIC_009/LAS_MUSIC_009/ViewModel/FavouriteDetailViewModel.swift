//
//  FavouriteDetailViewModel.swift
//  LAS_MUSIC_009
//
//  Created by Đức Anh Trần on 16/08/2023.
//

import Foundation
import RealmSwift

class FavouriteDetailViewModel {

	private let realm = RealmService.shared.realmObj()
    let favouritePlaylist = RealmService.shared.favouritePlaylist()

	var musics: [MusicModel] = []
	var onUnFavouriteMusic: ((_ indexPath: IndexPath) -> Void)?

	var numberOfItems: Int {
		return musics.count
	}

	func getMusicModel(at indexPath: IndexPath) -> MusicModel {
		return musics[indexPath.row]
	}

	func loadAllMusics() {
		guard let favouritePlaylist = favouritePlaylist else { return }
		musics = favouritePlaylist.musics.toArray(ofType: MusicModel.self)
	}

	func unFavouriteMusic(at indexPath: IndexPath) -> Bool {
		guard let realm = realm, let favouritePlaylist = favouritePlaylist else { return false }
		let music = musics[indexPath.row]

		do {
			musics.remove(at: indexPath.row)

			try realm.write{
				music.isFavorited = false
				favouritePlaylist.musics.remove(at: indexPath.row)
			}

			onUnFavouriteMusic?(indexPath)
			return true

		} catch {
			return false
		}
	}
}
