/* HONEYWELL CONFIDENTIAL AND PROPRIETARY!
 *
 * SwiftDecoder Mobile Decoding Software
 * 2015 Hand Held Products, Inc. d/b/a
 * Honeywell Scanning and Mobility
 * Patent(s): https://www.honeywellaidc.com/Pages/patents.aspx
 */

#import <UIKit/UIKit.h>
#import <SwiftDecoder/DecodeResultListener.h>
#import <SwiftDecoder/HSMDecoder.h>
#import "MyDecodeComponent.h"

//Need to implement the OnDecodeResultListener protocol to handle default decoder results
@interface MainViewController : UIViewController <DecodeResultListener>
{
    @private
    HSMDecoder* hsmDecoder;
    MyDecodeComponent *customViewController;
}

- (IBAction)onScanButtonPressed:(id)sender;
- (IBAction)onButtonComponentPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *labelData;
@property (strong, nonatomic) IBOutlet UILabel *labelSymb;
@property (strong, nonatomic) IBOutlet UILabel *labelLength;
@property (strong, nonatomic) IBOutlet UILabel *labelTime;
@property (strong, nonatomic) IBOutlet UIImageView *ivBarcodeImg;


@end
