//==================================================================================================================================
// GtkProgressBar.m
//==================================================================================================================================
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
