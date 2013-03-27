//==================================================================================================================================
// GtkProgressBar.m
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
#import "GtkNative.h"
#import <adenosine/GtkProgressBar.h>

//==================================================================================================================================
#define NATIVE_WIDGET   ((struct _GtkWidget      *)_native)
#define NATIVE_PROGRESS ((struct _GtkProgressBar *)_native)

//==================================================================================================================================
@implementation GtkProgressBar

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ progressBar
{
  return [[[self alloc] initProgressBar] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- initProgressBar
{
  self = [super init];
  if(self)
  {
    _native = (void *)gtk_progress_bar_new();
    [self installNativeLookup];
  }
  return self;
}

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(float)value                                   { return (float)gtk_progress_bar_get_fraction(NATIVE_PROGRESS);             }
-(void)setValue:(float)value                    { gtk_progress_bar_set_fraction(NATIVE_PROGRESS, (double)value);            }
//----------------------------------------------------------------------------------------------------------------------------------
-(float)pulseDelta                              { return (float)gtk_progress_bar_get_pulse_step(NATIVE_PROGRESS);           }
-(void)setPulseDelta:(float)pulseDelta          { gtk_progress_bar_set_pulse_step(NATIVE_PROGRESS, (double)pulseDelta);     }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)inverted                                 { return gtk_progress_bar_get_inverted(NATIVE_PROGRESS);                    }
-(void)setInverted:(BOOL)inverted               { gtk_progress_bar_set_inverted(NATIVE_PROGRESS, inverted);                 }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)showText                                 { return gtk_progress_bar_get_show_text(NATIVE_PROGRESS);                   }
-(void)setShowText:(BOOL)showText               { gtk_progress_bar_set_show_text(NATIVE_PROGRESS, showText);                }
//----------------------------------------------------------------------------------------------------------------------------------
-(BOOL)textUseEllipsis                          { return (gtk_progress_bar_get_ellipsize(NATIVE_PROGRESS) != 0);            }
-(void)setTextUseEllipsis:(BOOL)textUseEllipsis { gtk_progress_bar_set_ellipsize(NATIVE_PROGRESS, textUseEllipsis ? 3 : 0); }
//----------------------------------------------------------------------------------------------------------------------------------
-(OFString *)text
{
  return [OFString stringWithUTF8String:gtk_progress_bar_get_text(NATIVE_PROGRESS)];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setText:(OFString *)text
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_progress_bar_set_text(NATIVE_PROGRESS, [text UTF8String]);
  [pool drain];
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)pulse
{
  gtk_progress_bar_pulse(NATIVE_PROGRESS);
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
