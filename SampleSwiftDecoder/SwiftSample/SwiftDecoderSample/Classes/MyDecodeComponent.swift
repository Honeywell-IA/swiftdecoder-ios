/* HONEYWELL CONFIDENTIAL AND PROPRIETARY!
 *
 * SwiftDecoder Mobile Decoding Software
 * 2015 Hand Held Products, Inc. d/b/a
 * Honeywell Scanning and Mobility
 * Patent(s): https://www.honeywellaidc.com/Pages/patents.aspx
 *
 *
 * The purpose of MyDecodeComponent is to show how you can embed an HSMDecodeComponent into your own view controller and size it how you see fit.
 * In addtion to this, it also shows how you can instantiate and register your own Swift Plug-in to completly control the look and function of scan operation.
 * It should be noted that registering a plug-in with HSMDecoder will enable your plug-in within both an instance of HSMDecodeComponent, as well as within the default scanning view controller
 * when calling scanBarcode on an instance of HSMDecoder.  See the integration guide for more detail.
 */

import UIKit
import SwiftDecoder

class MyDecodeComponent: UIViewController,MyCustomPluginResultListener
{
    
    @IBOutlet weak var decodeComponent: HSMDecodeComponent!
    
    weak var decoder: HSMDecoder! = HSMDecoder.getInstance()
    var customPlugin: MyCustomPlugin! = MyCustomPlugin()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        customPlugin?.add(on: self)
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        decoder?.register(customPlugin)
        decodeComponent?.enable(true)
    }
    
    override func viewDidDisappear(_ animated: Bool)
    {
        super.viewDidDisappear(animated)
        decoder?.unRegister(customPlugin)
        decodeComponent?.enable(false)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBAction methods
    @IBAction func backButtonPressed(_ sender: Any)
    {
        self.dismiss(animated: true)
    }
    
    // Mark: - MyCustomPluginResultListener delegate methods
    func onCustomPluginResult(decodeData: String)
    {
        // do something with result
        PluginHelper.beep()
    }

}
