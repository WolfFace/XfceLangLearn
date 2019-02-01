PACKAGES = gmodule-2.0 gtk+-3.0 exo-2 libxfce4ui-2 libxfce4panel-2.0 libxfconf-0 sqlite3

liblanglearn.so: *.vala
	valac --vapidir ./vapi $(patsubst %,--pkg %, $(PACKAGES)) -C *.vala
	gcc -shared -fPIC $$(pkg-config --cflags --libs $(PACKAGES)) -o liblanglearn.so *.c -lsqlite3

clean:
	rm *.c
	rm *.so
