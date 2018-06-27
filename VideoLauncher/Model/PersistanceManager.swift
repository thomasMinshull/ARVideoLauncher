//
//  PersistanceManager.swift
//  VideoLauncher
//
//  Created by thomas minshull on 2018-06-27.
//  Copyright © 2018 thomas minshull. All rights reserved.
//

import UIKit

class PersistanceManager: NSObject {

    func saveNewSnipitWith(image: UIImage, video: URL, with completionBlock: (Bool) -> ()) {
        // save results
        // - save Image to file, return URL
        // - save Video to file, return URL
        // - Get name for snipit (UUID for now)
        // - Create Realm snipit object and save that
        completionBlock(false)
    }
    
}
