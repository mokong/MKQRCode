//
//  MKScanCouponViewController.swift
//  CardCoupon
//
//  Created by moyekong on 10/29/15.
//  Copyright © 2015 wiwide. All rights reserved.
//

import UIKit
import AVFoundation

class MKScanCouponViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {

    let deviceWidth: CGFloat = UIScreen.mainScreen().bounds.width
    let deviceHeight: CGFloat = UIScreen.mainScreen().bounds.height
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var bottomBackView: UIView!
    @IBOutlet weak var leftBackView: UIView!
    @IBOutlet weak var topBackView: UIView!
    @IBOutlet weak var rightBackView: UIView!

    @IBOutlet weak var scanAreaView: UIView!
    @IBOutlet weak var line: UIImageView! // 交互线
    // scan indicator
    @IBOutlet weak var scanIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scanIndicatorLabel: UILabel!
    
    var lineTimer: NSTimer? // 交互线控制
    var qrSession: AVCaptureSession? // 会话
    var qrVideoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var flag = true
    
    // MARK: - UI
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        hidesBottomBarWhenPushed = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        updateUI()
        startMKQRCodeReading()
        showActivitorView(false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        initUI()
        startMKQRCodeReading()
    }
    
    func initUI() {
        if (qrSession == nil) && (qrVideoPreviewLayer == nil) {
            // Device
            let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            // capture device judge, input
            var input: AVCaptureDeviceInput?
            do {
                input = try AVCaptureDeviceInput(device: device)
                // set Metadata output
                let output = AVCaptureMetadataOutput()
                // 设置输出的代理
                // 使用主线程队列，相应比较同步；使用其他队列，相应不同步，容易让用户产生不好的体验
                output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
                
                // 拍摄会话，session
                let session = AVCaptureSession()
                if session.canSetSessionPreset(AVCaptureSessionPreset1920x1080) {
                    session.sessionPreset = AVCaptureSessionPreset1920x1080
                } else if session.canSetSessionPreset(AVCaptureSessionPreset1280x720) {
                    session.sessionPreset = AVCaptureSessionPreset1280x720
                } else {
                    session.sessionPreset = AVCaptureSessionPresetPhoto
                }
                
                // 添加输入、输出
                if session.canAddInput(input) {
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                // 设置输出的格式
                // 一定要先设置会话的输出为output之后，再指定输出的元数据类型
                // 条码类型，AetadataObjectTypeQRCode即二维码，如果需要扫条形码，就要在这个数组里添加枚举
                output.metadataObjectTypes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]
                
                // 设置预览图层 preview
                let previewLayer = AVCaptureVideoPreviewLayer(session: session)
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                
                // 设置previewlayer的图层大小
                previewLayer.frame = backView.layer.bounds
                
                // 设置有效扫描区域
                let scanAreaX = scanAreaView.frame.origin.x
                let scanAreaY = scanAreaView.frame.origin.y
                let scanAreaWidth = scanAreaView.frame.size.width
                let scanAreaHeight = scanAreaView.frame.size.height
                NSNotificationCenter.defaultCenter().addObserverForName(AVCaptureInputPortFormatDescriptionDidChangeNotification, object: nil, queue: NSOperationQueue.currentQueue(), usingBlock: { (note) in
                    output.rectOfInterest = previewLayer.metadataOutputRectOfInterestForRect(CGRect(x: scanAreaX, y: scanAreaY, width: scanAreaWidth, height: scanAreaHeight))
                })

                // 将图层添加到视图图层
                backView.layer.insertSublayer(previewLayer, atIndex: 0)
                qrVideoPreviewLayer = previewLayer
                qrSession = session
            } catch {
                print(error)
            }
            
        }
    }
    
    func updateUI() {
        backView.backgroundColor = UIColor.blackColor()
        scanAreaView.backgroundColor = UIColor.clearColor()
        
        let alphaVlaue: CGFloat = 0.64
        let tempColor = UIColor.blackColor()
        topBackView.backgroundColor = tempColor
        topBackView.alpha = alphaVlaue
        
        leftBackView.backgroundColor = tempColor
        leftBackView.alpha = alphaVlaue
        
        rightBackView.backgroundColor = tempColor
        rightBackView.alpha = alphaVlaue
        
        bottomBackView.backgroundColor = tempColor
        bottomBackView.alpha = alphaVlaue
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startMKQRCodeReading() {
        if lineTimer == nil {
            lineTimer = NSTimer.scheduledTimerWithTimeInterval(1.0/20, target: self, selector: #selector(MKScanCouponViewController.animateLine), userInfo: nil, repeats: true)
        }
    
        if qrSession != nil {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                self.qrSession?.startRunning()
            })
        }
    }

    func stopMKQRCodeReading() {
        if (lineTimer?.valid == true) {
            lineTimer?.invalidate()
            qrSession?.stopRunning()
        }
    }
    // MARK: 上下滚动交互线
    func animateLine() {
        var frame: CGRect = line.frame
        let kMinY: CGFloat = scanAreaView.bounds.origin.y
        if flag {
            frame.origin.y = kMinY
            flag = false
            UIView.animateWithDuration(1.0/20, animations: { () -> Void in
                frame.origin.y += 5
                self.line.frame = frame
            })
        } else {
            if line.frame.origin.y > kMinY {
                if line.frame.origin.y > (kMinY + scanAreaView.frame.size.height - 12) {
                    frame.origin.y = kMinY
                    self.line.frame = frame
                    flag = true
                }
                else {
                    UIView.animateWithDuration(1.0/20, animations: { () -> Void in
                        frame.origin.y += 5
                        self.line.frame = frame
                    })
                }
            } else {
                flag = !flag
            }
        }
    }
    
    // MARK: AVCaptureMetadataOutput delegate
    // 扫到码后，会通过这个方法告知扫码结果
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        // 扫码成功后，停止扫码会话层的活动
        stopMKQRCodeReading()
        
        var stringValue: String?
        if metadataObjects.count > 0 {
            let metaDataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            stringValue = metaDataObject.stringValue
        }
        print(stringValue)
        
        showActivitorView(true)
    }
    
    // MARK: 显示或隐藏 activitor
    func showActivitorView(isShow: Bool) {
        if isShow {
            scanIndicator.startAnimating()
            scanIndicatorLabel.hidden = false
        } else {
            scanIndicator.stopAnimating()
            scanIndicatorLabel.hidden = true
        }
    }
}
