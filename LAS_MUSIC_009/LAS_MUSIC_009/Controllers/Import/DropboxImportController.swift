//
//  DropboxImportController.swift
//  LAS_MUSIC_009
//
//  Created by Đức Anh Trần on 14/08/2023.
//

import UIKit
import SwiftyDropbox
import AVFoundation
import RealmSwift

class DropboxImportController: ImportBaseController {

	// MARK: - Properties
	private let kScopes: [String] = [
		"account_info.read",
		"files.metadata.read",
		"files.content.read"
	]

	private let realm = RealmService.shared.realmObj()
	private let importPlaylist = RealmService.shared.importPlaylist()
	private var files: [Files.FileMetadata] = []
	private var isLoadingMore: Bool = false
	private var cursor: String?

	// MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		setupTBView()
		signinButton.addTarget(self, action: #selector(singinBtnTapped), for: .touchUpInside)
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		checkSignInUser()
	}

	private func setupTBView() {
		downloadTB.rowHeight = DropboxItemTBCell.heightCell
		downloadTB.delegate = self
		downloadTB.dataSource = self
		downloadTB.register(DropboxItemTBCell.self, forCellReuseIdentifier: DropboxItemTBCell.cellId)
	}
}

// MARK: - Method
extension DropboxImportController {
	private func checkSignInUser() {
		let signedIn = DropboxManager.shared.checkSignInUser()

		if signedIn {
			self.loadingIndicator.startAnimating()
			self.getUserEmail()
			self.getAllFiles()
			self.signinButton.setTitle("SIGN OUT", for: .normal)
		}
	}

	private func getUserEmail() {
		DropboxManager.shared.getUserEmail { [weak self] email in
			if let email = email {
				self?.updateCenterNav(with: email)
			}
		}
	}

	private func getAllFiles() {
		DropboxManager.shared.getAllFiles { [weak self] filesMetadata, cursor in
			self?.loadingIndicator.stopAnimating()
			self?.files = filesMetadata
			self?.downloadTB.reloadData()
		}
	}

	private func loadMoreFiles(cursor: String) {
		DropboxManager.shared.getMoreFiles(cursor: cursor) { [weak self] filesMetadata, cursor in
			self?.loadingIndicator.stopAnimating()
			self?.files.append(contentsOf: filesMetadata)
			self?.cursor = cursor
			self?.isLoadingMore = false
			self?.downloadTB.reloadData()
		}
	}

	@objc private func singinBtnTapped() {
		let signedIn = DropboxManager.shared.checkSignInUser()

		if !signedIn {
			let scopeRequest = ScopeRequest(scopeType: .user,
											scopes: kScopes,
											includeGrantedScopes: false)

			DropboxClientsManager.authorizeFromControllerV2(
				UIApplication.shared,
				controller: self,
				loadingStatusDelegate: nil,
				openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
				scopeRequest: scopeRequest
			)

		} else {
			signOutUser()
		}
	}

	private func signOutUser() {
		DropboxManager.shared.unlinkUser()
		self.signinButton.setTitle("SIGN IN", for: .normal)
		self.updateCenterNav(with: "")
		self.files.removeAll()
		self.downloadTB.reloadData()
	}

	private func downloadFile(_ file: Files.FileMetadata) {
		guard let url = URL.importFolder()?.appendingPathComponent(file.name) else { return }

		if FileManager.default.fileExists(atPath: url.path) {
			view.displayToast("Failed to import: File already existed")
			return
		}

		let loadingView = LoadingView(message: "Importing...")
		loadingView.show()

		DropboxManager.shared.downloadFile(fileMetadata: file, outputURL: url) { [weak self] outputURL, mediaInfo in
			guard let outputURL = outputURL else {
				self?.view.displayToast("Failed to import file")
				return
			}
			self?.saveMusicToRealm(file: file, url: outputURL)
			loadingView.dismiss()
		}
	}

	private func saveMusicToRealm(file: Files.FileMetadata, url: URL) {
		guard let realm = realm, let importPlaylist = importPlaylist else {
			view.displayToast("Failed to import file")
			return
		}

		let musicModel = MusicModel()
		musicModel.name = file.name
		musicModel.creationDate = Date().timeIntervalSince1970
		musicModel.sourceType = .offline
		musicModel.relativePath = url.path.replacingOccurrences(of: "\(URL.document().path)/", with: "")

		let asset = AVURLAsset(url: url)
		musicModel.durationDouble = CMTimeGetSeconds(asset.duration)

		switch url.pathExtension {
			case "mp3": musicModel.type = .audio
			case "mp4": musicModel.type = .video
			default: break
		}

		self.getThumbnail(file: file) { thumbnailURL in
			try? realm.write { musicModel.thumbnailURL = thumbnailURL?.absoluteString }
		}

		do {
			try realm.write {
				realm.add(musicModel)
				importPlaylist.musics.append(musicModel)
			}
			view.displayToast("Import file successful")

		} catch {
			try? FileManager.default.removeItem(at: url)
			view.displayToast("Failed to import file")
		}
	}

	private func getThumbnail(file: Files.FileMetadata,
							  completion: @escaping (_ thumbnailURL: URL?) -> Void) {
		let path = file.name.pathWithoutExtension
		guard let thumnailURL = URL.thumbnailFolder()?.appendingPathComponent("\(path).jpeg") else { completion(nil) ; return }

		if FileManager.default.fileExists(atPath: thumnailURL.path) { completion(nil) ; return }

		DropboxManager.shared.getFileThumbnail(fileMetadata: file, outputURL: thumnailURL, completion: completion)
	}

}

// MARK: - UITableViewDataSource
extension DropboxImportController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return files.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: DropboxItemTBCell.cellId,
												 for: indexPath) as! DropboxItemTBCell
		cell.file = files[indexPath.row]
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		let file = files[indexPath.row]
		downloadFile(file)
	}

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let currentOffset = scrollView.contentOffset.y
		let maximumOffset = scrollView.contentSize.height - view.frame.height

		if maximumOffset - currentOffset < 10 {
			if !isLoadingMore, let cursor = cursor {
				isLoadingMore = true
				loadMoreFiles(cursor: cursor)
			}
		}
	}
}
