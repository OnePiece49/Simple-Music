//
//  YTMSearchParser.swift
//  LAS_MUSIC_009
//
//  Created by Đức Anh Trần on 25/08/2023.
//

import Foundation

struct YTMSearchParser {

	private let response: YTSearchResponse
	private let filter: YTSearchFilter
	private var musicRenderer: SearchMusicShelfRenderer?

	init(response: YTSearchResponse, filter: YTSearchFilter) {
		self.response = response
		self.filter = filter

		if let contents = response.contents {
			self.musicRenderer = contents.tabbedSearchResultsRenderer?.tabs?[0]
				.tabRenderer?.content?.sectionListRenderer?.contents?[0].musicShelfRenderer
		} else if let continuation = response.continuationContents {
			self.musicRenderer = continuation.musicShelfContinuation
		}
	}

	func toMusicModel() -> [YTMusicModel]? {
		guard let contents = musicRenderer?.contents else { return nil }
		var searchModels: [YTMusicModel] = []

		for (index, _) in contents.enumerated() {
			let videoId = getVideoId(index: index)
			let thumnailUrl = getThumnailUrl(index: index)
			let title = getTitle(index: index)
			let duration = getDuration(index: index)
			let artist = getArtist(index: index)

			let model = YTMusicModel(videoId: videoId, thumnailUrl: thumnailUrl,
									 videoTitle: title, duration: duration, artist: artist)
			searchModels.append(model)
		}
		return searchModels
	}

	func toAlbumModel() -> YTAblumModel {
		let browseId = getBrowseId()
		let title = getTitle(index: 0)
		let artist = getArtist(index: 0)
		let thumbnail = getThumnailUrl(index: 0)
		return YTAblumModel(browseId: browseId, title: title, artist: artist, thumbnail: thumbnail)
	}

	func getToken() -> String? {
		return musicRenderer?.continuations?.first?
			.nextContinuationData?.continuation
	}

	func getTrackingParams() -> String? {
		return musicRenderer?.continuations?.first?
			.nextContinuationData?.clickTrackingParams
	}

	// MARK: - Private
	private func getTitle(index: Int) -> String? {
		return musicRenderer?.contents?[index]
			.musicTwoColumnItemRenderer?.title?.runs?.first?.text
	}

	private func getArtist(index: Int) -> String? {
		if filter == .album {
			return musicRenderer?.contents?[index]
				.musicTwoColumnItemRenderer?.subtitle?.runs?.last?.text
		} else {
			return musicRenderer?.contents?[index]
				.musicTwoColumnItemRenderer?.subtitle?.runs?.first?.text
		}
	}

	private func getThumnailUrl(index: Int) -> String? {
		return musicRenderer?.contents?[index]
			.musicTwoColumnItemRenderer?.thumbnail?
			.musicThumbnailRenderer?.thumbnail?.thumbnails?.last?.url
	}

	private func getDuration(index: Int) -> String? {
		if filter == .music {
			return musicRenderer?.contents?[index]
				.musicTwoColumnItemRenderer?.subtitle?.runs?.last?.text
		}
		return nil
	}

	private func getVideoId(index: Int) -> String? {
		return musicRenderer?.contents?[index]
			.musicTwoColumnItemRenderer?.navigationEndpoint?
			.watchEndpoint?.videoId
	}

	private func getBrowseId(index: Int = 0) -> String? {
		if filter == .album {
			return musicRenderer?.contents?[index]
				.musicTwoColumnItemRenderer?.navigationEndpoint?
				.browseEndpoint?.browseId
		}
		return nil
	}

}
