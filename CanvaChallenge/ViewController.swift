//
//  ViewController.swift
//  CanvaChallenge
//
//  Created by Caroline Datin on 30/04/2016.
//  Copyright © 2016 Caroline. All rights reserved.
//

import UIKit
import Foundation
import Darwin

let MAX_TILES : CGFloat = 4000.0
let DEFAULT_SIZE : Float = 32.0

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var previewImageView: UIImageView!
    
    @IBOutlet weak var slider: UISlider!

    @IBOutlet weak var labelTileSize: UILabel!
    @IBOutlet weak var choseTileSize: UISlider!
    
    @IBAction func choseImage(sender: AnyObject) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = false
        imgPicker.sourceType = .PhotoLibrary
        self.presentViewController(imgPicker, animated:true, completion: nil)
    }
    
    @IBAction func sizeChanged(sender: UISlider) {
        self.labelTileSize.text = "\(Int(sender.value)) px"
    }
    
    @IBAction func launchMosaic(sender: AnyObject) {
        performSegueWithIdentifier("launchMosaic", sender: sender)
    }
    
    override func viewDidLoad() {
        minTileSize(self.previewImageView.image!)
    }
    
    
    // This method compute the minimum size of a tile based on a maximum amount of tiles.
    func minTileSize(image: UIImage)  {
        
        let imageSurface = image.size.width * image.size.height
        
        let res = sqrt(imageSurface / MAX_TILES)
        
        self.slider.minimumValue = Float(floor(res))
        self.slider.maximumValue = self.slider.minimumValue + DEFAULT_SIZE
        self.slider.value = DEFAULT_SIZE
        self.labelTileSize.text = "\(Int(slider.value)) px"
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let dest = segue.destinationViewController as! DisplayMosaic
        dest.image = self.previewImageView.image ?? UIImage()
        dest.tileSize = Int(self.slider.value)
    }

    
    //Delegate of Image Picker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        // If the image is way to big to be displayed properly into an iphone screen
        // it is resized.
        if image.size.height > self.view.frame.height {
            let resizedImg = image.resizedImageToFitInSize(CGSize(width: image.size.width, height: self.view.frame.height - 64), scaleIfSmaller: false)
            self.previewImageView.image = resizedImg
        } else {
            self.previewImageView.image = image
        }
        minTileSize(self.previewImageView.image!)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
