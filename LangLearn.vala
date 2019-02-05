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
      INSERT INTO Sentence(markup, dateadd) VALUES($S, date('now'))
    """;
    Statement stmt;
    int ec = db.prepare_v2(query, query.length, out stmt);
    int ppos = stmt.bind_parameter_index("$S");
    assert(ppos > 0);
    stmt.bind_text(ppos, sentence);
    return new Sentence(db.last_insert_rowid(), sentence, new GLib.DateTime.now_local(), false);
  }

  public void setSentenceReaded(int64 id) {
    string query = ("UPDATE Sentence SET readed = 'TRUE' WHERE id=%" + int64.FORMAT).printf(id);
    string errmsg;
    int ec = db.exec(query, null, out errmsg);
    if (ec != Sqlite.OK) {
      stderr.printf("Error: %s\n", errmsg);
    }
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

    List<Sentence> list = new List<Sentence>();
    while (stmt.step () == Sqlite.ROW) {
      var id = int64.parse(stmt.column_text(0));
      var markup = (string) stmt.column_text(1);
      var datestr = (string) stmt.column_text(2);
      GLib.DateTime date = new GLib.DateTime.local(
        int.parse(datestr.substring(0, 3)),
        int.parse(datestr.substring(6, 2)),
        int.parse(datestr.substring(8, 2)),
        0, 0, 0
      );
      var readed = bool.parse( stmt.column_text(3).down() );
      list.append( new Sentence(id, markup, date, readed) );
    }

    return list;
  }

  public string? getPropertyValue(string key) {
    string query = "SELECT value FROM Property WHERE key=$S";
    Statement stmt;
    int ec = db.prepare_v2(query, query.length, out stmt);
    int ppos = stmt.bind_parameter_index("$S");
    assert(ppos > 0);
    stmt.bind_text(ppos, key);
    stmt.step();
    if (stmt.data_count() == 0) {
      return null;
    }
    return stmt.column_text(0);
  }

  public void setPropertyValue(string key, string v) {
    string query = """
      INSERT OR REPLACE INTO Property(key, value) VALUES($KEY, $VALUE)
    """;
    Statement stmt;
    int ec = db.prepare_v2(query, query.length, out stmt);
    int kppos = stmt.bind_parameter_index("$KEY");
    int vppos = stmt.bind_parameter_index("$VALUE");
    assert( kppos > 0 );
    assert( vppos > 0 );
    stmt.bind_text(kppos, key);
    stmt.bind_text(vppos, v);
    stmt.step();
  }

  // Loop to check day changing, cleaning temporary date, etc...
  private void loop() {

  }


}
