//
//  ScanViewController.swift
//  GenericOCRSampleApp
//
//  Created by H454944 on 26/06/24.
//

import UIKit
import SwiftDecoder
import SwiftOCR
class ScanViewController: UIViewController {

    @IBOutlet weak var decodeComponent: HSMDecodeComponent!
    @IBOutlet weak var fullscreenButton: UIButton!
    @IBOutlet weak var orientationButton: UIButton!
    
    @IBOutlet weak var zoomButton: UIButton!
    private lazy var targetedSingleROI = TargetedSingleROIConfig()

    override func viewDidLoad() {
        super.viewDidLoad()
        orientationButton.isHidden = true
        fullscreenButton.isHidden = true
        self.view.backgroundColor = UIColor.green
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HSMDecoder.getInstance().enableDecoding(true)
        HSMDecoder.getInstance().add(on: self)
        decodeComponent.enable(true)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        HSMDecoder.getInstance().enableDecoding(false)
        HSMDecoder.getInstance().remove(on: self)
        SwiftOCRDecoder.getInstance().enableSwiftOCRFeature(false)
        SwiftOCRDecoder.getInstance().remove(on: self)
        decodeComponent.enable(false)


    }
    
    @IBAction func didClickOnZoomButton(_ sender: UIButton) {
       let zoomRatio = HSMDecoder.getInstance().getZoomRatio()
        var zoom = 1.0;
        if zoomRatio == 1.0 {
            zoom = 2.0
            zoomButton.setTitle("2x", for: .normal)
        } else if zoomRatio == 2.0 {
            zoom = 3.0
            zoomButton.setTitle("3x", for: .normal)
        } else {
            zoom = 1.0;
            zoomButton.setTitle("1x", for: .normal)

        }
        HSMDecoder.getInstance().setZoomRatio(zoom)
    }
    
    @IBAction func didClickOnOrientation(_ sender: UIButton) {
       let roiConfig = SwiftOCRDecoder.getInstance().getTargetedSingleROIConfig()
        if roiConfig?.orientation == TargetedSingleROIOrientation.TARGETED_SINGLE_ROI_ORIENTATION_VERTICAL {
            SwiftOCRDecoder.getInstance().switch(.TARGETED_SINGLE_ROI_ORIENTATION_HORIZONTAL)
            orientationButton.setTitle("ROI-V", for: .normal)
        } else {
            SwiftOCRDecoder.getInstance().switch(.TARGETED_SINGLE_ROI_ORIENTATION_VERTICAL)
            orientationButton.setTitle("ROI-H", for: .normal)

        }
    }
    
    @IBAction func didClickOnOCRSwitch(_ sender: UISwitch) {
        if sender.isOn {
            fullscreenButton.isHidden = false
            orientationButton.isHidden = false
            SwiftOCRDecoder.getInstance().setSwiftOCRDetectionMode(OPEN_OCR)
            SwiftOCRDecoder.getInstance().enableSwiftOCRFeature(true)
            SwiftOCRDecoder.getInstance().setSwiftOCRScanArea(TARGETED_SINGLE_ROI)
            targetedSingleROI.setROISizeWithWidth(0.8, withHeight: 0.4)
            SwiftOCRDecoder.getInstance().setTargetedSingleROIConfig(targetedSingleROI)
            SwiftOCRDecoder.getInstance().add(on: self)
            HSMDecoder.getInstance().remove(on: self)
            view.bringSubviewToFront(fullscreenButton)

        } else {
            fullscreenButton.isHidden = true
            orientationButton.isHidden = true

            SwiftOCRDecoder.getInstance().enableSwiftOCRFeature(false)
            SwiftOCRDecoder.getInstance().remove(on: self)
            HSMDecoder.getInstance().add(on: self)
        }
        
    }
    
    
    @IBAction func didClickOnFullScreenButton(_ sender: UIButton) {
        SwiftOCRDecoder.getInstance().enableSwiftOCRFeature(false)
        SwiftOCRDecoder.getInstance().remove(on: self)
        
        if SwiftOCRDecoder.getInstance().getSwiftOCRScanArea() == TARGETED_SINGLE_ROI {
            fullscreenButton.setTitle("Single ROI", for: .normal)
            SwiftOCRDecoder.getInstance().setSwiftOCRDetectionMode(OPEN_OCR)
            SwiftOCRDecoder.getInstance().enableSwiftOCRFeature(true)
            SwiftOCRDecoder.getInstance().setSwiftOCRScanArea(FULL_PREVIEW)
            SwiftOCRDecoder.getInstance().setTargetedSingleROIConfig(nil)
            SwiftOCRDecoder.getInstance().add(on: self)
        } else {
            fullscreenButton.setTitle("Full Screen", for: .normal)
            SwiftOCRDecoder.getInstance().setSwiftOCRDetectionMode(OPEN_OCR)
            SwiftOCRDecoder.getInstance().enableSwiftOCRFeature(true)
            SwiftOCRDecoder.getInstance().setSwiftOCRScanArea(TARGETED_SINGLE_ROI)
            targetedSingleROI.setROISizeWithWidth(0.8, withHeight: 0.4)
            SwiftOCRDecoder.getInstance().setTargetedSingleROIConfig(targetedSingleROI)
            SwiftOCRDecoder.getInstance().add(on: self)
        }

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func displayAlert(title:String,message:String,style:UIAlertController.Style) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alertView.addAction(okAction)
        self.present(alertView, animated: true)
    }


}

extension ScanViewController : DecodeResultListener {
    func onHSMResult(_ barcodeData: HSMDecodeResultArray!) {
        HSMDecoder.getInstance().enableDecoding(false)
        var barcodeString = ""
        DispatchQueue.main.async {
            for  i in 0..<barcodeData.count() {
                let barcode = barcodeData.result(at: UInt(i))
                if let barcodeStr = barcode?.barcodeData , let symbology = barcode?.symbology {
                    barcodeString = barcodeString + String("Barcode: \(barcodeStr)    ") + String("Symbology: \(symbology) \n")
                }
            }
            
            let alertView = UIAlertController(title: "Result", message: barcodeString, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                HSMDecoder.getInstance().enableDecoding(true)
            })
            alertView.addAction(okAction)
            self.present(alertView, animated: true)

//            self.displayAlert(title: "Result", message: barcodeString, style: UIAlertController.Style.alert)
        }
    }
    
    
}

extension ScanViewController : SwiftOCRResultListener {
    func onSwiftOCRResult(_ ocrData: [Any]!) {
        DispatchQueue.main.async { [self] in
            
            if let ocrData = ocrData as? [SwiftOCRResult] {
                if ocrData.count > 0 {
                    if let result = String(data: ocrData[0]
                        .ocrByteData, encoding: .utf8) {
                        self.displayAlert(title: "OCR Data", message: result, style: UIAlertController.Style.alert)
                    }
                }
            }
        }

    }
    
    func onSwiftOCRTemplateResult(_ ocrData: [Any]!) {
        
    }
    
}
