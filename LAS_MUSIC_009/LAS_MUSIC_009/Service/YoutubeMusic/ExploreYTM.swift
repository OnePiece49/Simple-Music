//
//  ExploreYTM.swift
//  LAS_MUSIC_009
//
//  Created by Đức Anh Trần on 25/08/2023.
//

import Foundation

protocol ExploreYTM: APIRequest {
	func getAllGenres(completion: @escaping (_ genres: [YTGenresModel])-> Void)
	func getGenresBrowseID(params: String, completion: @escaping (_ browseId: String?)-> Void)
	func getPlaylistForGenres(params: String, completion: @escaping (_ tracks: [YTMusicModel])-> Void)
}

extension ExploreYTM {
	func getAllGenres(completion: @escaping (_ genres: [YTGenresModel])-> Void) {
//		let client = YoutubeClient.iosClient()
//		let body: [String: Any] = [
//			"context": [
//				"client": [
//					"gl": "VN" ,
//					"hl": "vi" ,
//					"clientName": client.clientName,
//					"clientVersion": client.clientVersion
//				]
//			],
//			"browseId": GENRES_BROWSE_ID
//		]
//
//		let endpoint = YTMEndPoint(baseURL: YTM_BASE_BROWSE_URL, body: body)
//
//		guard let request = endpoint.getURLRequest() else {
//			completion([])
//			return
//		}
//
//		self.makeRequest(type: YTBrowseResponse.self, request: request) { response in
//			guard let response = response else {
//				completion([])
//				return
//			}
//
//			let exploreParser = YTMExploreParser(response: response)
//			guard let genres = exploreParser.toGenresModel() else {
//				completion([])
//				return
//			}
//			completion(genres)
//		}
	}

	func getGenresBrowseID(params: String, completion: @escaping (_ browseId: String?)-> Void) {
//		let client = YoutubeClient.iosClient()
//		let body: [String: Any] = [
//			"context": [
//				"client": [
//					"gl": "VN" ,
//					"hl": "vi" ,
//					"clientName": client.clientName,
//					"clientVersion": client.clientVersion
//				]
//			],
//			"browseId": GENRES_SPECIFIC_BROWSE_ID,
//			"params": params
//		]
//
//		let endpoint = YTMEndPoint(baseURL: YTM_BASE_BROWSE_URL, body: body)
//
//		guard let request = endpoint.getURLRequest() else {
//			completion(nil)
//			return
//		}
//
//		self.makeRequest(type: YTBrowseResponse.self, request: request) { response in
//			guard let response = response else {
//				completion(nil)
//				return
//			}
//
//			let exploreParser = YTMExploreParser(response: response)
//			guard let browseId = exploreParser.getBrowseIdForFirstPlaylist() else {
//				completion(nil)
//				return
//			}
//			completion(browseId)
//		}
	}

	func getPlaylistForGenres(params: String, completion: @escaping (_ tracks: [YTMusicModel])-> Void) {
//		self.getGenresBrowseID(params: params) { [weak self] browseId in
//			guard let self = self, let browseId = browseId else {
//				completion([])
//				return
//			}
//
//			let client = YoutubeClient.iosClient()
//			let body: [String: Any] = [
//				"context": [
//					"client": [
//						"gl": "VN" ,
//						"hl": "vi" ,
//						"clientName": client.clientName,
//						"clientVersion": client.clientVersion
//					]
//				],
//				"browseId": browseId,
//			]
//
//			let endpoint = YTMEndPoint(baseURL: YTM_BASE_BROWSE_URL, body: body)
//
//			guard let request = endpoint.getURLRequest() else {
//				completion([])
//				return
//			}
//
//			self.makeRequest(type: YTBrowseResponse.self, request: request) { response in
//				guard let response = response else {
//					completion([])
//					return
//				}
//
//				let exploreParser = YTMExploreParser(response: response)
//				guard let tracks = exploreParser.toSearchModel() else {
//					completion([])
//					return
//				}
//				completion(tracks)
//			}
//		}
	}

}
