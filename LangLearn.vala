using Sqlite;

class Sentence {
  public int64 id;
  public string markup;
  public GLib.DateTime dateadd;
  public bool readed;

  public Sentence(int64 id, string markup, GLib.DateTime date, bool readed) {
    this.id = id;
    this.markup = markup;
    this.dateadd = date;
    this.readed = readed;
  }
}

class LangLearn {

  public signal void sentence_list_changed();

  private Database db;

  public LangLearn(string sqlitePath) {
    string errmsg;
    int ec;
    if (Database.open(sqlitePath, out db) != Sqlite.OK) {
      stderr.printf ("\n\n\nCan't open database: %d: %s\n", db.errcode (), db.errmsg ());
    } else {
      stderr.printf("\n\n\nDatabase opened!");
    }

    string query = """
      CREATE TABLE IF NOT EXISTS Sentence (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        markup TEXT NOT NULL,
        dateadd DATE NOT NULL,
        readed BOOLEAN DEFAULT FALSE
      );
      CREATE TABLE IF NOT EXISTS Property (
        key TEXT PRIMARY KEY UNIQUE,
        value TEXT NOT NULL DEFAULT ''
      )
    """;
    ec = db.exec(query, null, out errmsg);
    if (ec != Sqlite.OK) {
      stderr.printf("Error: %s\n", errmsg);
    }
  }

  public Sentence addSentence(string sentence) {
    string query = """
      INSERT INTO Sentence(markup, dateadd) VALUES('%s', date('now'))
    """.printf(Base64.encode(sentence.data));
    db.exec(query, null, null);
    return new Sentence(db.last_insert_rowid(), sentence, new GLib.DateTime.now_local(), false);
  }

  public List<Sentence> todaySentences() {
    string query = """
      SELECT id, markup, dateadd, readed FROM Sentence WHERE (
        (dateadd<=date('now') AND dateadd>=date('now', '-7 day'))
        OR dateadd = date('now', '-14 day')
        OR dateadd = date('now', '-21 day')
      )
    """;

    Statement stmt;
    int ec = db.prepare_v2 (query, query.length, out stmt);
    if (ec != Sqlite.OK) {
      stderr.printf ("Error: %d: %s\n", db.errcode (), db.errmsg ());
      return new List<Sentence>();
    }

    List<Sentence> list = new List<Sentence>();
    while (stmt.step () == Sqlite.ROW) {
      var id = int64.parse(stmt.column_text(0));
      var markup = (string) GLib.Base64.decode(stmt.column_text(1));
      var datestr = (string) stmt.column_text(2);
      GLib.DateTime date = new GLib.DateTime.local(
        int.parse(datestr.substring(0, 3)),
        int.parse(datestr.substring(6, 2)),
        int.parse(datestr.substring(8, 2)),
        0, 0, 0
      );
      var readed = bool.parse( stmt.column_text(3) );
      list.append( new Sentence(id, markup, date, readed) );
    }

    return list;
  }

  // Loop to check day changing, cleaning temporary date, etc...
  private void loop() {

  }


}
