/* HONEYWELL CONFIDENTIAL AND PROPRIETARY!
 *
 * SwiftDecoder Mobile Decoding Software
 * 2015 Hand Held Products, Inc. d/b/a
 * Honeywell Scanning and Mobility
 * Patent(s): https://www.honeywellaidc.com/Pages/patents.aspx
 *
 *
 *
 * The purpose of this sample app is to demonstrate the various scanning methods that the SDK has to offer.  This sample will show you how to activate the API, configure its use, how to allow
 * the API to take controll of an entire scanning operation, how to embed an HSMDecodeComponent into your own View Controller, size and control it how you see fit and how to create your own
 * custom Swift Plug-in to completely control the look and function of the scanning experience.  Please see the integration guide for more detail.
 */

import UIKit
import SwiftDecoder

//Need to implement the OnDecodeResultListener protocol to handle default decoder results
class ViewController: UIViewController, ActivationResponseListener,DecodeResultListener
{
    // activation key
    let kentitlementId:String = "insert-entitlement-id-here"
    
    var hsmDecoder: HSMDecoder!;
    var launchType:Int = -1 // launch type is used to deicde whether to launch camera preview in full screen or decode component
    
    @IBOutlet weak var barcodeImageView: UIImageView!
    @IBOutlet weak var barcodeDataLabel: UILabel!
    @IBOutlet weak var symbologyLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var decodeTimeLabel: UILabel!
    @IBOutlet weak var scanViewControllerButton: UIButton!
    @IBOutlet weak var scanComponentButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // activate decoder
        self.entitlementIDActivate()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Decode result listener
    func onHSMResult(_ barcodeData: HSMDecodeResultArray!)
    {
        DispatchQueue.main.async {
            // update display on main thread
            self.updateDisplay(barcodeData)
        }
    }
    
    // MARK: - Activation handler
    func onActivationComplete(_ result: ActivationResult)
    {
        DispatchQueue.main.async {
            
            var message : String
            if result == SUCCESS
            {
                message = "Device Activated!"
            } else
            {
                message = "Activation Failed. Error = \(result.rawValue)"
            }
            
            let alert: UIAlertController = UIAlertController.init(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction.init(title: "OK", style: UIAlertActionStyle.default, handler: self.okActionHandler);
            alert.addAction(okAction)
            
            self.present(alert, animated: true,completion: nil)
        }
    }
    
    // MARK: - IBAction methods
    @IBAction func scanViewControllerButtonClicked(_ sender: Any)
    {
        launchType = 0
        
        if ActivationManager.isActivated()
        {
            // enable default decoding functionality
            hsmDecoder?.add(on: self)
            // launch the default barcode scanning view controller
            hsmDecoder?.scanBarcode(self)
        } else
        {
            self.entitlementIDActivate()
        }
    }
    
    @IBAction func scanComponentButtonClicked(_ sender: Any)
    {
        launchType = 1
        
        if ActivationManager.isActivated()
        {
            // disable default decoding functionality, as the view controller we are about to show uses a custom Swift Plug-in instead of the default decoder
            hsmDecoder?.remove(on: self)
            
            // init custom view controller containg the HSMDecodeComponent
            let customViewController: MyDecodeComponent = MyDecodeComponent(nibName: "MyDecodeComponent", bundle: nil)
            customViewController.modalPresentationStyle = .fullScreen;
            // launch a custom ViewController with an embedded HSMDecodeComponent
            self.present(customViewController, animated: true, completion: {})
        } else
        {
            self.entitlementIDActivate()
        }
    }
    
    // MARK: - Private methods
    
    func entitlementIDActivate() {
        if ActivationManager.isActivated() == false
        {
            // activate the API with your licnese key
            ActivationManager.entitlementIdActivateAsync(kentitlementId, with: self)
        }
    }
    func onDeactivationComplete(_ result: ActivationResult) {

    }
    
    private func updateDisplay(_ barcodeData: HSMDecodeResultArray!)
    {
        // get the first result in the list (there may be many)
        let firstResult: HSMDecodeResult = (barcodeData?.result(at: 0))!
        // update the screen with the last barcode data
        self.barcodeDataLabel.text = firstResult.barcodeData;
        self.symbologyLabel.text = "Symbology: \(firstResult.symbology.description)";
        self.lengthLabel.text = "Length: \(firstResult.length)";
        self.decodeTimeLabel.text = "Decode Time: \(firstResult.decodeTime)";
    
        // display an image of the barcode
        self.barcodeImageView.image = self.hsmDecoder?.getLastBarcodeImage(firstResult.bounds)
    }
    
    private func okActionHandler(action: UIAlertAction)
    {
        hsmDecoder = HSMDecoder.getInstance()
        hsmDecoder?.enableSymbology(Int32(UPCA.rawValue))
        hsmDecoder?.enableSymbology(Int32(CODE128.rawValue))
        hsmDecoder?.enableSymbology(Int32(CODE39.rawValue))
        hsmDecoder?.enableSymbology(Int32(CODE93.rawValue))
        hsmDecoder?.enableSymbology(Int32(QR.rawValue))
        hsmDecoder?.enableSymbology(Int32(EAN13.rawValue))
        hsmDecoder?.setAimerColor(UIColor.red)
        hsmDecoder?.setOverlayText("Place barcode inside viewfinder")
        hsmDecoder?.setOverlayTextColor(UIColor.white)
        
        // check if decoder is activated
        if ActivationManager.isActivated()
        {
            if launchType == 0
            {
                self.scanViewControllerButtonClicked(scanViewControllerButton)
            }
            else if launchType == 1
            {
                self.scanComponentButtonClicked(scanComponentButton)
            }
        }
    }
    
}

