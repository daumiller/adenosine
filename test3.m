//==================================================================================================================================
#import <ObjFW/ObjFW.h>
#import <atropine/atropine.h>
#import <adenosine/adenosine.h>

//==================================================================================================================================
@interface CanvasController : OFObject <GtkWidgetDelegate>
{
  OMSurface *buffer;
}
-(BOOL)gtkWidget:(GtkWidget *)widget drawToSurface:(OMSurface *)surface;
-(BOOL)gtkWidget:(GtkWidget *)widget dimensionsChanged:(OMDimension)dimension;
-(BOOL)gtkWidget:(GtkWidget *)widget buttonPressed:(int)button local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifiers)modifiers;
-(BOOL)gtkWidget:(GtkWidget *)widget pointerMovedAt:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifiers)modifiers;
-(void)drawBrush:(GtkWidget *)widget X:(float)x Y:(float)y;
-(void)clear;
@end

//==================================================================================================================================
@implementation CanvasController
-(BOOL)gtkWidget:(GtkWidget *)widget drawToSurface:(OMSurface *)surface
{
  [surface setSourceSurface:buffer];
  //[surface setColorR:1.0f G:1.0f B:0.0f];
  [surface paint];
  return NO;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)gtkWidget:(GtkWidget *)widget dimensionsChanged:(OMDimension)dimension
{
  if(buffer) [buffer release];
  buffer = (OMSurface *)[[OMBufferSurface alloc] initWithSize:[widget allocatedSize]];
  [self clear];
  return YES;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)gtkWidget:(GtkWidget *)widget buttonPressed:(int)button local:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifiers)modifiers
{
  if(buffer == nil) return NO;

  if(button == 1)
    [self drawBrush:widget X:local.x Y:local.y];
  else if(button == 2)
    [(OMBufferSurface *)buffer writeToPNG:@"canvas.png"];
  else if(button == 3)
  {
    [self clear];
    [widget queueDrawAll];
  }
  return YES;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(BOOL)gtkWidget:(GtkWidget *)widget pointerMovedAt:(OMCoordinate)local root:(OMCoordinate)root modifiers:(GtkModifiers)modifiers
{
  if(buffer == nil) return NO;
  if(modifiers & GTKMODIFIER_BUTTON1)
    [self drawBrush:widget X:local.x Y:local.y];
  return YES;
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)drawBrush:(GtkWidget *)widget X:(float)x Y:(float)y
{
  OMDimension dimension = OMMakeDimensionFloats(x-3.0f, y-3.0f, 6.0f, 6.0f);
  [buffer setColorR:0.0f G:0.0f B:0.0f];
  [buffer dimension:dimension];
  [buffer fill];
  [widget queueDrawDimension:dimension];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)clear
{
  [buffer clearToColor:OMMakeColorRGB(1.0f, 1.0f, 1.0f)];
}
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-(void)dealloc
{
  [buffer release];
  [super dealloc];
}
@end

//==================================================================================================================================
int main(int argc, char **argv)
{
  OFAutoreleasePool *pool = [[OFAutoreleasePool alloc] init];
  [[GtkRuntime sharedRuntime] startup];

  GtkWindow *window = [GtkWindow window];
  window.title = @"Drawing Area";
  window.quitOnClose = YES;
  window.borderWidth = 8;
  window.size = OMMakeSize(640.0f, 480.0f);

  GtkFrame *frame = [GtkFrame frame];
  frame.shadow = GTKFRAMESHADOW_BEVEL_IN;
  [window add:frame];

  GtkDrawingArea *draw = [GtkDrawingArea drawingArea];
  [frame add:draw];
  draw.delegate = [[[CanvasController alloc] init] autorelease];

  [window showAll];

  [[GtkRuntime sharedRuntime] mainLoopBegin];
  [pool drain];
  return 0;
}

/*
#include <gtk/gtk.h>

static cairo_surface_t *surface = NULL;

void clear_surface(void)
{
  cairo_t *cr;
  cr = cairo_create(surface);
  cairo_set_source_rgb(cr, 1, 1, 1);
  cairo_paint(cr);
  cairo_destroy(cr);
}

gboolean configure_event_cb(GtkWidget *widget, GdkEventConfigure *event, gpointer data)
{
  if(surface) cairo_surface_destroy(surface);
  surface = gdk_window_create_similar_surface(gtk_widget_get_window(widget),
                                              CAIRO_CONTENT_COLOR,
                                              gtk_widget_get_allocated_width(widget),
                                              gtk_widget_get_allocated_height(widget));
  clear_surface();
  return TRUE;
}

gboolean draw_cb(GtkWidget *widget, cairo_t *cr, gpointer data)
{
  cairo_set_source_surface(cr, surface, 0, 0);
  cairo_paint(cr);
  return FALSE;
}

void draw_brush(GtkWidget *widget, gdouble x, gdouble y)
{
  cairo_t *cr;
  cr = cairo_create(surface);
  cairo_rectangle(cr, x-3, y-3, 6, 6);
  cairo_fill(cr);
  cairo_destroy(cr);
  gtk_widget_queue_draw_area(widget, x-3, y-3, 6, 6);
}

gboolean button_press_event_cb(GtkWidget *widget, GdkEventButton *event, gpointer data)
{
  if(surface == NULL) return FALSE;

  if(event->button == GDK_BUTTON_PRIMARY)
    draw_brush(widget, event->x, event->y);
  else if(event->button == GDK_BUTTON_SECONDARY)
  {
    clear_surface();
    gtk_widget_queue_draw(widget);
  }

  return TRUE;
}

gboolean motion_notify_event_cb(GtkWidget *widget, GdkEventMotion *event, gpointer data)
{
  if(surface == NULL) return FALSE;
  if(event->state & GDK_BUTTON1_MASK) draw_brush(widget, event->x, event->y);
  return TRUE;
}

void close_window(void)
{
  if(surface) cairo_surface_destroy(surface);
  gtk_main_quit();
}

int main(int argc, char **argv)
{
  gtk_init(&argc, &argv);

  GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
  gtk_window_set_title(GTK_WINDOW(window), "Drawing Area");
  g_signal_connect(window, "destroy", G_CALLBACK(close_window), NULL);
  gtk_container_set_border_width(GTK_CONTAINER(window), 8);

  GtkWidget *frame = gtk_frame_new(NULL);
  gtk_frame_set_shadow_type(GTK_FRAME(frame), GTK_SHADOW_IN);
  gtk_container_add(GTK_CONTAINER(window), frame);

  GtkWidget *da = gtk_drawing_area_new();
  gtk_widget_set_size_request(da, 256, 256);
  gtk_container_add(GTK_CONTAINER(frame), da);
  g_signal_connect(da, "draw"               , G_CALLBACK(draw_cb)               , NULL);
  g_signal_connect(da, "configure-event"    , G_CALLBACK(configure_event_cb)    , NULL);
  g_signal_connect(da, "motion-notify-event", G_CALLBACK(motion_notify_event_cb), NULL);
  g_signal_connect(da, "button-press-event" , G_CALLBACK(button_press_event_cb) , NULL);
  gtk_widget_set_events(da, gtk_widget_get_events(da) | GDK_BUTTON_PRESS_MASK | GDK_POINTER_MOTION_MASK);

  gtk_widget_show_all(window);
  gtk_main();
  return 0;
}
*/
