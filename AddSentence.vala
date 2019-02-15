class AddSentence : Gtk.Window {

  private Gtk.Entry sentenceField;
  private Gtk.Button okBtn;

  public signal void added(string sentenceMarkup);

  public AddSentence() {
    set_title("Add sentence");
    var vBox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);

    vBox.margin_start = 5;
    vBox.margin_end = 5;

    sentenceField = new Gtk.Entry();
    sentenceField.set_width_chars(50);
    sentenceField.changed.connect(text_change);
    sentenceField.activate.connect(addSentence);

    var tip = new Gtk.Label("");
    tip.set_markup("<small>Select fragment to keep it bold</small>");

    okBtn = new Gtk.Button.with_label("Add");
    okBtn.set_sensitive(false);
    okBtn.clicked.connect(addSentence);

    vBox.pack_start(sentenceField, false, false, 5);
    vBox.pack_start(tip, false, false, 1);
    vBox.pack_end(okBtn, false, false, 5);

    add(vBox);

    delete_event.connect(hide_on_delete);
    hide.connect(() => sentenceField.set_text(""));
  }

  private void text_change() {
    if (sentenceField.get_text().length > 0) {
      okBtn.set_sensitive(true);
    } else {
      okBtn.set_sensitive(false);
    }
  }

  private void addSentence() {
    if (sentenceField.get_text().length < 1) {
      return;
    }
    int start, end;
    if (sentenceField.get_selection_bounds(out start, out end)) {
      sentenceField.insert_text("<b>", 3, ref start);
      end += 3;
      sentenceField.insert_text("</b>", 4, ref end);
    }
    added(sentenceField.get_text());
    hide();
  }

}
