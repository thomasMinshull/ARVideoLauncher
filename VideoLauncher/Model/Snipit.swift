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
    @objc dynamic var imageUrlString = ""
    @objc dynamic var videoUrlString = ""
    @objc dynamic var name = ""
    @objc dynamic var width = 0
    @objc dynamic var height = 0

}
