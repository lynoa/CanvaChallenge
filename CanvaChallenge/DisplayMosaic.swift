//
//  DisplayMosaic.swift
//  CanvaChallenge
//
//  Created by Caroline Datin on 11/05/2016.
//  Copyright © 2016 Caroline. All rights reserved.
//

import Foundation

import UIKit
import Foundation
import CoreGraphics
import CoreImage
import TakeHomeTask



class DisplayMosaic: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    let server = MosaicTileServer()
    var tiles = [Tile]()
    var tileSize = 32
    var image = UIImage()
    var totalTiles = 0
    var displayedTiles = 0 {
        didSet {
            //As long as the rendering process is not finished, it's impossible to go back to the previous screen.
            if displayedTiles == totalTiles {
                self.navigationItem.setHidesBackButton(false, animated: true)

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let xNbTiles = Int(image.size.width) / self.tileSize
        let yNbTiles = Int(image.size.height) / self.tileSize
        totalTiles = yNbTiles * xNbTiles;
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.splitImageInTiles()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func splitImageInTiles()
    {
        
        var x = 0
        var y = 0
        let attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_BACKGROUND, 0);
        
        self.scrollView.contentSize = self.image.size
        //Creating a queue for each row.
        //Each queue are gonna be async with parallelism from each other.
        //Each task from each queue are serial in order to limit the amount of thread processing
        //at the same time.
        var tiles = dispatch_queue_create("com.canvachallenge.lineNo\(y)", attr)
        
        for _ in 0..<totalTiles {
            let rect = CGRect(x: x, y: y, width: self.tileSize, height: self.tileSize)
            dispatch_async(tiles, { [unowned self] _ in
                let result = self.calcSplit(x, y:y, rect: rect)
                dispatch_async(dispatch_get_main_queue(), {
                    var newTile = Tile(tileRect: rect)
                    newTile.avgColor = result
                    self.downloadTiles(newTile)
                })
            })
            x += self.tileSize
            if (x + self.tileSize) > Int(image.size.width) {
                x = 0
                y += self.tileSize
                tiles = dispatch_queue_create("com.canvachallenge.lineNo\(y)", attr)
            }
        }
    }
    
    //
    func calcSplit(x: Int, y: Int, rect: CGRect) -> UIColor
    {
        let originalTile = CIImage(CGImage: CGImageCreateWithImageInRect(image.CGImage, rect)!)
        
        //Creating a 1 pixel CIImage with the average of the given area.
        let pixelInfo = CIFilter(name: "CIAreaAverage", withInputParameters: [kCIInputImageKey : originalTile])?.outputImage
        
        
        let context = CIContext()
        var bitmap = [UInt8](count: 4, repeatedValue: 0)
        //Fill a one-pixel sized bitmap (with alpha) based on the CIImage
        context.render(pixelInfo!, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: kCIFormatRGBA8, colorSpace: CGColorSpaceCreateDeviceRGB())
        
        //Create a UIColor based on the bitmap.
        let result = UIColor(red: CGFloat(bitmap[0]) / 255.0, green: CGFloat(bitmap[1]) / 255.0, blue: CGFloat(bitmap[2]) / 255.0, alpha: CGFloat(bitmap[3]) / 255.0)
        return result
    }
    
    
    //Download the image corresponding to the tile. If the download succeed, the tile is displayed.
    func downloadTiles(tile: Tile)
    {
        let size = CGSize(width: self.tileSize, height: self.tileSize)
        let _ = server.fetchTileForColor(tile.avgColor, size: size,
                        success: { [unowned self] (image) in
                                    tile.imageView.image = image
                                    self.scrollView.addSubview(tile.imageView)
                                    self.displayedTiles = self.displayedTiles + 1
                        }, failure: { (error) in
                            print(error)
                        })
    }

    
}

struct Tile {
    
    var imageView: UIImageView
    var tileRect: CGRect
    var avgColor: UIColor
    
    init(tileRect: CGRect) {
        self.tileRect = tileRect
        imageView = UIImageView(image: UIImage(named: "Apple-Logo-rainbow"))
        imageView.frame = tileRect
        avgColor = UIColor.blueColor()
    }
}
