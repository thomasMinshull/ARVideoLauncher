//
//  RecordViewController.swift
//  VideoLauncher
//
//  Created by thomas minshull on 2018-06-26.
//  Copyright © 2018 thomas minshull. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    
    let imagePickerController = UIImagePickerController()
    var image: UIImage?
    
    private enum RecordState {
        case recordPhoto
        case recordVideo
        case saveResults
        case savingResults
        case saved
    }
    
    private var state: RecordState! {
        didSet {
            switch (oldValue, state) {
            // setting intial value should be allowed
            case (nil, .recordPhoto?):
                setViewsForRecordPhtoto()
                
            // normal state transition
            case (.recordPhoto?, .recordVideo?):
                setViewsForRecordVideo()
            case (.recordVideo?, .saveResults?):
                setViewsForSave()
            case (.saveResults?, .savingResults?):
                setViewsForSaving()
            case (.savingResults?, .saved?):
                setViewsForSaved()
            case (.saved?, .recordPhoto?):
                setViewsForRecordPhtoto()
                
            // canceled state transition
            case (_, .recordPhoto?):
                setViewsForRecordPhtoto()
                
            // invalid state transitions
            case (_, nil):
                fallthrough
            case (.recordPhoto?, .savingResults?):
                fallthrough
            case (.recordPhoto?, .saved?):
                fallthrough
            default:
                print("Invalid state transfer in RecordViewController attemted, resetting state to previous value")
                state = oldValue
            }
        }
    }
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .recordPhoto // set initial state
        navigationController?.setNavigationBarHidden(true, animated: false)
        imagePickerController.delegate = self
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    // MARK: - State Transitions
    
    private func cancel() {
        guard state != .saved else {
            print("Cannot Cancel from Saved State")
            return
        }
        state = .recordPhoto
    }
    
    // Normal State Transitions
    private func transitionToNextState() {
        switch state {
        case nil:
            state = .recordPhoto
        case .recordPhoto?:
            state = .recordVideo
        case .recordVideo?:
            state = .saveResults
        case .saveResults?:
            state = .savingResults
        case .savingResults?:
            state = .saved
        case .saved?:
            state = .recordPhoto
        }
    }
    
    // MARK: - set Views for state
    
    private func setViewsForRecordPhtoto() {
        DispatchQueue.main.async {
            self.resetButton.isHidden = true
            
            self.recordButton.isEnabled = true
            self.recordButton.tintColor = UIColor.red
            self.recordButton.setTitle("Record Picture", for: .normal)
        }
    }
    
    private func setViewsForRecordVideo() {
        DispatchQueue.main.async {
            self.resetButton.isHidden = false
            self.resetButton.isEnabled = true
            
            self.recordButton.isEnabled = true
            self.recordButton.tintColor = UIColor.red
            self.recordButton.setTitle("Record Video", for: .normal)
        }
    }

    private func setViewsForSave() {
        DispatchQueue.main.async {
            self.resetButton.isHidden = false
            self.resetButton.isEnabled = true
            
            self.recordButton.isEnabled = true
            self.recordButton.tintColor = UIColor.blue
            self.recordButton.setTitle("Save", for: .normal)
        }
    }
    
    private func setViewsForSaving() {
        DispatchQueue.main.async {
            self.resetButton.isHidden = false
            self.resetButton.isEnabled = false
            
            self.recordButton.isEnabled = false
            self.recordButton.tintColor = UIColor.blue
            self.recordButton.setTitle("Saving", for: .normal)
        }
    }
    
    private func setViewsForSaved() {
        DispatchQueue.main.async {
            self.resetButton.isHidden = false
            self.resetButton.isEnabled = false
            
            self.recordButton.isEnabled = false
            self.recordButton.tintColor = UIColor.blue
            self.recordButton.setTitle("Saved", for: .normal)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func RecordButtonTapped(_ sender: UIButton) {
        // change buttons behavour based on state // refactore each behavour into different functions
        switch state {
        case .recordPhoto?:
            presentCamerForPhoto()
        default:
            return
        }
        
    }
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        cancel()
    }
    
    // MARK: - Helper Functions
    
    func presentCamerForPhoto() {
        let imageKey = "public.image"
        
        guard (UIImagePickerController.availableMediaTypes(for: .camera)?.contains(imageKey))! else {
            return
        }
        
        imagePickerController.mediaTypes = [imageKey]
        imagePickerController.sourceType = UIImagePickerController.SourceType.camera
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
}

extension RecordViewController: UIImagePickerControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // ToDo possibly update state here based on previous state
        
        switch state {
        case .recordPhoto?:
            handleDidFetchPhotoFrom(picker: picker, With: info)
           
        case .recordVideo?:
        // ToDo: handleFetchingVideo
            break
        default:
            return
        }
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        cancel()
        dismiss(animated: true, completion: nil)
    }
    
    private func handleDidFetchPhotoFrom(picker: UIImagePickerController, With info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.editedImage] as? UIImage {
            image = editedImage
        } else {
            image = info[.originalImage] as? UIImage
        }
        
        let imageTesterVC = storyboard?.instantiateViewController(withIdentifier: "ARImageTesterViewController") as! ARImageTesterViewController
        imageTesterVC.image = image
        imageTesterVC.delegate = self
        
        picker.dismiss(animated: false)
        present(imageTesterVC, animated: true, completion: nil)
    }
    
    private func handleDidFetchVideoFrom(picker: UIImagePickerController, With info: [UIImagePickerController.InfoKey : Any]) {
//        // ToDo Change implementation based on state
//        if let editedImage = info[.editedImage] as? UIImage {
//            image = editedImage
//        } else {
//            image = info[.originalImage] as? UIImage
//        }
//
//        let imageTesterVC = storyboard?.instantiateViewController(withIdentifier: "ARImageTesterViewController") as! ARImageTesterViewController
//        imageTesterVC.image = image
//        imageTesterVC.delegate = self
//
//        picker.dismiss(animated: false)
//        present(imageTesterVC, animated: true, completion: nil)
    }
}

extension RecordViewController: ImageTesterDelegate {
    func ARImageTesterViewController(_ imageTesterViewController: ARImageTesterViewController, didVerify image: UIImage) {
        imageTesterViewController.dismiss(animated: true, completion: nil)
      
        transitionToNextState()
        
        // ToDO update state
        
        // We have an image
        // ToDo:
        /*
         - get video
         - create dataStructure to store Image / video's
         - persist Image/Video
         - load Image/Video
         - Refactor, clean up code
         - Implement Anchoring on longpress from other branch
         */
    }
}

extension RecordViewController: UINavigationControllerDelegate {
}
