//==================================================================================================================================
// GtkViewport.m
//==================================================================================================================================
#import "GtkNative.h"
#import <adenosine/adenosine.h>

//==================================================================================================================================
#define NATIVE_WIDGET   ((struct _GtkWidget   *)_native)
#define NATIVE_VIEWPORT ((struct _GtkViewport *)_native)

//==================================================================================================================================
@implementation GtkViewport

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ viewport { return [[[self alloc] initViewport] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- initViewport
{
  self = [super init];
  if(self)
  {
    _native = gtk_viewport_new(NULL, NULL);
    [self installNativeLookup];
  }
  return self;
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
