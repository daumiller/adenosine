//==================================================================================================================================
// GtkTextSearchResult.h
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
#import <adenosine/GtkEnums.h>
@class GtkTextIterator;

//==================================================================================================================================
@interface GtkTextSearchResult : OFObject
{
  BOOL             _isMatch;
  GtkTextIterator *_matchStart;
  GtkTextIterator *_matchEnd;
}

//----------------------------------------------------------------------------------------------------------------------------------
@property (assign) BOOL             isMatch;
@property (retain) GtkTextIterator *matchStart;
@property (retain) GtkTextIterator *matchEnd;

//----------------------------------------------------------------------------------------------------------------------------------
+ textSearchResultWithMatch:(BOOL)match nativeStart:(void *)nativeStart nativeEnd:(void *)nativeEnd;
+ textSearchResultWithMatch:(BOOL)match start:(GtkTextIterator *)start end:(GtkTextIterator *)end;
- initWithMatch:(BOOL)match nativeStart:(void *)nativeStart nativeEnd:(void *)nativeEnd;
- initWithMatch:(BOOL)match start:(GtkTextIterator *)start end:(GtkTextIterator *)end;

//==================================================================================================================================
@end

//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
