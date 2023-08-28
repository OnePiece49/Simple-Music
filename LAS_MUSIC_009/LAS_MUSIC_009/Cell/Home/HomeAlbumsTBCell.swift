//
//  HomeAlbumsCLCell.swift
//  LAS_MUSIC_009
//
//  Created by Tiến Việt Trịnh on 25/08/2023.
//

import UIKit

protocol HomeAlbumsCellDelegate: AnyObject {
    
}

class HomeAlbumsTBCell: UITableViewCell {
    
    //MARK: - Properties
    static let heighCell: CGFloat = 265
    var navBar: NavigationCustomView!
    weak var delegate: HomeAlbumsCellDelegate? {
        didSet {
            loadData()
        }
    }
    let viewModel = HomeAlbumsViewModel()
    
    private lazy var pagerView: FSPagerView = {
        let view = FSPagerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.itemSize = CGSize(width: 200, height: 200)
        view.automaticSlidingInterval = 3
        view.isInfinite = false
        view.decelerationDistance = 2
//        view.collectionView.contentInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        view.transformer = FSPagerViewTransformer(type: .linear)
        view.backgroundColor = UIColor(rgb: 0x1C1B1F)
        return view
    }()
    
    //MARK: - View Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func loadData() {
        viewModel.bindingViewModel = { [weak self] in
            self?.pagerView.reloadData()
        }
    }
    
    func configureUI() {
        backgroundColor = UIColor(rgb: 0x1C1B1F)
        configureNavBar()
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: FSPagerViewCell.cellId)
        setupConstraints()
    }
    
    private func setupConstraints() {
        contentView.addSubview(navBar)
        contentView.addSubview(pagerView)
        
        NSLayoutConstraint.activate([
            navBar.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            navBar.topAnchor.constraint(equalTo: contentView.topAnchor),
            navBar.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 44),
            
            pagerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            pagerView.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: 21),
            pagerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            pagerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    private func configureNavBar() {
        let firstAttributeLeft = AttibutesButton(tilte: "New Albums",
                                                  font: UIFont.fontRailwayBold(24),
                                                  titleColor: UIColor(rgb: 0xEEEEEE))
        
        let attributeRight = AttibutesButton(tilte: "View all",
                                             font: UIFont.fontRailwayBold(12),
                                             titleColor: UIColor(rgb: 0xEEEEEE)) { [weak self] in
//            self?.animationDismiss()
        }
        
        self.navBar = NavigationCustomView(centerTitle: "",
                                                  attributeLeftButtons: [firstAttributeLeft],
                                                  attributeRightBarButtons: [attributeRight],
                                                  isHiddenDivider: true,
                                                  beginSpaceLeftButton: 24,
                                                  beginSpaceRightButton: 22)
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.backgroundColor = .clear
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
extension HomeAlbumsTBCell: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return viewModel.numbersCell
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: FSPagerViewCell.cellId, at: index)
        return cell
    }
}

// MARK: - FSPagerViewDelegate

extension HomeAlbumsTBCell: FSPagerViewDelegate {
    func pagerViewWillEndDragging(_ pagerView: FSPagerView, targetIndex: Int) {
    }

    func pagerViewDidEndScrollAnimation(_ pagerView: FSPagerView) {
    }

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
   
    }
    
    
}





