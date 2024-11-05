/* HONEYWELL CONFIDENTIAL AND PROPRIETARY!
 *
 * SwiftDecoder Mobile Decoding Software
 * 2015 Hand Held Products, Inc. d/b/a
 * Honeywell Scanning and Mobility
 * Patent(s): https://www.honeywellaidc.com/Pages/patents.aspx
 */
#import <UIKit/UIKit.h>
#import <SwiftDecoder/HSMDecodeComponent.h>
#import "MyCustomPluginResultListener.h"
#import "MyCustomPlugin.h"
#import <SwiftDecoder/HSMDecoder.h>

//Must implement the MyCustomPluginResultListener protocol to handle custom plugin results
@interface MyDecodeComponent : UIViewController <MyCustomPluginResultListener>
{
    @private
    MyCustomPlugin *customPlugin;
    HSMDecoder *decoder;
}

@property (strong, nonatomic) IBOutlet HSMDecodeComponent *decodeComponent;
- (IBAction)onBackPressed:(id)sender;


@end
