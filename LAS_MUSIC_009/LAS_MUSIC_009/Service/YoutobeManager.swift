//
//  YoutubeManager.swift
//  Learning-YoutubeAPI
//
//  Created by Đức Anh Trần on 22/08/2023.
//

import Foundation

//enum YTSearchFilter {
//    case music
//    case mv
//
//    var params: String {
//        switch self {
//            case .music: return "EgWKAQIIAWoKEAkQBRAKEAMQBA%3D%3D"
//            case .mv: return "EgWKAQIQAWoKEAkQChAFEAMQBA%3D%3D"
//        }
//    }
//}
//
//enum YTSearchType {
//    case firstTime(filter: YTSearchFilter, query: String)
//    case continuation(token: String, trackingParams: String)
//}
//
//
//
//protocol APIRequest {
//    func makeRequest<T: Codable>(type: T.Type, request: URLRequest, completion: @escaping (T?) -> Void)
//}
//
//extension APIRequest {
//    func makeRequest<T: Codable>(type: T.Type, request: URLRequest, completion: @escaping (T?) -> Void) {
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                DispatchQueue.main.async { completion(nil) }
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode) else {
//                DispatchQueue.main.async { completion(nil) }
//                return
//            }
//
//            do {
//                let response = try JSONDecoder().decode(T.self, from: data)
//                DispatchQueue.main.async { completion(response) }
//
//            } catch {
//                DispatchQueue.main.async { completion(nil) }
//            }
//        }.resume()
//    }
//}
//
//class YoutubeManager: APIRequest {
//
//    static let shared = YoutubeManager()
//
//    private let REQUEST_KEY = "AIzaSyBAETezhkwP0ZWA02RsqT1zu78Fpt0bC_s"
//
//    typealias SearchResultCompletion = ((ytModels: [YTSearchModel]?, token: String?, trackingParams: String?)) -> Void
//
//    // MARK: - Public
//    func searchFirstData(query: String,
//                         filter: YTSearchFilter,
//                         completion: @escaping SearchResultCompletion) {
//
//        let searchType: YTSearchType = .firstTime(filter: filter, query: query)
//
//        guard let request = requestBuilder(searchType: searchType) else {
//            completion((nil, nil, nil))
//            return
//        }
//
//        self.makeRequest(type: YTRootResponse.self, request: request) { [weak self] response in
//            guard let self = self, let response = response else {
//                completion((nil, nil, nil))
//                return
//            }
//            let tuple = self.convertToYTSearchModel(response: response)
//            completion(tuple)
//        }
//    }
//
//    func searchContinuationData(token: String,
//                                trackingParams: String,
//                                completion: @escaping SearchResultCompletion) {
//
//        let searchType: YTSearchType = .continuation(token: token, trackingParams: trackingParams)
//
//        guard let request = requestBuilder(searchType: searchType) else {
//            completion((nil, nil, nil))
//            return
//        }
//
//        self.makeRequest(type: YTRootResponse.self, request: request) { [weak self] response in
//            guard let self = self, let response = response else {
//                completion((nil, nil, nil))
//                return
//            }
//            let tuple = self.convertToYTSearchModel(response: response)
//            completion(tuple)
//        }
//    }
//
//    // MARK: - Private
//    private func requestBuilder(searchType: YTSearchType) -> URLRequest? {
//        var components = URLComponents()
//
//        var queryItems: [URLQueryItem] = [
//            URLQueryItem(name: "key", value: REQUEST_KEY)
//        ]
//        var httpBody: Data?
//
//        switch searchType {
//            case .firstTime(let filter, let query):
//                httpBody = constructBodyData(query: query, filter: filter)
//
//            case .continuation(let token, let trackingParams):
//                httpBody = constructBodyData(query: nil, filter: nil)
//
//                queryItems.append(contentsOf: [
//                    URLQueryItem(name: "ctoken", value: token),
//                    URLQueryItem(name: "continuation", value: token),
//                    URLQueryItem(name: "type", value: "next"),
//                    URLQueryItem(name: "itct", value: trackingParams)
//                ])
//        }
//
//        components.scheme = "https"
//        components.host = "music.youtube.com"
//        components.path = "/youtubei/v1/search"
//        components.queryItems = queryItems
//
//        guard let url = components.url else { return nil }
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = httpBody
//        return request
//    }
//
//    private func constructBodyData(query: String?, filter: YTSearchFilter?) -> Data? {
//        let countryCode = Locale.current.regionCode ?? "US"
//        let language = Locale.preferredLanguages.first?.split(separator: "-").first ?? "en"
//
//        var json: [String: Any] = [
//            "context": [
//                "client": [
//                    "gl": countryCode,
//                    "hl": language,
//                    "clientName": "IOS_MUSIC",
//                    "clientVersion": "5.26.1"
//                ]
//            ]
//        ]
//
//        if let query = query, let filter = filter {
//            json["query"] = query
//            json["params"] = filter.params
//        }
//
//        guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else { return nil }
//        return data
//    }
//
//    private func convertToYTSearchModel(response: YTRootResponse) -> ([YTSearchModel]?, String?, String?) {
//
//        var musicRenderer: MusicShelfRenderer?
//        if let contents = response.contents {
//            musicRenderer = contents.tabbedSearchResultsRenderer?.tabs?[0]
//                .tabRenderer?.content?.sectionListRenderer?.contents?[0].musicShelfRenderer
//
//        } else if let continuation = response.continuationContents {
//            musicRenderer = continuation.musicShelfContinuation
//        }
//
//        guard let contents = musicRenderer?.contents else { return (nil, nil, nil) }
//
//        var searchModels: [YTSearchModel] = []
//
//        for musicItem in contents {
//            let videoId = musicItem.musicTwoColumnItemRenderer?.navigationEndpoint?.watchEndpoint?.videoID
//            let thumnailUrl = musicItem.musicTwoColumnItemRenderer?.thumbnail?.musicThumbnailRenderer?.thumbnail?.thumbnails?.first?.url
//            let title = musicItem.musicTwoColumnItemRenderer?.title?.runs?.first?.text
//            let duration = musicItem.musicTwoColumnItemRenderer?.subtitle?.runs?.last?.text
//            let artist = musicItem.musicTwoColumnItemRenderer?.subtitle?.runs?.first?.text
//
//            let model = YTSearchModel(videoId: videoId, thumnailUrl: thumnailUrl,
//                                      videoTitle: title, duration: duration, artist: artist)
//            searchModels.append(model)
//        }
//
//        let token = musicRenderer?.continuations?[0].nextContinuationData?.continuation
//        let params = musicRenderer?.continuations?[0].nextContinuationData?.clickTrackingParams
//
//        return (searchModels, token, params)
//    }
//
//}
