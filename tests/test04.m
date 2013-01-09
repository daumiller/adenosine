#import <adenosine/adenosine.h>

int main(int argc, char **argv)
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  [[GtkRuntime sharedRuntime] startup];

  GtkWindow *window = [GtkWindow window];
  window.title = @"ObjGTK+ : Test 4 (GtkImage)";
  window.quitOnClose = YES;
  window.size = OMMakeSize(640.0f, 480.0f);

  GtkImage *image = [GtkImage imageWithFile:@"gtkImageLoadTest.png"];

  [window add:image];
  [window showAll];

  [[GtkRuntime sharedRuntime] mainLoopBegin];
  [pool drain];
  return 0;
}
