//
//  ViewController.swift
//  ImageFilterApp
//
//  Created by Karlo Pagtakhan on 01/19/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
    UICollectionViewDelegate,
    UICollectionViewDataSource{
    //MARK: Global variables
    var originalImage: UIImage? = nil
    var filteredImage: UIImage? = nil
    var filterIconImage: UIImage? = nil
    var selectedFilter : filter? = nil
    var bottomMenuColor: UIColor = UIColor()

    var filterNameArray = ["Grayscale","Brightness", "Contrast", "Sepia", "Transparency"]
    var filterEnumArray: [filter] = [.grayscale,.brightness, .contrast, .sepia,.transparency]
    var filterImageArray = [UIImage()]
    
    //MARK: Outlets
    @IBOutlet var originalImageView: UIImageView!
    @IBOutlet var filteredImageView: UIImageView!
    @IBOutlet var originalLabel: UILabel!
    
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var compareButton: UIButton!
    @IBOutlet var editButton: UIButton!
    
    @IBOutlet var bottomMenu: UIStackView!
    @IBOutlet var filterMenu: UIView!
    @IBOutlet var filterCollectionView: UIView!
    
    @IBOutlet var selectPhotoView: UIView!
    
    @IBOutlet var sliderView: UIView!
    @IBOutlet var slider: UISlider!

    @IBOutlet var contrastButton: UIButton!
    @IBOutlet var sepiaButton: UIButton!
    @IBOutlet var grayscaleButton: UIButton!
    @IBOutlet var transparencyButton: UIButton!
    @IBOutlet var brightnessButton: UIButton!
    
    @IBOutlet var collectionView: UICollectionView!
    
    
    //MARK: Standard functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Default status
        compareButton.enabled = false
        editButton.enabled = false
        
        originalLabel.hidden = true
        
        bottomMenuColor = filterButton.backgroundColor!
        
        // Handle quick tap to temporarily display the original image
        filteredImageView.userInteractionEnabled = true
        
        
        
    }
    
    // Handle quick tap to temporarily display the original image
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        if let touch = touches.first! as? UITouch{
            if touch.view == filteredImageView{
                displayOriginalImage()
                closePhotoViewEnableMenu()
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


        
        /*
        
        originalImageView.alpha = 0.5
        filteredImageView.alpha = 0.5
        
        disableBottomMenus()
        
        view.addSubview(selectPhotoView)
        
        // Disable Default Auto Layout
        selectPhotoView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set constraints
        let centerXAnchor = selectPhotoView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        let centerYAnchor = selectPhotoView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor)
        let heightConstraint = selectPhotoView.heightAnchor.constraintEqualToConstant(125)
        let widthConstraint = selectPhotoView.widthAnchor.constraintEqualToConstant(250)
        
        // Add constraints to view
        NSLayoutConstraint.activateConstraints([centerXAnchor, centerYAnchor, heightConstraint, widthConstraint])
        view.layoutIfNeeded()
        
        */

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
    
    //Disable Bottom menu and filter menu
    func disableBottomMenus(){
        self.bottomMenu.userInteractionEnabled = false
        self.filterMenu.userInteractionEnabled = false
    }
    
    func resetBottomMenu(){
        //Deselect all buttons
        filterButton.selected = false
        compareButton.selected = false
        editButton.selected = false
        
        //Remove filtered images
        filteredImageView.image = nil
        filteredImage = nil
        
        filterMenu.removeFromSuperview()
        sliderView.removeFromSuperview()
        
        
        editButton.enabled = false
        compareButton.enabled = false
        
        filterButton.backgroundColor! = bottomMenuColor
        editButton.backgroundColor! = bottomMenuColor
        
    }
    func closePhotoViewEnableMenu(){
        self.selectPhotoView.removeFromSuperview()
        self.bottomMenu.userInteractionEnabled = true
        self.filterMenu.userInteractionEnabled = true
    }
    
    //MARK: Image Picker delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            // Show uploaded image and set it as orginal image
            originalImage = resizeImage(image, newWidth: 600)
            displayOriginalImage()
            
            // Create a smaller image for filter menu
            filterIconImage = resizeImage(image, newWidth: 100, square: true)
            
            //Hide image picker view
            dismissViewControllerAnimated(true, completion: nil)
            
            
            closePhotoViewEnableMenu()
            resetBottomMenu()
            
            //Show original image right away
            originalImageView.alpha = 1
            filteredImageView.alpha = 0
            
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
        
        closePhotoViewEnableMenu()
        
        originalImageView.alpha = 1
        filteredImageView.alpha = 1
    }
    
    func resizeImage(image:UIImage, newWidth: CGFloat, square: Bool = false) ->UIImage{
        if square{
            let newHeight = newWidth
            
            UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
            image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        
            return newImage
        } else {
            let scale = newWidth / image.size.width
            let newHeight = image.size.height * scale
            
            UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
            image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage
        }
    }
    
    //MARK: onFilter button pressed
    @IBAction func onFilter(sender: UIButton) {
        if sender.selected{
            if editButton.selected{
                sender.selected = true
                editButton.selected = false
                editButton.backgroundColor = bottomMenuColor
                compareButton.selected = false
                
                showFilterMenu()
                filterButton.backgroundColor = UIColor.whiteColor()
            } else{
            sender.selected = false
        
                resetBottomMenu()
            
                //Hide filter menu and slider
                hideFilterMenu()
                sliderView.removeFromSuperview()
            
                displayOriginalImage()
                filterButton.backgroundColor = bottomMenuColor
                editButton.backgroundColor = bottomMenuColor
                slider.value = 50
            }
        } else {
            if originalImage != nil{
                sender.selected = true

                showFilterMenu()
                filterButton.backgroundColor! = UIColor.whiteColor()
                slider.value = 50
            }
        }
    }
    
    func showFilterMenu(){
        
        //Add filter menu to main view
        //view.addSubview(filterMenu)
        view.addSubview(filterCollectionView)
        
        
        //Disable default constraints
        //filterMenu.translatesAutoresizingMaskIntoConstraints = false
        filterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        //Add constraints
        /*
        let bottomConstraint = filterMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let rightConstraint = filterMenu.rightAnchor.constraintEqualToAnchor(bottomMenu.rightAnchor)
        let leftConstraint = filterMenu.leftAnchor.constraintEqualToAnchor(bottomMenu.leftAnchor)
        let heightConstraint = filterMenu.heightAnchor.constraintEqualToConstant(44)
        */
        let bottomConstraint = filterCollectionView.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let rightConstraint = filterCollectionView.rightAnchor.constraintEqualToAnchor(bottomMenu.rightAnchor)
        let leftConstraint = filterCollectionView.leftAnchor.constraintEqualToAnchor(bottomMenu.leftAnchor)
        let heightConstraint = filterCollectionView.heightAnchor.constraintEqualToConstant(150)
        

        filterImageArray.removeAll()
        
        for filter in filterEnumArray{
        
            let imageProcessor = ImageProcessor(image: filterIconImage!)
            
            filterImageArray.append(imageProcessor.applyFilter(filterType: filter))
        }
        
        
        //Enable constraints
        NSLayoutConstraint.activateConstraints([bottomConstraint, rightConstraint, leftConstraint, heightConstraint])
        view.layoutIfNeeded()

        /*
        setFilterIcon(contrastButton, filterSelected: .contrast)
        setFilterIcon(sepiaButton, filterSelected: .sepia)
        setFilterIcon(grayscaleButton, filterSelected: .grayscale)
        setFilterIcon(brightnessButton, filterSelected: .brightness)
        setFilterIcon(transparencyButton, filterSelected: .transparency)
        */
    }
    func setFilterIcon(button: UIButton, filterSelected : filter){
        let imageProcessor = ImageProcessor(image: filterIconImage!)
        button.setImage(imageProcessor.applyFilter(filterType: filterSelected), forState: .Normal)
        button.imageView?.contentMode = .ScaleAspectFit
        button.setTitle("", forState: .Normal)
    }
    
    func hideFilterMenu(){
        //self.filterMenu.removeFromSuperview()
        self.filterCollectionView.removeFromSuperview()
    }
    
    
    
    @IBAction func contrastFilter(sender: AnyObject) {
        compareButton.selected = false
        compareButton.enabled = true
        editButton.enabled = true
        slider.value = 50
        
        selectedFilter = .contrast
        applyFilter(selectedFilter!)
    }
    
    
    @IBAction func sepiaFilter(sender: AnyObject) {
        compareButton.selected = false
        compareButton.enabled = true
        editButton.enabled = true
        slider.value = 50
        
        selectedFilter = .sepia
        applyFilter(selectedFilter!)
    }
    
    @IBAction func grayscaleFilter(sender: AnyObject) {
        compareButton.selected = false
        compareButton.enabled = true
        editButton.enabled = true
        slider.value = 50
        
        selectedFilter = .grayscale
        applyFilter(selectedFilter!)
    }
    
    @IBAction func transparencyFilter(sender: AnyObject) {
        compareButton.selected = false
        compareButton.enabled = true
        editButton.enabled = true
        slider.value = 50
        
        
        selectedFilter = .transparency
        applyFilter(selectedFilter!)
    }
    
    @IBAction func brightnessFilter(sender: AnyObject) {
        compareButton.enabled = true
        editButton.enabled = true
        slider.value = 50
        
        
        selectedFilter = .brightness
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
    @IBAction func onEdit(sender: UIButton) {
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
            
            
            if sender.selected{
                sender.selected = false
                sliderView.removeFromSuperview()
                filterButton.backgroundColor! = UIColor.whiteColor()
                editButton.backgroundColor! = bottomMenuColor
            } else{
                sender.selected = true
                editButton.backgroundColor! = UIColor.whiteColor()
                filterButton.backgroundColor! = bottomMenuColor
                filterCollectionView.removeFromSuperview()
            }
        }
    }
    
    @IBAction func sliderMoved(sender: AnyObject) {
        if let filter = selectedFilter{
            applyFilter(filter, intensity: Int(slider.value), animations: false)
            compareButton.selected = false
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
            } else {
                filteredImageView.alpha = 0
                originalImageView.alpha = 1
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
            } else {
                originalImageView.alpha = 0
                filteredImageView.alpha = 1
            }
        }
    }
    
    func transitionToViews(fadeFrom:UIImageView, fadeTo:UIImageView){
        fadeTo.alpha = 0.5
        
        fadeFrom.alpha = 1
        UIView.animateWithDuration(0.4) { () -> Void in
            fadeTo.alpha = 1
            fadeFrom.alpha = 0
        }
    }
    
    //MARK: Share button pressed
    @IBAction func onShare(sender: AnyObject) {
        if let image = filteredImage{
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.presentViewController(activityViewController, animated: true, completion: nil)
        } else {
            
            if let image = originalImage{
                let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                self.presentViewController(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    //Mark: UICollectionView Data source
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! FilterCollectionViewCell
        
        cell.imageView.image = filterImageArray[indexPath.row]
        cell.label.text = filterNameArray[indexPath.row]
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filterNameArray.count
    }
    
    //Mark: UICollectionView Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        compareButton.selected = false
        compareButton.enabled = true
        editButton.enabled = true
        slider.value = 50
        
        selectedFilter = filterEnumArray[indexPath.row]
        applyFilter(selectedFilter!)
    }

}

