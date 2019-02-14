using Gtk;
using Xfce;

class Plugin : Xfce.PanelPlugin {

  public static Plugin plugin;

  public Controls controls;
  public SentenceWindow sentence;
  public LangLearn langLearn;
  public Queue<Sentence> queue;
  public int unreaded_sentences;

  public override void @construct() {
    Plugin.plugin = this;

    // configure_plugin.connect(() => true);
    size_changed.connect(() => true);
    destroy.connect(() => { Gtk.main_quit (); });

    langLearn = new LangLearn(".langlearn.db");
    langLearn.sentence_list_changed.connect(update_sentence_queue);
    update_sentence_queue();

    controls = new Controls();
    controls.sentence_added.connect(sentence_add);
    controls.readed_clicked.connect(sentence_set_readed);
    add(controls);

    sentence = new SentenceWindow();

    startTimer();

    show_all();
  }

  public void update_sentence_queue() {
    List<Sentence> today = langLearn.todaySentences();
    queue = new Queue<Sentence>();
    unreaded_sentences = 0;
    foreach (Sentence s in today) {
      queue.push_tail(s);
      if (!s.readed) unreaded_sentences++;
    }
  }

  public void sentence_add(string markup) {
    Sentence s = langLearn.addSentence(markup);
    unreaded_sentences++;
    queue.push_tail(s);
  }

  public void sentence_set_readed() {
    Sentence? s = sentence.get_sentence();
    if (s != null && unreaded_sentences>0 && !s.readed) {
      langLearn.setSentenceReaded(s.id);
      s.readed = true;
      unreaded_sentences--;
      sentence.set_sentence(s); // redraw
    }
  }

  public void occur_next_sentence() {
    if (unreaded_sentences < 1 && controls.only_unreaded_item.active || queue.length < 1) return;
    Sentence next_sentence = queue.peek_head();
    do {
      next_sentence = queue.pop_head();
      queue.push_tail(next_sentence);
    } while (next_sentence.readed && controls.only_unreaded_item.active);
    sentence.set_sentence(next_sentence);
    sentence.occur();
  }

  public void startTimer() {
    occur_next_sentence();
    GLib.Timeout.add_full(Priority.DEFAULT, 10000, timerLoop);
  }

  public bool timerLoop() {
    sentence.fade();
    GLib.Timeout.add_full(Priority.DEFAULT, SentenceWindow.OCCUR_FADE_INTERVAL, () => {
      occur_next_sentence();
      GLib.Timeout.add_full(Priority.DEFAULT, 10000, timerLoop);
      return false;
    });
    return false;
  }

}

[ModuleInit]
public Type xfce_panel_module_init(TypeModule module) {
  return typeof(Plugin);
}
