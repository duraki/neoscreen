//
//  neoscreenView.m
//  neoscreen
//
//  Created by Halis Duraki on 08/03/2020.
//  Copyright © 2020 Halis Duraki. All rights reserved.
//

#import "neoscreenView.h"
#import "WebKit/WebKit.h"

@implementation neoscreenView

static NSString * const neoScreenModule = @"com.durakiconsulting.neoscreen";

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    if (!(self = [super initWithFrame:frame isPreview:isPreview])) return nil;
    
    // Preference Defaults
    ScreenSaverDefaults *defaults;
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:neoScreenModule];
    
    [defaults
     registerDefaults:
     [NSDictionary dictionaryWithObjectsAndKeys:@"0", @"screenDisplayOptions", nil]];

    
    // Webview
    NSURL *indexHtmlDocumentUrl = [NSURL URLWithString:[[NSURL fileURLWithPath:[[NSBundle bundleForClass:self.class].resourcePath stringByAppendingString:@"/Webview/index.html"] isDirectory:NO] description]];
    
    WebView *webView = [[WebView alloc]
                        initWithFrame:NSMakeRect(0, 0, frame.size.width, frame.size.height)];
    
    webView.drawsBackground = NO;
    [webView.mainFrame loadRequest:[NSURLRequest
                                    requestWithURL:indexHtmlDocumentUrl
                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                    timeoutInterval:30.0]];
    NSArray *screens = [NSScreen screens];
    NSScreen *primaryScreen = [screens objectAtIndex:0];
    
    switch ([defaults integerForKey:@"screenDisplayOptions"]) {
        case 0:
            if ((primaryScreen.frame.origin.x == frame.origin.x) || isPreview) {
                [self addSubview:webView];
            }
            break;
        case 1:
            if (([NSScreen mainScreen].frame.origin.x == frame.origin.x) || isPreview) {
                [self addSubview:webView];
            }
            break;
        case 2:
            [self addSubview:webView];
            break;
        default:
            [self addSubview:webView];
            break;
    }
    
    return self;
}

#pragma mark - ScreenSaverView
- (void)animateOneFrame { [self stopAnimation]; }

#pragma mark - Config
- (BOOL)hasConfigureSheet { return YES; }

- (NSWindow *)configureSheet {
    ScreenSaverDefaults *defaults;
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:neoScreenModule];
    
    if (!configSheet) {
        if (![NSBundle loadNibNamed:@"ConfigureSheet" owner:self]) {
            NSLog(@"Failed to load configure sheet.");
        }
    }
    
    [screenDisplayOption selectItemAtIndex:[defaults integerForKey:@"screenDisplayOption"]];

    return configSheet;
}
- (IBAction)cancelClick:(id)sender {
    [[NSApplication sharedApplication] endSheet:configSheet];
}
- (IBAction)okClick:(id)sender {
    ScreenSaverDefaults *defaults;
    defaults = [ScreenSaverDefaults defaultsForModuleWithName:neoScreenModule];
    
    // Update our defaults
    [defaults setInteger:[screenDisplayOption indexOfSelectedItem]
               forKey:@"screenDisplayOption"];
    
    // Save the settings to disk
    [defaults synchronize];
    
    // Close the sheet
    [[NSApplication sharedApplication] endSheet:configSheet];
}

#pragma mark - WebFrameLoadDelegate
- (void)webView:(WebView *)sender didFailLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {
    NSLog(@"%@ error=%@", NSStringFromSelector(_cmd), error);
}

#pragma mark Focus Overrides
- (NSView *)hitTest:(NSPoint)aPoint {return self;}
//- (void)keyDown:(NSEvent *)theEvent {return;}
//- (void)keyUp:(NSEvent *)theEvent {return;}
- (void)mouseDown:(NSEvent *)theEvent {return;}
- (void)mouseUp:(NSEvent *)theEvent {return;}
- (void)mouseDragged:(NSEvent *)theEvent {return;}
- (void)mouseEntered:(NSEvent *)theEvent {return;}
- (void)mouseExited:(NSEvent *)theEvent {return;}
- (BOOL)acceptsFirstResponder {return YES;}
- (BOOL)resignFirstResponder {return NO;}

@end
