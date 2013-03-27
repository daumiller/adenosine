//==================================================================================================================================
// GtkFontButton.h
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
#import <adenosine/GtkButton.h>
#import <adenosine/GtkFontChooser.h>
@class OMFont;

//==================================================================================================================================
@class GtkFontButton;
@protocol GtkFontButtonDelegate <OFObject>
@optional
-(void)gtkFontButton:(GtkFontButton *)fontButton fontSet:(OMFont *)font;
@end

//==================================================================================================================================
@interface GtkFontButton : GtkButton <GtkFontChooser>
{
  OMFont *_font;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ fontButton;
+ fontButtonWithFont:(OMFont *)font;
+ fontButtonWithFontString:(OFString *)fontString;
- initFontButton;
- initWithFont:(OMFont *)font;
- initWithFontString:(OFString *)fontString;

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) BOOL      showStyle;
@property (assign) BOOL      showSize;
@property (assign) BOOL      useFont;
@property (assign) BOOL      useSize;
@property (assign) OFString *dialogTitle;

//----------------------------------------------------------------------------------------------------------------------------------
-(void)onFontSet:(OMFont *)font;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
