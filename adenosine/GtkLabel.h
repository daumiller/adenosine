//==================================================================================================================================
// GtkLabel.h
//==================================================================================================================================
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkMisc.h>

//==================================================================================================================================
@class GtkLabel;
@protocol GtkLabelDelegate <OFObject>
@optional
-(BOOL)gtkLabel:(GtkLabel *)label linkActivated:(OFString *)link;
-(void)gtkLabel:(GtkLabel *)label populateContextMenu:(void *)nativeMenu;
@end

//==================================================================================================================================
@interface GtkLabel : GtkMisc

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) OFString    *text;
@property (assign) int          maxCharLength;
@property (assign) BOOL         useMarkup;
@property (assign) BOOL         useEllipsis;
@property (assign) BOOL         useWrapping;
@property (assign) BOOL         isSelectable;
@property (assign) BOOL         markVisitedLinks;
@property (assign) float        angle;
@property (assign) GtkTextAlign textAlign;
@property (assign) GtkWidget    *accelWidget;

//----------------------------------------------------------------------------------------------------------------------------------
+ label;
+ labelWithText:(OFString *)text;
+ labelWithMarkup:(OFString *)markup;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initLabel;
- initWithText:(OFString *)text;
- initWithMarkup:(OFString *)markup;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)setMarkup:(OFString *)markup;
-(void)setMarkupWithAccel:(OFString *)markup;

//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)onLinkActivated:(char *)uri;
-(void)onPopulateContextMenu:(void *)nativeMenu;

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
