using Sqlite;

class LangLearn {

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
        dateadd DATE NOT NULL
      )
    """;
    ec = db.exec(query, null, out errmsg);
    if (ec != Sqlite.OK) {
      stderr.printf("Error: %s\n", errmsg);
    }
  }

  public void addSentence(string sentence) {
    string query = """
      INSERT INTO Sentence(markup, dateadd) VALUES('%s', date('now'))
    """.printf(Base64.encode(sentence.data));
    db.exec(query, null, null);
  }

  public List<string> todaySentences() {
    string query = """
      SELECT markup FROM Sentence WHERE (
        (dateadd<=date('now') AND dateadd>=date('now', '-7 day'))
        OR dateadd = date('now', '-14 day')
        OR dateadd = date('now', '-21 day')
      )
    """;

    Statement stmt;
    int ec = db.prepare_v2 (query, query.length, out stmt);
    if (ec != Sqlite.OK) {
      stderr.printf ("Error: %d: %s\n", db.errcode (), db.errmsg ());
      return new List<string>();
    }

    List<string> list = new List<string>();
    while (stmt.step () == Sqlite.ROW) {
      stderr.printf("\n%s\n", (string)GLib.Base64.decode(stmt.column_text(0)));
      list.append( (string)GLib.Base64.decode(stmt.column_text(0)) );
    }

    return list;
  }



}
