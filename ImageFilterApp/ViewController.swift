//
//  ViewController.swift
//  ImageFilterApp
//
//  Created by Karlo Pagtakhan on 01/19/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Global variables
    var originalImage: UIImage? = nil
    var filteredImage: UIImage? = nil
    var selectedFilter : filter? = nil
    
    //MARK: Outlets
    @IBOutlet var originalImageView: UIImageView!
    @IBOutlet var filteredImageView: UIImageView!
    
    @IBOutlet var originalLabel: UILabel!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var compareButton: UIButton!
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var bottomMenu: UIStackView!
    @IBOutlet var filterMenu: UIView!
    
    @IBOutlet var selectPhotoView: UIView!
    
    @IBOutlet var sliderView: UIView!
    @IBOutlet var slider: UISlider!

    
    //MARK: Standard functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Default status
        compareButton.enabled = false
        editButton.enabled = false
        
        originalLabel.hidden = true
        
        // Handle quick tap to temporarily display the original image
        filteredImageView.userInteractionEnabled = true
        
    }
    
    // Handle quick tap to temporarily display the original image
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if let touch = touches.first! as? UITouch{
            if touch.view == filteredImageView{
                displayOriginalImage()
                self.selectPhotoView.removeFromSuperview()
            }
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesEnded(touches, withEvent: event)
        if let touch = touches.first! as? UITouch{
            if touch.view == filteredImageView{
                displayFilteredImage()
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: New Photo button pressed
    @IBAction func onNewPhoto(sender: AnyObject) {
        /*
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

        */
        
        view.addSubview(selectPhotoView)
        
        selectPhotoView.translatesAutoresizingMaskIntoConstraints = false
        
        let centerXAnchor = selectPhotoView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        let centerYAnchor = selectPhotoView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)
        let heightConstraint = selectPhotoView.heightAnchor.constraintEqualToConstant(125)
        let widthConstraint = selectPhotoView.widthAnchor.constraintEqualToConstant(250)
        
        NSLayoutConstraint.activateConstraints([centerXAnchor, centerYAnchor, heightConstraint, widthConstraint])
        
        view.layoutIfNeeded()
        originalImageView.alpha = 0.5
        filteredImageView.alpha = 0.5

    }
    @IBAction func cameraButton(sender: AnyObject) {
        showCamera()
    }
    
    @IBAction func photoAlbumButton(sender: AnyObject) {
        showPhotoLibrary()
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
        imagePicker.allowsEditing = true
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Image Picker delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            originalImage = resizeImage(image, newWidth: 600)
            displayOriginalImage()
            
            dismissViewControllerAnimated(true, completion: nil)
            self.selectPhotoView.removeFromSuperview()
            
            //Show original image right away
            originalImageView.alpha = 1
            filteredImageView.alpha = 0
            
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        selectPhotoView.removeFromSuperview()
        originalImageView.alpha = 1
        filteredImageView.alpha = 1
    }
    
    func resizeImage(image:UIImage, newWidth: CGFloat) ->UIImage{
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    
    }
    
    
    //MARK: onFilter button pressed
    @IBAction func onFilter(sender: UIButton) {
        if sender.selected{
            hideFilterMenu()
            sender.selected = false
            
            compareButton.enabled = false
            compareButton.selected = false
            editButton.enabled = false
            editButton.selected = false
            
            
            filteredImage = nil
            displayOriginalImage()
        } else {
            showFilterMenu()
            sender.selected = true
            compareButton.enabled = true
            editButton.enabled = true
            
            slider.value = 50
        }
    }
    
    func showFilterMenu(){
        
        //Add filter menu to main view
        view.addSubview(filterMenu)
        
        //Disable default constraints
        filterMenu.translatesAutoresizingMaskIntoConstraints = false
        
        //Add constraints
        let bottomConstraint = filterMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let rightConstraint = filterMenu.rightAnchor.constraintEqualToAnchor(bottomMenu.rightAnchor)
        let leftConstraint = filterMenu.leftAnchor.constraintEqualToAnchor(bottomMenu.leftAnchor)
        let heightConstraint = filterMenu.heightAnchor.constraintEqualToConstant(44)
        
        //Enable constraints
        NSLayoutConstraint.activateConstraints([bottomConstraint, rightConstraint, leftConstraint, heightConstraint])
        view.layoutIfNeeded()

    }
    
    func hideFilterMenu(){
        self.filterMenu.removeFromSuperview()
    }
    
    
    @IBAction func contrastFilter(sender: AnyObject) {
        selectedFilter = .contrast
        applyFilter(selectedFilter!)
    }
    
    
    @IBAction func sepiaFilter(sender: AnyObject) {
        selectedFilter = .sepia
        applyFilter(selectedFilter!)
    }
    
    func applyFilter(filterSelected : filter){
        if let image = originalImageView.image{
            let imageProcessor = ImageProcessor(image: image)
            filteredImage = imageProcessor.applyFilter(filterType: filterSelected)
            displayFilteredImage()
        }
    }
    
    func applyFilter(filterSelected : filter, intensity: Int, animations: Bool = true){
        // Ensure that there's an image to be filtered
        if let image = originalImageView.image{
            //Initialize Filter object
            let imageProcessor = ImageProcessor(image: image)
            //Apply filter
            filteredImage = imageProcessor.applyFilter(filterType: filterSelected, intensity: intensity)
            
            displayFilteredImage(false)
        }
    }
    
    //MARK: Edit button pressed
    @IBAction func onEdit(sender: AnyObject) {
        if filteredImage != nil{
            //Add slider to main view
            view.addSubview(sliderView)
        
            //Disable default constraints
            sliderView.translatesAutoresizingMaskIntoConstraints = false
        
            //Add constraints
            let bottomConstraint = sliderView.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
            let rightConstraint = sliderView.rightAnchor.constraintEqualToAnchor (bottomMenu.rightAnchor)
            let leftConstraint = sliderView.leftAnchor.constraintEqualToAnchor(bottomMenu.leftAnchor)
            let heightConstraint = sliderView.heightAnchor.constraintEqualToConstant(44)
        
            //Enable constraints
            NSLayoutConstraint.activateConstraints([bottomConstraint, rightConstraint, leftConstraint, heightConstraint])
            view.layoutIfNeeded()
        }
    }
    
    @IBAction func sliderMoved(sender: AnyObject) {
        if let filter = selectedFilter{
            applyFilter(filter, intensity: Int(slider.value), animations: false)
        }
    }
    
    
    //MARK: Compare button pressed
    @IBAction func onCompare(sender: UIButton) {
        
        if filteredImage != nil{
            if sender.selected{
                sender.selected = false
                displayFilteredImage()
            } else {
                sender.selected = true
                displayOriginalImage()
            }
        }
    }
    
    func displayOriginalImage(animations : Bool = true){
        if originalImage != nil{
            originalLabel.hidden = false
            originalImageView.image = originalImage
        
            //Animations
            if animations {
                transitionToViews(filteredImageView, fadeTo: originalImageView)
            }
        }
    }
    
    func displayFilteredImage(animations : Bool = true){
        if filteredImage != nil{
            originalLabel.hidden = true
            filteredImageView.image = filteredImage
        
            //Animations
            if animations {
                transitionToViews(originalImageView, fadeTo: filteredImageView)
            }
        }
    }
    
    func transitionToViews(fadeFrom:UIImageView, fadeTo:UIImageView){
        fadeTo.hidden = false
        fadeTo.alpha = 0.5
        
        fadeFrom.alpha = 0.5
        UIView.animateWithDuration(0.1) { () -> Void in
            fadeTo.alpha = 1
            fadeFrom.alpha = 0
            fadeFrom.hidden = true
        }
    }
    
    //MARK: Share button pressed
    @IBAction func onShare(sender: AnyObject) {
        
    }
    

}

