import UIKit

// Enumeration: Filters
public enum filter:String{
    case grayscale = "grayscale"
    case brightness = "brightness"
    case contrast = "contrast"
    case sepia = "sepia"
    case transparency = "transparency"
}

// Class: Image Processor
public class ImageProcessor {
    var image: UIImage
    
    
    public init(image:UIImage){
        self.image = image
    }
    
    // Multiple filters from Enumeration
    public func applyFilters(filterTypes filters: (type:filter,intensity:Int)...) ->UIImage{
        for filter in filters{
            applyFilter(filterType: filter.type, intensity: filter.intensity)
        }
        return self.image
    }
    
    // Multiple filters from String
    public func applyFilters(filterTypes filters: (type:String,intensity:Int)...) ->UIImage{
        for filter in filters{
            applyFilter(filterType: filter.type, intensity: filter.intensity)
        }
        return self.image
    }
    
    // Apple filter from String
    public func applyFilter( filterType filterName: String) ->UIImage{
        switch(filterName.lowercaseString){
        case filter.grayscale.rawValue:
            return filter1()
        case filter.brightness.rawValue:
            return filter2()
        case filter.contrast.rawValue:
            return filter3()
        case filter.sepia.rawValue:
            return filter4()
        case filter.transparency.rawValue:
            return filter5()
        default: return self.image
        }
    }
    
    // Apply filter from String, with intensity
    public func applyFilter( filterType filterName: String, intensity: Int) ->UIImage{
        switch(filterName.lowercaseString){
        case filter.grayscale.rawValue:
            return filter1(intensity)
        case filter.brightness.rawValue:
            return filter2(intensity)
        case filter.contrast.rawValue:
            return filter3(intensity)
        case filter.sepia.rawValue:
            return filter4(intensity)
        case filter.transparency.rawValue:
            return filter5(intensity)
        default: return self.image
        }
    }
    
    // Apple filter from Enumeration
    public func applyFilter( filterType filterName: filter) ->UIImage{
        switch(filterName){
        case .grayscale:
            return filter1()
        case .brightness:
            return filter2()
        case .contrast:
            return filter3()
        case .sepia:
            return filter4()
        case .transparency:
            return filter5()
        }
    }
    
    // Apply filter from Enumeration, with intensity
    public func applyFilter( filterType filterName: filter, intensity: Int) ->UIImage{
        
        switch(filterName){
        case .grayscale:
            return filter1(intensity)
        case .brightness:
            return filter2(intensity)
        case .contrast:
            return filter3(intensity)
        case .sepia:
            return filter4(intensity)
        case .transparency:
            return filter5(intensity)
        }
    }
    
    /*---------------------------------------------------*/
    // Methods: Filters
    /*---------------------------------------------------*/
    
    //Grayscale
    func filter1(intensity: Int = 50) -> UIImage{
        let myRGBA = RGBAImage(image: self.image)!
        
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y * myRGBA.width + x
                var pixel = myRGBA.pixels[index]
                let red: Double = Double(pixel.red)
                let green: Double = Double(pixel.green)
                let blue: Double = Double(pixel.blue)
                
                //Apply filter
                let newRed : Double = 0.2989 * red + 0.5870 * green + 0.1140 * blue
                let newGreen : Double = 0.2989 * red + 0.5870 * green + 0.1140 * blue
                let newBlue : Double = 0.2989 * red + 0.5870 * green + 0.1140 * blue
                
                //Apply intensity
                pixel.red = UInt8(max(0,min(255,(newRed * Double(intensity+50) / 100))))
                pixel.green = UInt8(max(0,min(255,(newGreen * Double(intensity+50) / 100))))
                pixel.blue = UInt8(max(0,min(255,(newBlue * Double(intensity+50) / 100))))
                
                myRGBA.pixels[index] = pixel
            }
        }
        
        self.image = myRGBA.toUIImage()!
        return self.image
    }
    
    //Brightness
    func filter2(intensity: Int = 100) -> UIImage{
        let myRGBA = RGBAImage(image: self.image)!
        
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y * myRGBA.width + x
                var pixel = myRGBA.pixels[index]
                let red: Double = Double(pixel.red)
                let green: Double = Double(pixel.green)
                let blue: Double = Double(pixel.blue)
                
                //Apply filter and intensity
                pixel.red = UInt8(max(0, min(255, (red * ( Double(intensity+50)) / 100))))
                pixel.green = UInt8(max(0, min(255, (green * (Double(intensity+50)) / 100))))
                pixel.blue = UInt8(max(0, min(255, (blue * (Double(intensity+50)) / 100))))
                
                myRGBA.pixels[index] = pixel
            }
        }
        
        self.image = myRGBA.toUIImage()!
        return self.image
    }
    
    //Contrast
    func filter3(intensity: Int = 100) -> UIImage{
        let myRGBA = RGBAImage(image: self.image)!
        let contrast: Double = ( Double(intensity) / 100 ) * 510 - 255
        let factor: Double = ( 259 * ( contrast + 255 ) ) / ( 255 * ( 259 - contrast ) )
        
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y * myRGBA.width + x
                var pixel = myRGBA.pixels[index]
                let red: Double = Double(pixel.red)
                let green: Double = Double(pixel.green)
                let blue: Double = Double(pixel.blue)
                
                //Apply filter and intensity
                pixel.red = UInt8(max(0, min(255, (factor * (red - 128)) + 128 )))
                pixel.green = UInt8(max(0, min(255, (factor * (green - 128)) + 128 )))
                pixel.blue = UInt8(max(0, min(255, (factor * (blue - 128)) + 128 )))
                
                myRGBA.pixels[index] = pixel
            }
        }
        
        self.image = myRGBA.toUIImage()!
        return self.image
    }
    
    //Sepia
    func filter4(intensity: Int = 50) -> UIImage{
        let myRGBA = RGBAImage(image: self.image)!
        
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y * myRGBA.width + x
                var pixel = myRGBA.pixels[index]
                let red: Double = Double(pixel.red)
                let green: Double = Double(pixel.green)
                let blue: Double = Double(pixel.blue)
                
                //Apply filter
                let newRed : Double = 0.393 * red + 0.769 * green + 0.189 * blue
                let newGreen : Double = 0.349 * red + 0.686 * green + 0.168 * blue
                let newBlue : Double = 0.272 * red + 0.534 * green + 0.131 * blue
                
                //Apply intensity
                pixel.red = UInt8(max(0,min(255,(newRed * Double(intensity+50) / 100))))
                pixel.green = UInt8(max(0,min(255,(newGreen * Double(intensity+50) / 100))))
                pixel.blue = UInt8(max(0,min(255,(newBlue * Double(intensity+50) / 100))))
                
                myRGBA.pixels[index] = pixel
            }
        }
        
        self.image = myRGBA.toUIImage()!
        return self.image
    }
    
    //Transparency
    func filter5(intensity: Int = 75) -> UIImage{
        let myRGBA = RGBAImage(image: self.image)!
        
        for y in 0..<myRGBA.height{
            for x in 0..<myRGBA.width{
                let index = y * myRGBA.width + x
                var pixel = myRGBA.pixels[index]
                
                pixel.alpha = UInt8(max(0,min(255,(255 * Double(100-intensity) / 100))))
                
                myRGBA.pixels[index] = pixel
            }
        }
        
        self.image = myRGBA.toUIImage()!
        return self.image
    }
}
