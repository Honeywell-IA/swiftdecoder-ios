/* HONEYWELL CONFIDENTIAL AND PROPRIETARY!
 *
 * SwiftDecoder Mobile Decoding Software
 * 2015 Hand Held Products, Inc. d/b/a
 * Honeywell Scanning and Mobility
 * Patent(s): https://www.honeywellaidc.com/Pages/patents.aspx
 */

#import "MyCustomPlugin.h"
#import "MyCustomPluginResultListener.h"

@implementation MyCustomPlugin
@synthesize barcodeData = _barcodeData;

- (id)init
{
    self = [super init];
    if (self)
    {
        //initialize any plug-in resources here
        self.barcodeData = [[NSString alloc] initWithString:@"Hello SwiftMobile!"];
    }
    return self;
}

- (void)onStart
{
    //this is called at the start of a barcode scan attempt
}

- (void)onStop
{
    //this is called at the end of a barcode scan attempt
}

- (void)onDestroy
{
    //release any plug-in resources here
}

- (void)onDecode:(HSMDecodeResultArray*)results
{
    //get the first result
    HSMDecodeResult* firstResult = [results resultAtIndex:0];

    //notify all plug-in listeners of result
    [self notifyListeners:firstResult.barcodeData];
    
    self.barcodeData = firstResult.barcodeData;
    [self updateDisplay];
}

- (void)onDecodeFailed
{
    //this is called each time a camera frame cannot be decoded
}

- (void)onImage:(unsigned char*)image Width:(int)width Height:(int)height
{
    //this is called each time a camera frame is sent to the decoder
}

- (void)drawRect:(CGRect)rect
{
    //perfrom plug-in UI draiwing here
    //drawRect only gets called when the plug-in is first displayed or when [self updateDisplay] is called anywhere within the plug-in.
    //if your plug-in requires frequent UI refreshing you must do so manually by calling [self updateDisplay]
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    
    [[UIColor redColor] setFill];
    CGRect textRect = CGRectMake(20, 30, 400, 100);
    NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    textStyle.alignment = NSTextAlignmentLeft;
    NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:20], NSForegroundColorAttributeName: UIColor.redColor, NSParagraphStyleAttributeName: textStyle};

    [self.barcodeData drawInRect: textRect withAttributes: textFontAttributes];

    CGContextStrokePath(context);
}

/* uncomment to handle touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
 
}
*/

- (void) notifyListeners:(NSString*)result
{
    /*  This signals the system that our plug-in has completed its processing and that the system should return focus to the caller.
        This is only needed if scanBarcode() was called on an instance of HSMDecoder to launch this plug-in (as opposed to within an HSMDecodeComponent)
     */
  //  [self finish];
    
    //notify all plug-in listeners we have a result
    for(id<MyCustomPluginResultListener> listener in [self getOnResultListeners])
        [listener onMyCustomPluginResult:result];
}


@end
