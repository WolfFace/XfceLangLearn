class Sentence : Gtk.Window {

  public const int OCCUR_FADE_INTERVAL = 500;

  public Gtk.Label label;
  private int64 animationStartTime;
  private double animationStartOpacity;
  private double animationTargetOpacity;
  private int animationTimeInterval;

  public Sentence() {
    set_type_hint(Gdk.WindowTypeHint.DOCK);
    set_keep_above(true);
    set_app_paintable(true);

    set_visual(screen.get_rgba_visual());

    draw.connect(on_draw);

    label = new Gtk.Label("");

    var hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
    hbox.pack_start(label, false, false, 8);
    add(hbox);
    show_all();
    realize();

    GLib.Timeout.add_full(Priority.HIGH, 1, opacityAnimation);
    set_opacity(0.0);
  }

  private bool opacityAnimation() {
    var now = GLib.get_monotonic_time() / 1000;
    if (now-animationStartTime >= animationTimeInterval) {
      set_opacity(animationTargetOpacity);
      return true;
    }
    set_opacity(
      animationStartOpacity
      + (double)(now-animationStartTime)/animationTimeInterval
      * (animationTargetOpacity-animationStartOpacity)
    );
    move_to_plugin();
    return true;
  }

  public void set_text(string text) {
    label.set_markup(text);
  }

  public void move_to_plugin() {
    Gtk.Allocation a;
    var toplevel = Plugin.plugin.get_toplevel();
    toplevel.get_allocation(out a);
    var ancestor = toplevel.get_ancestor(typeof(Gtk.Plug)) as Gtk.Plug;
    if (ancestor != null) {
      ancestor
        .get_socket_window()
        .get_geometry(out a.x, out a.y, out a.width, out a.height);
    }
    int w, h;
    get_size(out w, out h);
    move(a.x-w, a.y);
    set_size_request(a.width, a.height);
  }

  public void set_opacity_in_interval(double opacity, int interval) {
    var start_time = GLib.get_monotonic_time() / 1000;
    animationTargetOpacity = opacity;
    animationStartTime = start_time;
    animationStartOpacity = get_opacity();
    animationTimeInterval = interval;
  }

  public void set_opacity_from_in_interval(double startOpacity, double opacity, int interval) {
    var start_time = GLib.get_monotonic_time() / 1000;
    animationTargetOpacity = opacity;
    animationStartTime = start_time;
    animationStartOpacity = startOpacity;
    animationTimeInterval = interval;
  }

  public void occur() {
    set_opacity_in_interval(1.0, OCCUR_FADE_INTERVAL);
    move_to_plugin();
  }

  public void fade() {
    set_opacity_in_interval(0.0, OCCUR_FADE_INTERVAL);
  }

  private bool on_draw(Cairo.Context cr) {
    cr.save();
    cr.set_source_rgba(0.25, 0, 1, 0.8);
    cr.set_operator(Cairo.Operator.SOURCE);
    cr.paint();
    cr.restore();
    input_shape_combine_region(new Cairo.Region());
    return false;
  }

}
