//
//  URLRequestBuilder.swift
//  LAS_MUSIC_009
//
//  Created by Đức Anh Trần on 25/08/2023.
//

import Foundation

enum HTTPMethod: String {
	case post = "POST"
}

protocol URLRequestBuilder {
	func constructRequest(httpMethod: HTTPMethod, url: URL,
						  header: [String: String], body: [String: Any]) -> URLRequest?
}

extension URLRequestBuilder {
	func constructRequest(httpMethod: HTTPMethod,
						  url: URL,
						  header: [String: String],
						  body: [String: Any]) -> URLRequest? {

		guard let data = try? JSONSerialization.data(withJSONObject: body, options: []) else { return nil }

		var request = URLRequest(url: url)
		request.httpMethod = httpMethod.rawValue
		request.allHTTPHeaderFields = header
		request.httpBody = data
		return request
	}
}
