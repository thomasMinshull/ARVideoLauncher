//
//  Snipit.swift
//  VideoLauncher
//
//  Created by thomas minshull on 2018-06-27.
//  Copyright © 2018 thomas minshull. All rights reserved.
//

import UIKit
import RealmSwift

struct Snipit {
    let imagePath: String
    let videoPath: String
    let name: String
    let width: Double
    
    init(realmSnipit: RealmSnipit) {
        imagePath = realmSnipit.imagePath!
        videoPath = realmSnipit.videoPath!
        name = realmSnipit.name!
        width = realmSnipit.width
    }
}

class RealmSnipit: Object {
    @objc dynamic var imagePath: String?
    @objc dynamic var videoPath: String?
    @objc dynamic var name: String?
    @objc dynamic var width: Double = -1
}
