//
//  Snipit.swift
//  VideoLauncher
//
//  Created by thomas minshull on 2018-06-27.
//  Copyright © 2018 thomas minshull. All rights reserved.
//

import UIKit
import RealmSwift

class Snipit: Object {
    @objc dynamic var imagePath: String?
    @objc dynamic var videoPath: String?
    @objc dynamic var name: String?
    @objc dynamic var width: Double = -1
}
