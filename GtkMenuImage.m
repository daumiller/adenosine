//==================================================================================================================================
// GtkMenuImage.m
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
#define NATIVE_WIDGET    ((struct _GtkWidget        *)_native)
#define NATIVE_MENUIMAGE ((struct _GtkImageMenuItem *)_native)

//==================================================================================================================================
@implementation GtkMenuImage

//==================================================================================================================================
// Constructors/Destructor
//==================================================================================================================================
+ menuImage                               { return [[[self alloc] initMenuImage        ] autorelease]; }
+ menuImageFromStock:(OFString *)stockId  { return [[[self alloc] initFromStock:stockId] autorelease]; }
+ menuImageWithText:(OFString *)text      { return [[[self alloc] initWithText:text    ] autorelease]; }
+ menuImageWithAccel:(OFString *)text     { return [[[self alloc] initWithAccel:text   ] autorelease]; }
//----------------------------------------------------------------------------------------------------------------------------------
- initMenuImage
{
  self = [super init];
  if(self)
  {
    _native = gtk_image_menu_item_new();
    [self installNativeLookup];
  }
  return self;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
- initFromStock:(OFString *)stockId
{
  self = [super init];
  if(self)
  {
    OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
    _native = gtk_image_menu_item_new_from_stock([stockId UTF8String], NULL);
    [self installNativeLookup];
    [pool drain];
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
    _native = gtk_image_menu_item_new_with_label([text UTF8String]);
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
    _native = gtk_image_menu_item_new_with_mnemonic([text UTF8String]);
    [self installNativeLookup];
    [pool drain];
  }
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
-(void)dealloc
{
  self.image = nil;
  [super dealloc];
}

//==================================================================================================================================
// Properites
//==================================================================================================================================
-(BOOL)textIsStockId                            { return gtk_image_menu_item_get_use_stock(NATIVE_MENUIMAGE);                   }
-(void)setTextIsStockId:(BOOL)textIsStockId     { gtk_image_menu_item_set_use_stock(NATIVE_MENUIMAGE, textIsStockId);           }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)alwaysShowImage                          { return gtk_image_menu_item_get_always_show_image(NATIVE_MENUIMAGE);           }
-(void)setAlwaysShowImage:(BOOL)alwaysShowImage { gtk_image_menu_item_set_always_show_image(NATIVE_MENUIMAGE, alwaysShowImage); }
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(GtkWidget *)image { return [GtkWidget nativeToWrapper:gtk_image_menu_item_get_image(NATIVE_MENUIMAGE)]; }
-(void)setImage:(GtkWidget *)image
{
  //NOTE: may need to revisit this later; although, i believe that all reasonable usage-patterns will result in consistent retention
  GtkWidget *curr = self.image;
  if(curr == image) return;
  if(curr) [curr release];
  if(image) [image retain];
  gtk_image_menu_item_set_image(NATIVE_MENUIMAGE, image.native);
}

//==================================================================================================================================
// GtkContainer Overrides
//==================================================================================================================================
-(void)wrapAllChildren
{
  //maintain our extra image reference consistently
  GtkWidget *wrappedImage;
  void *nativeImage = gtk_image_menu_item_get_image(NATIVE_MENUIMAGE);
  wrappedImage = [GtkWidget nativeToWrapper:nativeImage]; if(wrappedImage) [wrappedImage release];
  [super wrapAllChildren];
  wrappedImage = [GtkWidget nativeToWrapper:nativeImage]; if(wrappedImage) [wrappedImage retain];
}

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
