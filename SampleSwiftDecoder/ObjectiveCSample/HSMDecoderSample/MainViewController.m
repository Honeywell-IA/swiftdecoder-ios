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

#import "MainViewController.h"
#import <SwiftDecoder/Symbology.h>
#import <SwiftDecoder/ActivationManager.h>
#import <SwiftDecoder/ActivationResult.h>

#define kEntitlementId @"insert-entitlement-id-here"

@interface MainViewController ()<ActivationResponseListener>
{
    int launchType;//-1,0,1
}

@end

@implementation MainViewController
@synthesize labelData;
@synthesize labelSymb;
@synthesize labelLength;
@synthesize labelTime;
@synthesize ivBarcodeImg;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // intially set this launch type to -1

    launchType = -1;
    //init custom view controller containg the HSMDecodeComponent
    customViewController = [[MyDecodeComponent alloc] initWithNibName:@"MyDecodeComponent" bundle:nil];

    //activate the API with your license key (this is also available as an asynchronous method)
    //NOTE: any HSMDecoder settings made before activation will be defaulted once actvation has occurred!
    [self entitlementIDActivate:kEntitlementId];
    
}
-(void)loadView {
    [super loadView];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - DecodeResult Listener Delegates

- (void) onHSMResult:(HSMDecodeResultArray*)barcodeData
{
    //update display on main thread
    [self performSelectorOnMainThread:@selector(updateDisplay:) withObject:barcodeData waitUntilDone:YES];
}

#pragma mark - Activation Response Delegates

- (void) onActivationComplete:(ActivationResult)result
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *msg = @"";
        
        if (result == SUCCESS) {
            msg = @"Device Activated!";
        } else {
            msg = [NSString stringWithFormat:@"Activation Failed. Error = %d", result];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // open a alert with an OK and cancel button
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:msg preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                 {
                //get decoder singelton and configure as needed
                hsmDecoder = [HSMDecoder getInstance];
                [hsmDecoder enableSymbology:UPCA];
                [hsmDecoder enableSymbology:CODE128];
                [hsmDecoder enableSymbology:CODE39];
                [hsmDecoder enableSymbology:CODE93];
                [hsmDecoder enableSymbology:QR];
                [hsmDecoder enableSymbology:EAN13];
                
                [hsmDecoder setAimerColor:[UIColor redColor]];
                [hsmDecoder setOverlayTextColor:[UIColor whiteColor]];
                [hsmDecoder setOverlayText:@"Place barcode inside viewfinder"];
                if (result == SUCCESS) {
                    if (launchType == 0) {
                        [self onScanButtonPressed:nil];
                    } else if(launchType == 1) {
                        [self onButtonComponentPressed:nil];
                    }
                }
                
            }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        });
    });
}

- (void)onDeactivationComplete:(ActivationResult)result {
    
}


#pragma mark - Action methods

- (IBAction)onScanButtonPressed:(id)sender
{
    launchType = 0;
    if ([ActivationManager isActivated]) {
        //enable default decoding functionality
        [hsmDecoder addOnResultListener:self];
        
        //launch the default barcode scanning view controller
        [hsmDecoder scanBarcode:self];
    } else {
        [self entitlementIDActivate:kEntitlementId];
    }
}

- (IBAction)onButtonComponentPressed:(id)sender
{
    launchType = 1;
    if ([ActivationManager isActivated]) {
        //disable default decoding functionality, as the view controller we are about to show uses a custom Swift Plug-in instead of the default decoder
        [hsmDecoder removeOnResultListener:self];
        
        //launch a custom ViewController with an embedded HSMDecodeComponent
        [self presentViewController:customViewController animated:NO completion:nil];
    } else {
        [self entitlementIDActivate:kEntitlementId];
    }
    
}

#pragma mark - Private Methods

- (void)updateDisplay:(HSMDecodeResultArray*)barcodeData
{
    //get the first result in the list (there may be many)
    HSMDecodeResult* firstResult = [barcodeData resultAtIndex:0];
    
    //Update the screen with the last barcode data
    labelData.text = firstResult.barcodeData;
    labelSymb.text = [NSString stringWithFormat:@"Symbology: %@", firstResult.symbology];
    labelLength.text = [NSString stringWithFormat:@"Length: %d", firstResult.length];
    labelTime.text = [NSString stringWithFormat:@"Decode Time: %dms", firstResult.decodeTime];
    
    //display an image of the barcode
    [ivBarcodeImg setImage:[hsmDecoder getLastBarcodeImage:firstResult.bounds]];
}


-(void)entitlementIDActivate:(NSString*) entitlementId
{
    [ActivationManager entitlementIdActivateAsync:entitlementId withListener:self];
}

-(void)dealloc {
    [super dealloc];
    self.labelData = nil;
    self.labelSymb = nil;
    self.labelLength = nil;
    self.labelTime = nil;
    self.ivBarcodeImg = nil;

}
//

@end

