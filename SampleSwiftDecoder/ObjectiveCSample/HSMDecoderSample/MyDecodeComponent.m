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

#import "MyDecodeComponent.h"
#import <SwiftDecoder/HSMDecoder.h>
#import <SwiftDecoder/PluginHelper.h>


@implementation MyDecodeComponent
@synthesize decodeComponent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //get the singleton instance of the decoder
        decoder = [HSMDecoder getInstance];
        
        //create a custom SwiftPlugin and add this view controller as an event listener
        customPlugin = [[MyCustomPlugin alloc]init];
        [customPlugin addOnResultListener:self];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //register the custom plug-in with the system
    [decoder registerPlugin:customPlugin];
    
    //enable the embedded decode component
    [decodeComponent enable:true];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //unregister the custom plug-in with the system
    [decoder unRegisterPlugin:customPlugin];
    
    //disable the embedded decode component
    [decodeComponent enable:false];
    [customPlugin dispose];
}

- (void) onMyCustomPluginResult:(NSString*)decodeData
{
    //do something with result
    [PluginHelper beep];
//    [decoder enableDecoding:false];
}

- (IBAction)onBackPressed:(id)sender
{
    //dismiss this view controller
    [self performSelectorOnMainThread:@selector(dismissSelf) withObject:nil waitUntilDone:NO];
}

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)dealloc
{
    //dispose of your custom plug-in
    [customPlugin dispose];
    
}
- (void)viewDidUnload
{
    [self setDecodeComponent:nil];
    [super viewDidUnload];
}
@end
