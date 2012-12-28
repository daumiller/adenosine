#import <adenosine/adenosine.h>

int main(int argc, char **argv)
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];

  [[GtkRuntime sharedRuntime] startup];
  GtkWindow *window = [GtkWindow windowWithType:GTKWINDOWTYPE_TOPLEVEL];
  window.quitOnClose = YES;
  [window show];
  [[GtkRuntime sharedRuntime] mainLoopBegin];

  [pool drain];
  return 0;
}

/*
#include <gtk/gtk.h>

int main(int argc, char **argv)
{
  GtkWidget *window;
  gtk_init(&argc, &argv);
  window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);
  gtk_widget_show(window);
  gtk_main();
  return 0;
}
*/
