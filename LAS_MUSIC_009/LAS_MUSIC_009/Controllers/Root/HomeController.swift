//
//  HomeController.swift
//  LAS_MUSIC_009
//
//  Created by Tiến Việt Trịnh on 13/08/2023.
//


import UIKit

class HomeController: BaseController {
    
    //MARK: - Properties
    
    
    //MARK: - UIComponent
    var cellIndentifiers: [String] = [HomeAlbumsTBCell.cellId]
    let searchView = CustomSearchBarView(ishiddenCancelButton: true)
    
    private lazy var homeTB: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeAlbumsTBCell.self, forCellReuseIdentifier: HomeAlbumsTBCell.cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(rgb: 0x1C1B1F)
        return tableView
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureProperties()
    }
    
    func configureUI() {
        view.addSubview(searchView)
        view.addSubview(homeTB)
        
        searchView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUserSearchTapped)))
        searchView.isUserInteractionEnabled = true
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.searchTextFiled.isUserInteractionEnabled = false
        
        NSLayoutConstraint.activate([
            searchView.heightAnchor.constraint(equalToConstant: 46),
            searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            searchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24),
            searchView.topAnchor.constraint(equalTo: view.topAnchor, constant: 52),
            
            homeTB.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: 35),
            homeTB.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            homeTB.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -0),
            homeTB.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        view.layoutIfNeeded()
    }

}

//MARK: - Method
extension HomeController {
    
    //MARK: - Helpers
    func configureProperties() {
        
    }
    
    //MARK: - Selectors
    @objc func handleUserSearchTapped() {
        let searchVC = SearchController()
        self.tabBarController?.navigationController?.pushViewController(searchVC, animated: true)
    }
    
}

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeAlbumsTBCell.cellId,
                                                 for: indexPath) as! HomeAlbumsTBCell

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HomeAlbumsTBCell.heighCell
    }
    
}


