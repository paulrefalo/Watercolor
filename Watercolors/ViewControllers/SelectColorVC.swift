//
//  SelectColorVC.swift
//  Watercolors
//
//  Created by Paul ReFalo on 4/4/17.
//  Copyright © 2017 ReFalo. All rights reserved.
//

import UIKit
import CoreData

extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {

        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4

        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }

}

extension UIColor {

    // MARK: - Initialization

    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt32 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.characters.count

        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }

    // MARK: - Computed Properties

    var toHex: String? {
        return toHex()
    }

    // MARK: - From UIColor to String

    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
}

class SelectColorVC: UIViewController {
    // MARK: - Properties
    var managedContext: NSManagedObjectContext!
    var colorTouched = ""
    var colorCode = ""

    // MARK: - IBOutlets
    @IBOutlet weak var colorFlowerImageView: UIImageView!

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
        colorFlowerImageView.addGestureRecognizer(tapRecognizer)
        colorFlowerImageView.isUserInteractionEnabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



    func tapGesture(_ recognizer: UITapGestureRecognizer) {
        colorTouched = ""
        let point: CGPoint = recognizer.location(in: colorFlowerImageView)
        let color = colorFlowerImageView.image?.getPixelColor(pos: point)

        let colorHex = color?.toHex
        print (colorHex as Any)

        if colorHex  == "ED1C24" {
         colorTouched =  "Reds"
        }

        if colorHex  == "EF4036" {
            colorTouched =  "Oranges"
        }

        if colorHex  == "810F14" {
            colorTouched =  "Reds"
        }


        if colorHex  == "fff200" {
            colorTouched =  "Yellows"
        }
        if colorHex  == "0E76BC" {
            colorTouched =  "Blues"
        }
        if colorHex  == "662D91" {
            colorTouched =  "Violets"
        }
        if colorHex  == "010102" {
            colorTouched =  "Blacks"
        }

        //"Greens"
        //"Whites"
        //"Earth Tones"

        if colorTouched != "" {
                performSegue(withIdentifier: "showColorFamilySegue", sender: self)

        }


    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let dvc: ColorFamilyTVC? = (segue.destination as? ColorFamilyTVC)

        dvc?.colorFamily = colorTouched
        dvc?.managedContext = managedContext
        
    }
    
    
}
