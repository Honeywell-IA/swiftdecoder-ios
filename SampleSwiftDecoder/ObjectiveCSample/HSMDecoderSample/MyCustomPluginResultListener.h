/* HONEYWELL CONFIDENTIAL AND PROPRIETARY!
 *
 * SwiftDecoder Mobile Decoding Software
 * 2015 Hand Held Products, Inc. d/b/a
 * Honeywell Scanning and Mobility
 * Patent(s): https://www.honeywellaidc.com/Pages/patents.aspx
 */

#import <Foundation/Foundation.h>
#import <SwiftDecoder/PluginResultListener.h>
/*
 * SwiftPlugins utalize the observer design pattern to notify their observers (listeners) of any events
 * This is done by defining a protocol that an observer/listener must implement in order to recieve event notifications
 * All SwiftPlugin protocols must implement the OnPluginResultListener base protocol
 */
@protocol MyCustomPluginResultListener <PluginResultListener>
- (void) onMyCustomPluginResult:(NSString*)decodeData;
@end
