//
//  YTMEndPoint.swift
//  LAS_MUSIC_009
//
//  Created by Đức Anh Trần on 25/08/2023.
//

import Foundation

struct YTMEndPoint: URLRequestBuilder {
	var baseURL: String
	var httpMethod: HTTPMethod
	var	queryItems: [URLQueryItem]
	var header: [String : String]
	var body: [String : Any]

	init(baseURL: String,
		 httpMethod: HTTPMethod = .post,
		 queryItems: [URLQueryItem] = [URLQueryItem(name: "key", value: YTM_KEY)],
		 header: [String : String] = DEFAULT_HTTP_HEADER,
		 body: [String : Any]) {

		self.baseURL = baseURL
		self.httpMethod = httpMethod
		self.queryItems = queryItems
		self.header = header
		self.body = body
	}

	func getURLRequest() -> URLRequest? {
		guard let baseUrl = URL(string: baseURL),
			  let finalUrl = baseUrl.appendingQuerys(queryItems) else { return nil }
		return self.constructRequest(httpMethod: httpMethod, url: finalUrl, header: header, body: body)
	}
}
