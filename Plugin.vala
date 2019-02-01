using Gtk;
using Xfce;

class Plugin : Xfce.PanelPlugin {

  public static Plugin plugin;

  public Controls controls;
  public Sentence sentence;
  public LangLearn langLearn;
  public Queue<string> queue;

  public override void @construct() {
    Plugin.plugin = this;

    // configure_plugin.connect(() => true);
    size_changed.connect(() => true);
    destroy.connect(() => { Gtk.main_quit (); });

    langLearn = new LangLearn(".langlearn.db");
    List<string> today = langLearn.todaySentences();
    queue = new Queue<string>();
    foreach (string s in today) {
      queue.push_tail(s);
    }

    controls = new Controls();
    controls.sentence_added.connect(sentence_add);
    add(controls);

    sentence = new Sentence();

    startTimer();

    show_all();
  }

  public void sentence_add(string markup) {
    langLearn.addSentence(markup);
    queue.push_tail(markup);
  }

  public void occur_next_sentence() {
    if (queue.length == 0) {
      return;
    }
    string next_sentence = queue.pop_head();
    queue.push_tail(next_sentence);
    sentence.set_text(next_sentence);
    sentence.occur();
  }

  public void startTimer() {
    occur_next_sentence();
    GLib.Timeout.add_full(Priority.DEFAULT, 5000, timerLoop);
  }

  public bool timerLoop() {
    sentence.fade();
    GLib.Timeout.add_full(Priority.DEFAULT, Sentence.OCCUR_FADE_INTERVAL, () => {
      occur_next_sentence();
      GLib.Timeout.add_full(Priority.DEFAULT, 5000, timerLoop);
      return false;
    });
    return false;
  }

}

[ModuleInit]
public Type xfce_panel_module_init(TypeModule module) {
  return typeof(Plugin);
}
