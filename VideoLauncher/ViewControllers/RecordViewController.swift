//
//  RecordViewController.swift
//  VideoLauncher
//
//  Created by thomas minshull on 2018-06-26.
//  Copyright © 2018 thomas minshull. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    let imagePickerController = UIImagePickerController()
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        imagePickerController.delegate = self
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    @IBAction func RecordButtonTapped(_ sender: UIButton) {
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
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension RecordViewController: ImageTesterDelegate {
    func ARImageTesterViewController(_ imageTesterViewController: ARImageTesterViewController, didVerify image: UIImage) {
        imageTesterViewController.dismiss(animated: true, completion: nil)
        
        // We have an image 
        
    }
    
    
}

extension RecordViewController: UINavigationControllerDelegate {
//    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
//
//    }
//
//    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
//
//    }
//
//
//    public func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
//
//    }
//
//    public func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
//
//    }
//
//    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//
//    }
//
//    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//    }

}
