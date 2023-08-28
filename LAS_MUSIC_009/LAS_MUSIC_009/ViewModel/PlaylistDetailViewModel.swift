//
//  PlaylistDetailViewModel.swift
//  LAS_MUSIC_009
//
//  Created by Đức Anh Trần on 16/08/2023.
//

import Foundation
import RealmSwift

class PlaylistDetailViewModel {

	private let realm = RealmService.shared.realmObj()

	var playlist: PlaylistModel
	var musics: [MusicModel] = []
	var didShuffle: Bool = false
	var onDeleteMusic: (() -> Void)?
	var onRenameMusic: ((_ indexPath: IndexPath) -> Void)?
	var onToggleShuffle: (() -> Void)?
	var onToggleReplay: (() -> Void)?

	init(playlist: PlaylistModel) {
		self.playlist = playlist
		self.musics = playlist.musics.toArray(ofType: MusicModel.self)
	}

	// MARK: - Public
	var numberOfItems: Int {
		return musics.count
	}

	func getMusicModel(at indexPath: IndexPath) -> MusicModel {
		return musics[indexPath.row]
	}

	func deleteMusic(at indexPath: IndexPath) -> Bool {
		guard let realm = realm else { return false }

		let music = musics[indexPath.row]
		guard let indexToRemove = playlist.musics.firstIndex(of: music) else { return false }

		do {
			musics.remove(at: indexPath.row)
			try realm.write { playlist.musics.remove(at: indexToRemove) }
			onDeleteMusic?()
			return true

		} catch {
			return false
		}
	}

	func renameMusic(at indexPath: IndexPath, name: String) -> Bool {
		guard let realm = realm else { return false }
		let music = musics[indexPath.row]

		do {
			try realm.write{ music.name = name }
			onRenameMusic?(indexPath)
			return true

		} catch {
			return false
		}
	}

	func toggleShuffleMode() {
		if didShuffle {
			musics = playlist.musics.toArray(ofType: MusicModel.self)
		} else {
			musics.shuffle()
		}
		didShuffle.toggle()
		onToggleShuffle?()
	}

	func toggleReplayMode() {

	}

}
