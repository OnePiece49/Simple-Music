//
//  SearchYTM.swift
//  LAS_MUSIC_009
//
//  Created by Đức Anh Trần on 25/08/2023.
//

import Foundation

typealias SearchResultCompletion = ((ytModels: [YTMusicModel]?, token: String?, trackingParams: String?)) -> Void

enum YTSearchFilter {
	case music, mv, album

	var params: String {
		switch self {
			case .music: return "EgWKAQIIAWoKEAkQBRAKEAMQBA%3D%3D"
			case .mv: return "EgWKAQIQAWoKEAkQChAFEAMQBA%3D%3D"
			case .album: return "EgWKAQIYAWoKEAkQChAFEAMQBA%3D%3D"
		}
	}
}

enum YTSearchType {
	case firstTime(filter: YTSearchFilter, query: String)
	case continuation(token: String, trackingParams: String)
}

protocol SearchYTM: APIRequest {
	func search(query: String, filter: YTSearchFilter, completion: @escaping SearchResultCompletion)
	func searchContinuation(filter: YTSearchFilter, token: String, trackingParams: String, completion: @escaping SearchResultCompletion)
}

extension SearchYTM {
	func search(query: String,
				filter: YTSearchFilter,
				completion: @escaping SearchResultCompletion) {

		let client = YoutubeClient.iosClient()
		let body: [String: Any] = [
			"context": [
				"client": [
					"gl": "VN" ,
					"hl": "vi" ,
					"clientName": client.clientName,
					"clientVersion": client.clientVersion
				]
			],
			"query": query,
			"params": filter.params
		]

		let endpoint = YTMEndPoint(baseURL: YTM_BASE_SEARCH_URL, body: body)

		guard let request = endpoint.getURLRequest() else {
			completion((nil, nil, nil))
			return
		}

		self.makeRequest(type: YTSearchResponse.self, request: request) { response in
			guard let response = response else {
				completion((nil, nil, nil))
				return
			}

			let searchParser = YTMSearchParser(response: response, filter: filter)
			let tuple = (searchParser.toMusicModel(), searchParser.getToken(), searchParser.getTrackingParams())
			completion(tuple)
		}
	}

	func searchContinuation(filter: YTSearchFilter,
							token: String,
							trackingParams: String,
							completion: @escaping SearchResultCompletion) {

		let client = YoutubeClient.iosClient()
		let body: [String: Any] = [
			"context": [
				"client": [
					"gl": "VN" ,
					"hl": "vi" ,
					"clientName": client.clientName,
					"clientVersion": client.clientVersion
				]
			]
		]

		let queryItems: [URLQueryItem] = [
			.init(name: "key", value: YTM_KEY),
			.init(name: "ctoken", value: token),
			.init(name: "continuation", value: token),
			.init(name: "type", value: "next"),
			.init(name: "itct", value: trackingParams)
		]

		let endpoint = YTMEndPoint(baseURL: YTM_BASE_SEARCH_URL, queryItems: queryItems, body: body)

		guard let request = endpoint.getURLRequest() else {
			completion((nil, nil, nil))
			return
		}

		self.makeRequest(type: YTSearchResponse.self, request: request) { response in
			guard let response = response else {
				completion((nil, nil, nil))
				return
			}

			let searchParser = YTMSearchParser(response: response, filter: filter)
			let tuple = (searchParser.toMusicModel(), searchParser.getToken(), searchParser.getTrackingParams())
			completion(tuple)
		}
	}

}
