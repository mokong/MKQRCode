//
//  ViewController.swift
//  QRCodeGenerator
//
//  Created by MYK on 16/11/15.
//  Copyright © 2016年 MYK. All rights reserved.
//

/*
 * 参考
 * https://www.appcoda.com/qr-code-generator-tutorial/
 * http://www.tuicool.com/articles/ie2aAjv
 */

import UIKit

class ViewController: UIViewController {
    
    // MARK: properties
    
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var generatorButton: UIButton!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var displaySlider: UISlider!
    
    var qrCodeImage: CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: action
    
    @IBAction func generatorButtonTapped(_ sender: UIButton) {
        if qrCodeImage == nil {
            if inputTextField.text == nil {
                return
            }
            let data = inputTextField.text?.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrCodeImage = filter?.outputImage
            
            displayQRCodeImage()
            inputTextField.resignFirstResponder()
            
            generatorButton.setTitle("Clear", for: .normal)
        }
        else {
            displayImageView.image = nil
            qrCodeImage = nil
            generatorButton.setTitle("generator", for: .normal)
        }
        
        inputTextField.isEnabled = !inputTextField.isEnabled
        displaySlider.isHidden = !displaySlider.isHidden
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        displayImageView.transform = CGAffineTransform(scaleX: CGFloat(sender.value), y: CGFloat(sender.value))
    }

    // MARK: others
    func displayQRCodeImage() {
        let scaleX = displayImageView.frame.size.width / qrCodeImage.extent.size.width
        let scaleY = displayImageView.frame.size.height / qrCodeImage.extent.size.height
        
        let transformedImage = qrCodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        displayImageView.image = UIImage(ciImage: transformedImage)
    }
}

