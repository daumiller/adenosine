//==================================================================================================================================
// GtkEntry.h
/*==================================================================================================================================
Copyright © 2013, Dillon Aumiller <dillonaumiller@gmail.com>
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met: 

1. Redistributions of source code must retain the above copyright notice, this
   list of conditions and the following disclaimer. 
2. Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation
   and/or other materials provided with the distribution. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
==================================================================================================================================*/
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
