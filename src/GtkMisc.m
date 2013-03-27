//==================================================================================================================================
// GtkMisc.m
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
#import <adenosine/GtkMisc.h>

//==================================================================================================================================
#define NATIVE_WIDGET ((struct _GtkWidget *)_native)
#define NATIVE_MISC   ((struct _GtkMisc   *)_native)

//==================================================================================================================================
@implementation GtkMisc

//==================================================================================================================================
// Properties
//==================================================================================================================================
-(OMCoordinate)alignment
{
  OMCoordinate alignment;
  gtk_misc_get_alignment(NATIVE_MISC, &alignment.x, &alignment.y);
  return alignment;
}
-(void)setAlignment:(OMCoordinate)alignment
{
  gtk_misc_set_alignment(NATIVE_MISC, alignment.x, alignment.y);
}
//----------------------------------------------------------------------------------------------------------------------------------
-(OMSize)padding
{
  int width, height;
  gtk_misc_get_padding(NATIVE_MISC, &width, &height);
  return OMMakeSize((float)width, (float)height);
}
-(void)setPadding:(OMSize)padding
{
  int width  = (int)padding.width;
  int height = (int)padding.height;
  gtk_misc_set_padding(NATIVE_MISC, width, height);
}

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
