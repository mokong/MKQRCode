//
//  ViewController.swift
//  QRCodeGenerator
//
//  Created by MYK on 16/11/15.
//  Copyright © 2016年 MYK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: properties
    var scanGeneratorView: ScanGeneratorView!
    
    // MARK: view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    // MARK: action
    // 生成二维码
    @IBAction func scanGeneratorButtonTapped(sender: UIButton) {
        let generatorVC = ScanGeneratorController()
        self.presentViewController(generatorVC, animated: true, completion: nil)
    }
    
    // 扫描二维码
    @IBAction func scanButtonTapped(sender: UIButton) {
        
    }
    
   
    // MARK: other
    
}

