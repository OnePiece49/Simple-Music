//
//  YTSearchResponse.swift
//  LAS_MUSIC_009
//
//  Created by Đức Anh Trần on 25/08/2023.
//

import Foundation

// MARK: - YTSearchResponse
struct YTSearchResponse: Codable {
	let contents: SearchContents?
	let continuationContents: ContinuationContents?
}

// MARK: - ContinuationContents
struct ContinuationContents: Codable {
	let musicShelfContinuation: SearchMusicShelfRenderer?
}

// MARK: - Contents
struct SearchContents: Codable {
	let tabbedSearchResultsRenderer: SearchTabbedResultsRenderer?
}

struct SearchTabbedResultsRenderer: Codable {
	let tabs: [SearchTab]?
}

struct SearchTab: Codable {
	let tabRenderer: SearchTabRenderer?
}

struct SearchTabRenderer: Codable {
	let content: SearchTabRendererContent?
}

struct SearchTabRendererContent: Codable {
	let sectionListRenderer: SearchSectionListRenderer?
}

struct SearchSectionListRenderer: Codable {
	let contents: [SearchSectionListRendererContent]?
}

struct SearchSectionListRendererContent: Codable {
	let musicShelfRenderer: SearchMusicShelfRenderer?
}


// MARK: - MusicShelfRenderer
struct SearchMusicShelfRenderer: Codable {
	let contents: [SearchMusicShelfRendererContent]?
	let continuations: [Continuation]?
}

// MARK: - MusicShelfRendererContent
struct SearchMusicShelfRendererContent: Codable {
	let musicTwoColumnItemRenderer: SearchMusicTwoColumnItemRenderer?
}

// MARK: - MusicTwoColumnItemRenderer
struct SearchMusicTwoColumnItemRenderer: Codable {
	let thumbnail: MusicMenuTitleRendererThumbnail?
	let title: Title?
	let subtitle: Title?
	let navigationEndpoint: NavigationEndpoint?
}

// MARK: - Thumbnails
struct MusicMenuTitleRendererThumbnail: Codable {
	let musicThumbnailRenderer: MusicThumbnailRenderer?
}
