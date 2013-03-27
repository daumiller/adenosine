//==================================================================================================================================
// GtkRuntime.m
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
#import <adenosine/GtkRuntime.h>

//==================================================================================================================================
@implementation GtkRuntime

//==================================================================================================================================
static GtkRuntime *GtkRuntime_shared = nil;
static int    GtkRuntime_noargs_i = 0;
static char **GtkRuntime_noargs_s = NULL;

//----------------------------------------------------------------------------------------------------------------------------------
+ sharedRuntime
{
  if(GtkRuntime_shared == NULL)
    GtkRuntime_shared = [[GtkRuntime alloc] init];
  return GtkRuntime_shared;
}

//----------------------------------------------------------------------------------------------------------------------------------
@synthesize isRunning = _isRunning;

//----------------------------------------------------------------------------------------------------------------------------------
//preprocessor work-around for some newer (windows-only?) Macro issues...
#define GtkWindow Native_GtkWindow
#define GtkBox    Native_GtkBox
- (void)startup { gtk_init(&GtkRuntime_noargs_i, &GtkRuntime_noargs_s); }
- (void)startupWithArgC:(int *)argc andArgV:(char ***)argv { gtk_init(argc, argv); }
#undef GtkBox
#undef GtkWindow
//----------------------------------------------------------------------------------------------------------------------------------
- (void)mainLoopBegin { _isRunning = YES; gtk_main();                        }
- (void)mainLoopQuit  { if(_isRunning) { _isRunning = NO; gtk_main_quit(); } }

@end
//==================================================================================================================================
//----------------------------------------------------------------------------------------------------------------------------------
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
