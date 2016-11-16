//
//  ScanGeneratorController.swift
//  QRCodeGenerator
//
//  Created by MYK on 16/11/16.
//  Copyright © 2016年 MYK. All rights reserved.
//

import UIKit
import SnapKit

class ScanGeneratorController: UIViewController {

    // MARK: properties
    var scanGeneratorView: ScanGeneratorView!
    
    // MARK: view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupSubviews()
    }
    
    func setupSubviews() {
        if self.scanGeneratorView == nil {
            self.scanGeneratorView = ScanGeneratorView.instanceFromNib()
            self.view.addSubview(scanGeneratorView)
            
            scanGeneratorView.snp_makeConstraints(closure: { (make) in
                make.edges.equalTo(self.view).inset(UIEdgeInsetsZero)
            })
        }
    }

    // action
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
