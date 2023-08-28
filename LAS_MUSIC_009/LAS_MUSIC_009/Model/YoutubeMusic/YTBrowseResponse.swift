//
//  YTBrowseResponse.swift
//  LAS_MUSIC_009
//
//  Created by Đức Anh Trần on 25/08/2023.
//

import Foundation

// MARK: - YTBrowseResponse
struct YTBrowseResponse: Codable {
	let contents: BrowseContents?
	let header: BrowseHeader?
}

// MARK: - Header
struct BrowseHeader: Codable {
	let musicDetailHeaderRenderer: BrowseMusicDetailHeaderRenderer?
	let musicHeaderRenderer: BrowseMusicHeaderRenderer?
}

struct BrowseMusicDetailHeaderRenderer: Codable {
	let title: Title?
	let subtitle: Title?
	let thumbnail: MusicDetailHeaderThumbnail?
}

struct MusicDetailHeaderThumbnail: Codable {
	let croppedSquareThumbnailRenderer: MusicThumbnailRenderer?
}

struct BrowseMusicHeaderRenderer: Codable {
	let title: Title?
}

// MARK: - Contents
struct BrowseContents: Codable {
	let singleColumnBrowseResultsRenderer: BrowseSingleColumnResultsRenderer?
}

// MARK: - SingleColumnBrowseResultsRenderer
struct BrowseSingleColumnResultsRenderer: Codable {
	let tabs: [BrowseTab]?
}

// MARK: - Tab
struct BrowseTab: Codable {
	let tabRenderer: BrowseTabRenderer?
}

// MARK: - TabRenderer
struct BrowseTabRenderer: Codable {
	let content: BrowseTabRendererContent?
}

// MARK: - TabRendererContent
struct BrowseTabRendererContent: Codable {
	let sectionListRenderer: BrowseSectionListRenderer?
}

// MARK: - SectionListRenderer
struct BrowseSectionListRenderer: Codable {
	let contents: [BrowseContent]?
	let continuations: Continuation?
}

// MARK: - ContentElement
struct BrowseContent: Codable {
	let gridRenderer: BrowseGridRenderer?
	let musicShelfRenderer: SearchMusicShelfRenderer?
	let musicCarouselShelfRenderer: BrowseMusicCarouselShelfRenderer?
	let musicPlaylistShelfRenderer: BrowseMusicPlaylistShelfRenderer?
}

// MARK: - BrowseGridRenderer
struct BrowseGridRenderer: Codable {
	let items: [BrowseItem]?
}

// MARK: - Item
struct BrowseItem: Codable {
	let musicNavigationButtonRenderer: BrowseMusicNavigationButtonRenderer?
}

// MARK: - MusicNavigationButtonRenderer
struct BrowseMusicNavigationButtonRenderer: Codable {
	let buttonText: Title?
	let clickCommand: ClickCommand?
}

// MARK: - ClickCommand
struct ClickCommand: Codable {
	let clickTrackingParams: String?
	let browseEndpoint: BrowseEndpoint?
}

// MARK: - BrowseMusicCarouselShelfRenderer
struct BrowseMusicCarouselShelfRenderer: Codable {
	let contents: [BrowseMusicTwoRowItemRenderer]
}

struct BrowseMusicTwoRowItemRenderer: Codable {
	let navigationEndpoint: NavigationEndpoint?
}

// MARK: - MusicPlaylistShelfRenderer
struct BrowseMusicPlaylistShelfRenderer: Codable {
	let playlistID: String?
	let contents: [MusicPlaylistShelfRendererContent]?
}

// MARK: - MusicPlaylistShelfRendererContent
struct MusicPlaylistShelfRendererContent: Codable {
	let musicTwoColumnItemRenderer: SearchMusicTwoColumnItemRenderer?
}
