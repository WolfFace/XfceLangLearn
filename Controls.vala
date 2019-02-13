class Controls : Gtk.Box {

  private Gtk.Button readed_btn;
  // private Gtk.Button prev_btn;
  // private Gtk.Button next_btn;
  private Gtk.Button menu_btn;
  private Gtk.Menu menu;
  public Gtk.CheckMenuItem only_unreaded_item;
  private AddSentence add_sentence_window;

  public signal void sentence_added(string markup);
  public signal void readed_clicked();

  public Controls() {
    this.set_orientation(Gtk.Orientation.HORIZONTAL);

    readed_btn = new Gtk.Button.from_icon_name("media-record", Gtk.IconSize.BUTTON);
    readed_btn.clicked.connect(() => readed_clicked());

    // prev_btn = new Gtk.Button.from_icon_name("go-previous", Gtk.IconSize.BUTTON);
    // next_btn = new Gtk.Button.from_icon_name("go-next", Gtk.IconSize.BUTTON);

    menu_btn = new Gtk.Button.from_icon_name("go-down", Gtk.IconSize.BUTTON);
    menu_btn.clicked.connect(event => menu.popup (null, null, null, 0, 0));

    menu = new Gtk.Menu();
    menu.attach_to_widget(menu_btn, null);

    var add_sentence_item = new Gtk.MenuItem.with_label("Add sentence");
    add_sentence_window = new AddSentence();
    add_sentence_window.added.connect(s => sentence_added(s));
    add_sentence_item.activate.connect(() => add_sentence_window.show_all());
    menu.add(add_sentence_item);

    only_unreaded_item = new Gtk.CheckMenuItem.with_label("Only unreaded");
    menu.add(only_unreaded_item);

    menu.show_all();

    pack_start(readed_btn, false, false, 0);
    // pack_start(prev_btn, false, false, 0);
    // pack_start(next_btn, false, false, 0);
    pack_start(menu_btn, true, true, 0);
    realize();
  }

}
