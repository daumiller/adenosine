//==================================================================================================================================
// GtkMenuItem.m
//==================================================================================================================================
#import "GtkNative.h"
#import <adenosine/adenosine.h>

//==================================================================================================================================
#define NATIVE_WIDGET   ((struct _GtkWidget   *)_native)
#define NATIVE_MENUITEM ((struct _GtkMenuItem *)_native)

//==================================================================================================================================
// Signal/Event -> Object Proxies
//==================================================================================================================================
static void ConnectionProxy_Activated(struct _GtkMenuItem *menuItem, void *data)
{
  GtkMenuItem *obj = (GtkMenuItem *)[GtkWidget nativeToWrapper:(void *)menuItem];
  [obj onActivated];
}

//==================================================================================================================================
@implementation GtkMenuItem

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ menuItem                            { return [[[self alloc] initMenuItem      ] autorelease]; }
+ menuItemWithText:(OFString *)text   { return [[[self alloc] initWithText:text ] autorelease]; }
+ menuItemWithAccel:(OFString *)text  { return [[[self alloc] initWithAccel:text] autorelease]; }
+ menuItemWithAccel:(OFString *)text andDelegate:(id)delegate
{
  return [[[self alloc] initWithAccel:text andDelegate:delegate] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- initMenuItem
{
  self = [super init];
  if(self)
  {
    _native = gtk_menu_item_new();
    [self installNativeLookup];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithText:(OFString *)text
{
  self = [super init];
  if(self)
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = gtk_menu_item_new_with_label([text UTF8String]);
    [self installNativeLookup];
    [pool drain];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithAccel:(OFString *)text
{
  self = [super init];
  if(self)
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = gtk_menu_item_new_with_mnemonic([text UTF8String]);
    [self installNativeLookup];
    [pool drain];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initWithAccel:(OFString *)text andDelegate:(id)delegate
{
  self = [super init];
  if(self)
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = gtk_menu_item_new_with_mnemonic([text UTF8String]);
    [self installNativeLookup];
    self.delegate = delegate;
    [pool drain];
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  self.submenu = nil;
  [super dealloc];
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(OFString *)text { return [OFString stringWithUTF8String:gtk_menu_item_get_label(NATIVE_MENUITEM)]; }
-(void)setText:(OFString *)text
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  gtk_menu_item_set_label(NATIVE_MENUITEM, [text UTF8String]);
  [pool drain];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)textIsAccel                      { return gtk_menu_item_get_use_underline(NATIVE_MENUITEM);       }
-(void)setTextIsAccel:(BOOL)textIsAccel { gtk_menu_item_set_use_underline(NATIVE_MENUITEM, textIsAccel); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(GtkWidget *)submenu { return _submenu; }
-(void)setSubmenu:(GtkWidget *)submenu
{
  [_submenu release];
  _submenu = [submenu retain];
  gtk_menu_item_set_submenu(NATIVE_MENUITEM, [_submenu native]);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)setDelegate:(id)delegate
{
  [super setDelegate:delegate];
  
  if(_delegate)
  {
    if([_delegate respondsToSelector:@selector(gtkMenuItemActivated:)])
      [_connections addObject:[OFNumber numberWithUnsignedLong:
        g_signal_connect(_native, "activate", G_CALLBACK(ConnectionProxy_Activated),NULL)]];
  }
}

//==================================================================================================================================
// Utilities
//==================================================================================================================================
-(void)addHotkey:(unsigned int)keyCode withModifiers:(GtkModifier)modifiers toWindow:(GtkWindow *)window
{
  gtk_widget_add_accelerator(NATIVE_WIDGET, "activate", window.hotkeyId, keyCode, (GdkModifierType)modifiers, GTK_ACCEL_VISIBLE);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)removeHotkey:(unsigned int)keyCode withModifiers:(GtkModifier)modifiers fromWindow:(GtkWindow *)window
{
  gtk_widget_remove_accelerator(NATIVE_WIDGET, window.hotkeyId, keyCode, (GdkModifierType)modifiers);
}

//==================================================================================================================================
// Signal Handlers
//==================================================================================================================================
-(void)onActivated
{
  [_delegate gtkMenuItemActivated:self];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
