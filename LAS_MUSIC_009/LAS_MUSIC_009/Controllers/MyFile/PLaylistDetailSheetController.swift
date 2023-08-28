//
//  PLaylistDetailSheetController.swift
//  LAS_MUSIC_009
//
//  Created by Đức Anh Trần on 17/08/2023.
//

import UIKit

protocol PLaylistDetailSheetDelegate: AnyObject {
	func didTapRename(_ controller: PLaylistDetailSheetController, music: MusicModel)
	func didTapShare(_ controller: PLaylistDetailSheetController, music: MusicModel)
	func didTapDelete(_ controller: PLaylistDetailSheetController, music: MusicModel)
}

class PLaylistDetailSheetController: TransparentBottomSheetController {

	private enum Option: Int, CaseIterable {
		case rename, share, delete

		var title: String {
			switch self {
				case .rename: return "Rename"
				case .share: return "Share"
				case .delete: return "Delete"
			}
		}
	}

	private let music: MusicModel
	weak var delegate: PLaylistDetailSheetDelegate?

	// MARK: - UI components
	override var rootView: UIView {
		return containerView
	}

	override var sheetHeight: BottomSheetHeight {
		return .aspect(256/813)
	}

	private let containerView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .clear
		return view
	}()

	private let titleLbl: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 2
		label.font = .fontRailwayBold(18)
		label.textColor = UIColor(rgb: 0xEEEEEE)
		label.textAlignment = .center
		return label
	}()

	private let tableView: UITableView = {
		let tbv = UITableView(frame: .zero, style: .plain)
		tbv.translatesAutoresizingMaskIntoConstraints = false
		tbv.backgroundColor = .clear
		tbv.isScrollEnabled = false
		return tbv
	}()

	// MARK: - Life cycle
	init(music: MusicModel) {
		self.music = music
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupTBView()
		titleLbl.text = music.name
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		self.containerView.applyGradient(colours: [UIColor(rgb: 0x717171).withAlphaComponent(0.6),
												   UIColor(rgb: 0x545454).withAlphaComponent(0.6)])
	}

	private func setupTBView() {
		tableView.rowHeight = ImportedSheetTBCell.cellHeight
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(ImportedSheetTBCell.self, forCellReuseIdentifier: ImportedSheetTBCell.cellId)
	}

	override func setupConstraints() {
		super.setupConstraints()
		containerView.addSubview(titleLbl)
		containerView.addSubview(tableView)

		titleLbl.anchor(leading: containerView.leadingAnchor, paddingLeading: 20,
						top: containerView.topAnchor, paddingTop: 20,
						trailing: containerView.trailingAnchor, paddingTrailing: -20)

		tableView.anchor(leading: titleLbl.leadingAnchor,
						 top: titleLbl.bottomAnchor, paddingTop: 12,
						 trailing: titleLbl.trailingAnchor,
						 bottom: containerView.bottomAnchor)
	}
}

// MARK: - UITableViewDelegate
extension PLaylistDetailSheetController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Option.allCases.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: ImportedSheetTBCell.cellId,
												 for: indexPath) as! ImportedSheetTBCell
		let option = Option(rawValue: indexPath.row)
		cell.setTitle(option?.title)
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		guard let option = Option(rawValue: indexPath.row) else { return }

		switch option {
			case .rename:
				delegate?.didTapRename(self, music: music)
			case .share:
				delegate?.didTapShare(self, music: music)
			case .delete:
				delegate?.didTapDelete(self, music: music)
		}
	}
}
