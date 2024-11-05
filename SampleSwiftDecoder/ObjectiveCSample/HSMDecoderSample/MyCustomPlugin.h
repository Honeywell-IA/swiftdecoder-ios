/* HONEYWELL CONFIDENTIAL AND PROPRIETARY!
 *
 * SwiftDecoder Mobile Decoding Software
 * 2015 Hand Held Products, Inc. d/b/a
 * Honeywell Scanning and Mobility
 * Patent(s): https://www.honeywellaidc.com/Pages/patents.aspx
 */

#import <SwiftDecoder/SwiftPlugin.h>

//all custom SwiftMobile plug-ins must extend the SwiftPlugin class
@interface MyCustomPlugin : SwiftPlugin
@property (nonatomic, retain) NSString *barcodeData;
@end
