//
//  ViewController.swift
//  ImageFilterApp
//
//  Created by Karlo Pagtakhan on 01/19/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var originalImage = UIImage()
    var filteredImage = UIImage()
    
    @IBOutlet var originalImageView: UIImageView!

    @IBOutlet var filteredImageView: UIImageView!
    @IBOutlet var originalLabel: UILabel!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var compareButton: UIButton!
    
    @IBOutlet var bottomMenu: UIStackView!
    @IBOutlet var filterMenu: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        compareButton.enabled = false
        originalLabel.hidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: New Photo button pressed
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Uploading  Photo", message: "Select a source", preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Album", style: .Default, handler: { action in
            self.showPhotoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
        }))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera(){
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    func showPhotoLibrary(){
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Image Picker delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage]{
            originalImage = image as! UIImage
            displayOriginalImage()
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: onFilter button pressed
    @IBAction func onFilter(sender: UIButton) {
        if sender.selected{
            hideFilterMenu()
            sender.selected = false
            
            compareButton.enabled = false
            compareButton.selected = false
            filteredImage = UIImage()
            displayOriginalImage()
        } else {
            showFilterMenu()
            sender.selected = true
            compareButton.enabled = true
        }
    }
    
    func showFilterMenu(){
        view.addSubview(filterMenu)
        
        filterMenu.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomConstraint = filterMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let rightConstraint = filterMenu.rightAnchor.constraintEqualToAnchor(bottomMenu.rightAnchor)
        let leftConstraint = filterMenu.leftAnchor.constraintEqualToAnchor(bottomMenu.leftAnchor)
        let heightConstraint = filterMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, rightConstraint, leftConstraint, heightConstraint])
        view.layoutIfNeeded()

    }
    
    func hideFilterMenu(){
        self.filterMenu.removeFromSuperview()
    }
    
    
    @IBAction func contrastFilter(sender: AnyObject) {
        if let image = originalImageView.image{
            let imageProcessor = ImageProcessor(image: image)
            filteredImage = imageProcessor.applyFilter(filterType: filter.contrast)
            displayFilteredImage()
        }
    }
    
    
    @IBAction func sepiaFilter(sender: AnyObject) {
        if let image = originalImageView.image{
            let imageProcessor = ImageProcessor(image: image)
            filteredImage = imageProcessor.applyFilter(filterType: filter.sepia)
            displayFilteredImage()
        }
    }
    
    //MARK: Compare button pressed
    @IBAction func onCompare(sender: UIButton) {
        if sender.selected{
            sender.selected = false
            displayFilteredImage()
        } else {
            sender.selected = true
            displayOriginalImage()
        }
    }
    
    func displayOriginalImage(){
        originalLabel.hidden = false
        originalImageView.image = originalImage
        originalImageView.hidden = false
        originalImageView.alpha = 0.5
        
        filteredImageView.alpha = 0.5
        
        UIView.animateWithDuration(0.4) { () -> Void in
            self.originalImageView.alpha = 1
            self.filteredImageView.alpha = 0
            self.filteredImageView.hidden = true
        }
        
    }
    
    func displayFilteredImage(){
        originalLabel.hidden = true
        filteredImageView.image = filteredImage
        filteredImageView.hidden = false
        filteredImageView.alpha = 0.5
        
        originalImageView.alpha = 0.5
        UIView.animateWithDuration(0.4) { () -> Void in
            self.filteredImageView.alpha = 1
            self.originalImageView.alpha = 0
            self.originalImageView.hidden = true
        }
    }
    
    //MARK: Share button pressed
    @IBAction func onShare(sender: AnyObject) {
        
    }
    

}

