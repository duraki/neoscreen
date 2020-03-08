//
//  neoscreenView.h
//  neoscreen
//
//  Created by Halis Duraki on 08/03/2020.
//  Copyright © 2020 Halis Duraki. All rights reserved.
//

#import <ScreenSaver/ScreenSaver.h>

@interface neoscreenView : ScreenSaverView
{
    __weak IBOutlet NSPopUpButton *screenDisplayOption;
    IBOutlet NSPanel *configSheet;
}
@end
