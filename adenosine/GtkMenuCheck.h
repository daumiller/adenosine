//==================================================================================================================================
// GtkMenuCheck.h
//==================================================================================================================================
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkMenuItem.h>

//==================================================================================================================================
@class GtkMenuCheck;
@protocol GtkMenuCheckDelegate <OFObject>
@optional
-(void)gtkMenuCheck:(GtkMenuCheck *)menuCheck toggled:(BOOL)isChecked;
@end

//==================================================================================================================================
@interface GtkMenuCheck : GtkMenuItem

//----------------------------------------------------------------------------------------------------------------------------------
+ menuCheck;
+ menuCheckWithText:(OFString *)text;
+ menuCheckWithAccel:(OFString *)text;
+ menuCheckWithText:(OFString *)text andDelegate:(id)delegate;
+ menuCheckWithAccel:(OFString *)text andDelegate:(id)delegate;
- initMenuCheck;
- initWithText:(OFString *)text;
- initWithAccel:(OFString *)text;

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) BOOL isChecked;
@property (assign) BOOL isInconsistent;
@property (assign) BOOL drawAsRadio;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onToggled;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
