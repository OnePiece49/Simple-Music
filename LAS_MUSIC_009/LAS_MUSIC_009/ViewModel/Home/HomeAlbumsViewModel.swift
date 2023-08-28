//
//  HomeAlbumsViewModel.swift
//  LAS_MUSIC_009
//
//  Created by Tiến Việt Trịnh on 25/08/2023.
//

import UIKit

class HomeAlbumsViewModel {
    
    var playlist: [PlaylistModel] = []
    
    var bindingViewModel: (() -> Void)?
    
    var numbersCell: Int {
        return 10
    }
    
}
