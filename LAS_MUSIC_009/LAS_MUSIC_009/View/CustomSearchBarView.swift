//
//  CustomSearchBarView.swift
//  Las_File_Offline_001
//
//  Created by Tiến Việt Trịnh on 02/08/2023.
//

import UIKit

protocol CustomSearchBarDelegate: AnyObject {
    func didSelectCancelButton()
    func didChangedSearchTextFiled(textField: UITextField)
    func didBeginEdittingSearchField(textField: UITextField)
    func didEndSearching(textField: UITextField)
}

extension CustomSearchBarDelegate {
    func didSelectCancelButton() {}
    func didBeginEdittingSearchField(textField: UITextField) {}
    func didEndSearching() {}
    func didChangedSearchTextFiled(textField: UITextField) {}
}

class CustomSearchBarView: UIView {
    //MARK: - Properties
    var isSearching: Bool = false
    weak var delegate: CustomSearchBarDelegate?
    
    var rightContainerViewConstraint: NSLayoutConstraint!
    var widthCancelButtonConstraint: NSLayoutConstraint!
    let isHiddenCancelButton: Bool
    
    private lazy var searchLogoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: AssetConstant.ic_search))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.12)
        iv.contentMode = .center
        return iv
    }()

    lazy var searchTextFiled: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Search"
        tf.delegate = self
        tf.font = .fontRailwayRegular(16)
        tf.textColor = UIColor(rgb: 0xEEEEEE)
        tf.addTarget(self, action: #selector(didSearchButton), for: .editingDidEndOnExit)
//        tf.clearButtonMode = .whileEditing
        tf.text = "Black pink"
        tf.font = .fontRailwayRegular(16)
        tf.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [.font: UIFont.fontRailwayRegular(16), .foregroundColor: UIColor.white])
        return tf
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchLogoImageView)
        view.addSubview(searchTextFiled)
        view.backgroundColor = UIColor(red: 0.463, green: 0.463, blue: 0.502, alpha: 0.12)
        view.layer.cornerRadius = 11
        searchLogoImageView.tintColor = .black
        
        NSLayoutConstraint.activate([
            searchLogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            searchLogoImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 11),
            
            searchTextFiled.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            searchTextFiled.leftAnchor.constraint(equalTo: searchLogoImageView.rightAnchor, constant: 9),
            searchTextFiled.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -13),
            
        ])
        searchLogoImageView.setDimensions(width: 30, height: 30)
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(rgb: 0x33313F)
        
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .fontRailwayBold(14)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(hanldeCancelButtonTapped), for: .touchUpInside)
        button.setTitleColor(UIColor(rgb: 0xEEEEEE), for: .normal)
        button.alpha = 0
        return button
    }()
    

    
    //MARK: - View Lifecycle
    init(ishiddenCancelButton: Bool = false) {
        self.isHiddenCancelButton = ishiddenCancelButton
        super.init(frame: .infinite)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    private func configureUI() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        addSubview(cancelButton)
        
        self.rightContainerViewConstraint = containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        self.widthCancelButtonConstraint = cancelButton.leftAnchor.constraint(equalTo: rightAnchor, constant: 10)
        NSLayoutConstraint.activate([
            containerView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            rightContainerViewConstraint,
            
            cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            widthCancelButtonConstraint,
        ])
    }
    
    func textForSearchView(text: String?) {
        self.searchTextFiled.text = text
    }
    
    func forceEndSearching() {
        self.searchTextFiled.endEditing(true)
    }
    
    
    //MARK: - Selectors
    @objc func hanldeCancelButtonTapped() {
        self.widthCancelButtonConstraint.constant = 10
        NSLayoutConstraint.deactivate([self.rightContainerViewConstraint])
        self.rightContainerViewConstraint = containerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        NSLayoutConstraint.activate([
            rightContainerViewConstraint,
        ])
        
        UIView.animate(withDuration: 0.32) {
            self.cancelButton.alpha = 0
            self.layoutIfNeeded()
        }
        self.searchTextFiled.endEditing(true)
//        self.searchTextFiled.text = ""
        self.delegate?.didSelectCancelButton()
    }
    
    @objc func didSearchButton(textField: UITextField) {
        self.delegate?.didEndSearching(textField: textField)
    }
    
}
//MARK: - delegate
extension CustomSearchBarView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !self.isHiddenCancelButton {
            self.widthCancelButtonConstraint.constant = -60
            NSLayoutConstraint.deactivate([self.rightContainerViewConstraint])
            self.rightContainerViewConstraint = containerView.rightAnchor.constraint(equalTo: cancelButton.leftAnchor, constant: -10)
            NSLayoutConstraint.activate([
                rightContainerViewConstraint,
            ])
            
            UIView.animate(withDuration: 0.32) {
                self.cancelButton.alpha = 1
                self.layoutIfNeeded()
            }
        }
        self.delegate?.didBeginEdittingSearchField(textField: textField)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.delegate?.didChangedSearchTextFiled(textField: textField)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

        
    }
}

