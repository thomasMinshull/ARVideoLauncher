//
//  PersistanceManager.swift
//  VideoLauncher
//
//  Created by thomas minshull on 2018-06-27.
//  Copyright © 2018 thomas minshull. All rights reserved.
//

import UIKit
import RealmSwift

class PersistanceManager: NSObject {
    private let videoDirectoryName = "videos"
    private let imageDirectoryName = "images"
    
    func fetchSnipits() -> [Snipit] {
        // ToDo Should only be able to save a max of 25 snipits
        do {
            let realm = try Realm()
            
            let realmSnipits = realm.objects(RealmSnipit.self) // ToDo Take the last 25
            let snipits = realmSnipits.map({ Snipit(realmSnipit: $0) })
            return Array(snipits)
            
        } catch let error {
            print("Unable to fetch snipits. Error: \(error)")
            return [Snipit]()
        }
    }
    
    func saveNewSnipitWith(image: UIImage, video: URL, _ fileManager: FileManager = FileManager.default, with completionBlock: @escaping (Bool) -> ()) {
        DispatchQueue.global().async {
            let uuid = UUID()
            
            guard let savedImageURL = self.writeImageToFile(name: uuid.uuidString, image: image, fileManager) else {
                completionBlock(false)
                return
            }
            
            guard let savedVideoURL = self.writeVideoToFile(name: uuid.uuidString, videoURL: video, fileManager) else {
                do {
                    try fileManager.removeItem(at: savedImageURL)
                } catch let error {
                    print("Error Occured while deleting savedImage after Video failed to save. Error: \(error)")
                }
                
                completionBlock(false)
                return
            }
            
            guard self.createAndSaveSnipitWith(uuid: uuid, imageURL: savedImageURL, videoURL: savedVideoURL) else {
                do {
                    try fileManager.removeItem(at: savedImageURL)
                    try fileManager.removeItem(at: savedVideoURL)
                } catch let error {
                    print("Error Occured while deleting savedImage and SavedVideo after Snipit failed to save. Error: \(error)")
                }
                
                completionBlock(false)
                return
            }
            
            completionBlock(true)
        }
    }
    
    private func writeImageToFile(name: String, image: UIImage, _ fileManager: FileManager = FileManager.default) -> URL? {
        guard let documentDirectory = try? fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else{
            return nil
        }
        
        let imageDirectoryURL = documentDirectory.appendingPathComponent(imageDirectoryName)
        if !fileManager.fileExists(atPath: imageDirectoryURL.path) {
            try? fileManager.createDirectory(at: imageDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
    
        let completeImageURL = imageDirectoryURL.appendingPathComponent("\(name).png")
        guard let imageData = image.pngData() else { return nil }
        
        if fileManager.createFile(atPath: completeImageURL.path, contents: imageData, attributes: nil) {
            return completeImageURL
        } else {
            return nil
        }
    }
    
    private func writeVideoToFile(name: String, videoURL: URL, _ fileManager: FileManager = FileManager.default) -> URL? {
        guard let documentDirectory = try? fileManager.url(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else{
            return nil
        }
        
        var newVideoURL = documentDirectory.appendingPathComponent(videoDirectoryName)
        if !fileManager.fileExists(atPath: newVideoURL.path) {
            try? fileManager.createDirectory(at: newVideoURL, withIntermediateDirectories: true, attributes: nil)
        }
        
        newVideoURL = newVideoURL.appendingPathComponent(name)
        newVideoURL = newVideoURL.appendingPathExtension(videoURL.pathExtension)
        
        do {
            try fileManager.moveItem(at: videoURL, to: newVideoURL)
            return newVideoURL
        } catch let error {
            print("Unable to move video from url: \(videoURL) to url: \(newVideoURL). Error: \(error)")
            return nil
        }
    }
    
    private func createAndSaveSnipitWith(uuid: UUID, imageURL: URL, videoURL: URL) -> Bool {
        do {
            let realm = try Realm()
            
            try realm.write {
                let snipit = RealmSnipit()
                snipit.imagePath = imageURL.path
                snipit.videoPath = videoURL.path
                snipit.name = uuid.uuidString
                snipit.width = 2
                
                realm.add(snipit)
            }

        } catch let error {
            print("Unable to save Snipit. Error: \(error)")
            return false
        }
        
        return true
    }
}
