//==================================================================================================================================
// GtkDialogMessage.m
/*==================================================================================================================================
Copyright © 2013 Dillon Aumiller <dillonaumiller@gmail.com>

This file is part of the adenosine library.

adenosine is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, version 3 of the License.

adenosine is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with adenosine.  If not, see <http://www.gnu.org/licenses/>.
==================================================================================================================================*/
#import "GtkNative.h"
#import <adenosine/adenosine.h>

//==================================================================================================================================
#define NATIVE_WIDGET ((struct _GtkWidget        *)_native)
#define NATIVE_DLGMSG ((struct _GtkMessageDialog *)_native)

//==================================================================================================================================
@implementation GtkDialogMessage

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+dialogMessageWithPrimary:(OFString *)primary secondary:(OFString *)secondary type:(GtkDialogMessageType)type buttons:(GtkDialogMessageButtons)buttons
{
  return [[[self alloc] initWithParent:nil
                               primary:primary
                             secondary:secondary
                                  type:type
                               buttons:buttons
                                 flags:GTKDIALOG_FLAG_MODAL|GTKDIALOG_FLAG_DESTROY_WITH_PARENT] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+dialogMessageWithParent:(GtkWindow *)parent primary:(OFString *)primary secondary:(OFString *)secondary type:(GtkDialogMessageType)type buttons:(GtkDialogMessageButtons)buttons
{
  return [[[self alloc] initWithParent:parent
                               primary:primary
                             secondary:secondary
                                  type:type
                               buttons:buttons
                                 flags:GTKDIALOG_FLAG_MODAL|GTKDIALOG_FLAG_DESTROY_WITH_PARENT] autorelease];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
+dialogMessageWithParent:(GtkWindow *)parent primary:(OFString *)primary secondary:(OFString *)secondary type:(GtkDialogMessageType)type buttons:(GtkDialogMessageButtons)buttons flags:(GtkDialogFlags)flags
{
  return [[[self alloc] initWithParent:parent
                               primary:primary
                             secondary:secondary
                                  type:type
                               buttons:buttons
                                 flags:flags] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
-initWithParent:(GtkWindow *)parent primary:(OFString *)primary secondary:(OFString *)secondary type:(GtkDialogMessageType)type buttons:(GtkDialogMessageButtons)buttons flags:(GtkDialogFlags)flags
{
  self = [super init];
  if(self)
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = gtk_message_dialog_new([parent native], (Native_GtkDialogFlags)flags, (GtkMessageType)type, (GtkButtonsType)buttons, "%s", [primary UTF8String]);
    gtk_message_dialog_format_secondary_text(NATIVE_DLGMSG, "%s", [secondary UTF8String]);
    [self installNativeLookup];
    [pool drain];
  }
  return self;
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(GtkWidget *)image
{
  void *nativeImage = gtk_message_dialog_get_image(NATIVE_DLGMSG);
  if(!nativeImage) return nil;
  GtkWidget *image = [GtkWidget nativeToWrapper:nativeImage];
  if(!image) image = [GtkWidget wrapExistingNative:nativeImage];
  return image;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)setImage:(GtkWidget *)image
{
  gtk_message_dialog_set_image(NATIVE_DLGMSG, image.native);
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
