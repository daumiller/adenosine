//==================================================================================================================================
// GtkEntry.h
//==================================================================================================================================
#import <ObjFW/ObjFW.h>
#import <adenosine/GtkWidget.h>
@class GtkMenu;
@class GtkEntryBuffer;

//==================================================================================================================================
typedef enum
{
  GTKENTRY_ICON_PRIMARY,
  GTKENTRY_ICON_SECONDARY
} GtkEntryIcon;

//==================================================================================================================================
@class GtkEntry;
@protocol GtkEntryDelegate <OFObject>
@optional
-(void)gtkEntryTextChanged:(GtkEntry *)entry;
-(void)gtkEntry:(GtkEntry *)entry iconPressed :(GtkEntryIcon)icon withButton:(int)button;
-(void)gtkEntry:(GtkEntry *)entry iconReleased:(GtkEntryIcon)icon withButton:(int)button;
-(void)gtkEntry:(GtkEntry *)entry populatePopup:(GtkMenu *)menu;
@end

//==================================================================================================================================
@interface GtkEntry : GtkWidget
{
  GtkEntryBuffer *_buffer;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ entry;
+ entryWithBuffer:(GtkEntryBuffer *)buffer;
- initEntry;
- initWithBuffer:(GtkEntryBuffer *)buffer;

//----------------------------------------------------------------------------------------------------------------------------------
@property (retain)   GtkEntryBuffer  *buffer;
@property (assign)   OFString        *text;
@property (assign)   OFString        *placeholder;
@property (readonly) int              textLength;
@property (assign)   int              maxLength;
@property (assign)   float            textAlign;
@property (assign)   int              charWidth;
@property (assign)   BOOL             isPrivate;
@property (assign)   uint32_t         privateChar;
@property (assign)   BOOL             activatesDefault;
@property (assign)   BOOL             hasFrame;
//Requires GTK+ v3.6+ :
//@property (assign)   GtkTextInput     textInput;
//@property (assign)   GtkTextInputHint textInputHint;
@property (assign)   BOOL             overwriteMode;
@property (assign)   float            progressValue;
@property (assign)   float            progressPulseDelta;
//@property (...) GtkEntryCompletion completion; //TODO: GtkEntryCompletion
@property (assign)   BOOL             iconPrimaryActivatable;
@property (assign)   BOOL             iconPrimarySensitive;
@property (assign)   OFString        *iconPrimaryTooltipText;
@property (assign)   BOOL             iconSecondaryActivatable;
@property (assign)   BOOL             iconSecondarySensitive;
@property (assign)   OFString        *iconSecondaryTooltipText;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)progressPulse;
-(OMDimension)getTextArea;
-(OMDimension)getIconArea:(GtkEntryIcon)icon;
-(void)setIcon:(GtkEntryIcon)icon fromStock:(OFString *)stockId;
//-(void)setIcon:(GtkEntryIcon)icon fromImage:(GtkImage *)image; // <-- TODO: figure out how to do this (via pixbuf)...

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onTextChanged;
-(void)onIconPressed:(GtkEntryIcon)icon withButton:(int)button;
-(void)onIconReleased:(GtkEntryIcon)icon withButton:(int)button;
-(void)onPopulatePopup:(GtkMenu *)menu;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
