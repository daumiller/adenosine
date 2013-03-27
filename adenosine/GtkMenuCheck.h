//==================================================================================================================================
// GtkMenuCheck.h
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
