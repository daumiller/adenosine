//==================================================================================================================================
// GtkDialogMessage.m
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
    const char *primaryString = primary ? [primary UTF8String] : "";
    _native = gtk_message_dialog_new([parent native], (Native_GtkDialogFlags)flags, (GtkMessageType)type, (GtkButtonsType)buttons, "%s", primaryString);
    if(secondary) gtk_message_dialog_format_secondary_text(NATIVE_DLGMSG, "%s", [secondary UTF8String]);
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
