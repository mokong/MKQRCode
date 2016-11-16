//
//  ScanGeneratorView.swift
//  QRCodeGenerator
//
//  Created by MYK on 16/11/16.
//  Copyright © 2016年 MYK. All rights reserved.
//
/*
 ** 学习，来自
 *
 * https://www.appcoda.com/qr-code-generator-tutorial/
 * http://www.tuicool.com/articles/ie2aAjv
 *
 */


import UIKit

class ScanGeneratorView: UIView {
    
    // MARK: properties
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var generatorButton: UIButton!
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var displaySlider: UISlider!
    
    var qrCodeImage: CIImage!
    
    // MARK: init
    class func instanceFromNib() -> ScanGeneratorView {
        let scanGeneratorView = ScanGeneratorView.loadFromNibNamed("ScanGeneratorView", bundle: nil) as! ScanGeneratorView
        return scanGeneratorView
    }
    
    
    // MARK: action
    @IBAction func generatorButtonTapped(sender: UIButton) {
        if qrCodeImage == nil {
            if inputTextField.text == nil || inputTextField.text?.length == 0 {
                return
            }
            
            let inputTextData = inputTextField.text!.dataUsingEncoding(NSISOLatin1StringEncoding, allowLossyConversion: false)
            // 下面这几个参数可参考 http://www.tuicool.com/articles/ie2aAjv 里的解释
            let fileter = CIFilter(name: "CIQRCodeGenerator")
            fileter?.setValue(inputTextData, forKey: "inputMessage")
            fileter?.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrCodeImage = fileter?.outputImage
            
            // 缩放并显示
            displayQRCodeImageView()
            
            inputTextField.resignFirstResponder()
            generatorButton.setTitle("Clear", forState: .Normal)
            
        }
        else {
            displayImageView.image = nil
            qrCodeImage = nil
            generatorButton.setTitle("Generator", forState: .Normal)
        }
        
        inputTextField.enabled = !inputTextField.enabled
//        displaySlider.hidden = !displaySlider.hidden
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        displayImageView.transform = CGAffineTransformMakeScale(CGFloat(sender.value), CGFloat(sender.value))

    }
    
    // MARK: other
    func displayQRCodeImageView() {
        let scaleX = displayImageView.frame.size.width / qrCodeImage.extent.size.width
        let scaleY = displayImageView.frame.size.height / qrCodeImage.extent.size.height
        
        let transformImage = qrCodeImage.imageByApplyingTransform(CGAffineTransformMakeScale(scaleX, scaleY))
        displayImageView.image = UIImage(CIImage: transformImage)
    }
    
}
