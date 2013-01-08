//==================================================================================================================================
// GtkTextMark.h
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
#import <ObjFW/ObjFW.h>

//==================================================================================================================================
@interface GtkTextMark : OFObject
{
  void *_native;
}

//----------------------------------------------------------------------------------------------------------------------------------
+ textMark;
+ textMarkWithName:(OFString *)name;
+ textMarkWithName:(OFString *)name andLeftGravity:(BOOL)leftGravity;
- initTextMark;
- initWithName:(OFString *)name;
- initWithName:(OFString *)name andLeftGravity:(BOOL)leftGravity;

//----------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) isWrapped:(void *)native;
+ nativeToWrapper:(void *)native;
+ wrapExistingNative:(void *)native;
- initWithExistingNative:(void *)native;
-(void)installNativeLookup;
-(void)destroy;

//----------------------------------------------------------------------------------------------------------------------------------
@property (readonly) void          *native;
@property (readonly) OFString      *name;
@property (readonly) BOOL           leftGravity;
@property (readonly) BOOL           wasDeleted;
@property (readonly) GtkTextBuffer *buffer;
@property (assign)   BOOL           visible;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -