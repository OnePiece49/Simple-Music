//
//  YTCommonModel.swift
//  LAS_MUSIC_009
//
//  Created by Đức Anh Trần on 25/08/2023.
//

import Foundation

// MARK: - Thumbnail
struct MusicThumbnailRenderer: Codable {
	let thumbnail: MusicThumbnailRendererThumbnail?
}

struct MusicThumbnailRendererThumbnail: Codable {
	let thumbnails: [Thumbnail]?
}

struct Thumbnail: Codable {
	let url: String?
	let width, height: Int?
}

// MARK: - Endpoint
struct NavigationEndpoint: Codable {
	let watchEndpoint: WatchEndpoint?
	let browseEndpoint: BrowseEndpoint?
}

struct WatchEndpoint: Codable {
	let videoId: String?
	let playlistId: String?
}

struct BrowseEndpoint: Codable {
	let browseId: String?
	let params: String?
}

// MARK: - Title
struct Title: Codable {
	let runs: [Run]?
}

struct Run: Codable {
	let text: String?
}

// MARK: - Continuation
struct Continuation: Codable {
	let nextContinuationData: NextContinuationData?
}

struct NextContinuationData: Codable {
	let continuation, clickTrackingParams: String?
}
