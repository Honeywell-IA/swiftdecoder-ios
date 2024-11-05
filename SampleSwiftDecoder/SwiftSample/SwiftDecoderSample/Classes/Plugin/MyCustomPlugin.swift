/* HONEYWELL CONFIDENTIAL AND PROPRIETARY!
 *
 * SwiftDecoder Mobile Decoding Software
 * 2015 Hand Held Products, Inc. d/b/a
 * Honeywell Scanning and Mobility
 * Patent(s): https://www.honeywellaidc.com/Pages/patents.aspx
 */

import UIKit
import SwiftDecoder

// all custom SwiftMobile plug-ins must extend the SwiftPlugin class
class MyCustomPlugin: SwiftPlugin
{
    
    var barcodeData: String = "Hello SwiftMobile!"

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {
        // Drawing code
        // perfrom plug-in UI draiwing here
        // drawRect only gets called when the plug-in is first displayed or when [self updateDisplay] is called anywhere within the plug-in.
        // if your plug-in requires frequent UI refreshing you must do so manually by calling [self updateDisplay]
        let _rect = CGRect(x: 20, y: 30, width: 400, height: 100)

        let textFontAttributes: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor: UIColor.red,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15)]
        
        barcodeData.draw(in: _rect, withAttributes: textFontAttributes)
    }
    
    override func onStart()
    {
        
    }
    
    override func onStop()
    {
        
    }
    
    override func onDestroy()
    {
        
    }
    
    override func onDecode(_ results: HSMDecodeResultArray!)
    {
        // get the first result
        let firstResult: HSMDecodeResult = results.result(at: 0)
        
        // notify all plug-in listeners of result
        self.notifyListeners(result: firstResult.barcodeData)
        
        barcodeData = firstResult.barcodeData
        self.updateDisplay()
    }
    
    override func onDecodeFailed()
    {
        // this is called each time a camera frame cannot be decoded
    }
    
    override func onImage(_ image: UnsafeMutablePointer<UInt8>!, width: Int32, height: Int32) {
        // this is called each time a camera frame is sent to the decoder
    }
    
    func notifyListeners(result : String)  {
        /*  This signals the system that our plug-in has completed its processing and that the system should return focus to the caller.
         This is only needed if scanBarcode() was called on an instance of HSMDecoder to launch this plug-in (as opposed to within an HSMDecodeComponent)
         */
        //  [self finish];
        
        // notify all plug-in listeners we have a result
        for listener in self.getOnResultListeners() {
            (listener as! MyCustomPluginResultListener).onCustomPluginResult(decodeData: result)
        }
    }

    /* uncomment to handle touch events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
     */
}

