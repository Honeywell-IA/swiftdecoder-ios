//
//  ViewController.swift
//  GenericOCRSampleApp
//
//  Created by H454944 on 26/06/24.
//

import UIKit
import SwiftDecoder
import SwiftOCR
class ViewController: UIViewController {

    @IBOutlet weak var enitlementIDTextField: UITextField!
    @IBOutlet weak var sdkVersionLabel: UILabel!
    @IBOutlet weak var swiftOCRSDKVersionLabel: UILabel!
    @IBOutlet weak var decoderLabelVersion: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        HSMDecoder.getInstance()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.red
    }

    @IBAction func didClickOnActivate(_ sender: UIButton) {
        if(ActivationManager.isActivated() == false) {
            ActivationManager.entitlementIdActivateAsync(enitlementIDTextField.text, with: self)
        } else {
            displayAlert(title: "Warning", message: "Device already Activated", style: UIAlertController.Style.alert)
        }
    }
    
    @IBAction func didClickOnScanButton(_ sender: UIButton) {
        if(ActivationManager.isActivated() == true) {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let scanViewController = storyboard.instantiateViewController(withIdentifier: "ScanViewController") as? ScanViewController {
                navigationController?.pushViewController(scanViewController, animated: true)
            }
        } else {
            displayAlert(title: "Warning", message: "Device not Activated", style: UIAlertController.Style.alert)

        }
    }
    
    func displayAlert(title:String,message:String,style:UIAlertController.Style) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alertView.addAction(okAction)
        self.present(alertView, animated: true)
    }
}

extension ViewController: ActivationResponseListener {
    func onActivationComplete(_ result: ActivationResult) {
        DispatchQueue.main.async {
            HSMDecoder.getInstance().enableDecoding(false)
            HSMDecoder.getInstance().enableSymbology(Int32(CODE128.rawValue))
            HSMDecoder.getInstance().enableSymbology(Int32(EAN8.rawValue))
            HSMDecoder.getInstance().enableSymbology(Int32(EAN13.rawValue))
            HSMDecoder.getInstance().enableSymbology(Int32(QR.rawValue))
            HSMDecoder.getInstance().enableSymbology(Int32(UPCA.rawValue))
            HSMDecoder.getInstance().enableSymbology(Int32(CODE39.rawValue))
            HSMDecoder.getInstance().enableSymbology(Int32(CODE93.rawValue))
            HSMDecoder.getInstance().enableSymbology(Int32(UPCA.rawValue))
            self.sdkVersionLabel.text = HSMDecoder.getInstance().getAPIVersion()
            self.swiftOCRSDKVersionLabel.text = SwiftOCRDecoder.getInstance().getAPIVersion()
            self.decoderLabelVersion.text = HSMDecoder.getInstance().getFullDecoderVersion()
            self.view.backgroundColor = UIColor.green
//            let alertView = UIAlertController(title: "Alert", message: "Device Activated", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:nil)
//            alertView.addAction(okAction)
//            self.present(alertView, animated: true)

            self.displayAlert(title: "Alert", message: "Device Activated", style: UIAlertController.Style.alert)
        }
    }
    
    func onDeactivationComplete(_ result: ActivationResult) {
        
    }
    
    
}

