//
//  BaseController.swift
//  LAS_MUSIC_009
//
//  Created by Tiến Việt Trịnh on 13/08/2023.
//

import UIKit
import RealmSwift

class BaseController: UIViewController {
    
    //MARK: - Properties
    var isIphone: Bool {
        return UIDevice.current.is_iPhone
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    var heightDevice: CGFloat {
        return view.frame.height
    }
    
    //MARK: - UIComponent
    
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .primaryBackgroundColor
        self.navigationController?.navigationBar.isHidden = true
    }
    
}

// MARK: - Method
extension BaseController {
//    func saveFileToDB(at url: URL, fileName: String? = nil) -> Bool {\
//
//        guard let realm = RealmService.shared.realmObj(),
//              let fileModel = RealmService.shared.convertToFileModel(with: url, fileName: fileName)
//        else { return false }
//
//        let success = RealmService.shared.saveObject(fileModel)
//        if success {
//            let importFolder = RealmService.shared.importFolder()
//            try? realm.write {
//                importFolder?.files.append(fileModel)
//            }
//        }
//        return success
//    }
    
    func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
    
    func playMusic(playlist: PlaylistModel, currentMusic: MusicModel) {
        guard let tabBarVC = self.tabBarController as? TabBarController else {
            guard let tabBarVC = self.navigationController?.viewControllers.first as? TabBarController else {return}
            tabBarVC.playerVC.viewModel.newPlaylist(playlist: playlist, currentMusic: currentMusic)
            tabBarVC.presentPlayerVCFullScreen()
            return
        }
        
        tabBarVC.playerVC.viewModel.newPlaylist(playlist: playlist, currentMusic: currentMusic)
        tabBarVC.presentPlayerVCFullScreen()
    }

}
