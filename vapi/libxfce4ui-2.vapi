/* libxfce4ui-2.vapi generated by vapigen-0.26, do not modify. */

namespace Xfce {
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public class SMClient : GLib.Object {
		[CCode (has_construct_function = false)]
		protected SMClient ();
		public bool connect () throws GLib.Error;
		public void disconnect ();
		public static GLib.Quark error_quark ();
		public static unowned Xfce.SMClient @get ();
		public unowned string get_client_id ();
		public unowned string get_current_directory ();
		public static unowned Xfce.SMClient get_full (Xfce.SMClientRestartStyle restart_style, uchar priority, string resumed_client_id, string current_directory, string restart_command, string desktop_file);
		public static unowned GLib.OptionGroup get_option_group (int argc, string argv);
		public uchar get_priority ();
		public unowned string get_restart_command ();
		public Xfce.SMClientRestartStyle get_restart_style ();
		public unowned string get_state_file ();
		public static unowned Xfce.SMClient get_with_argv (int argc, string argv, Xfce.SMClientRestartStyle restart_style, uchar priority);
		public bool is_connected ();
		public bool is_resumed ();
		public void request_shutdown (Xfce.SMClientShutdownHint shutdown_hint);
		public void set_current_directory (string current_directory);
		public void set_desktop_file (string desktop_file);
		public void set_priority (uchar priority);
		public void set_restart_command (string restart_command);
		public void set_restart_style (Xfce.SMClientRestartStyle restart_style);
		public int argc { construct; }
		[CCode (array_length = false, array_null_terminated = true)]
		public string[] argv { construct; }
		public string client_id { get; construct; }
		public string current_directory { get; set; }
		[NoAccessorMethod]
		public string desktop_file { owned get; set; }
		public uchar priority { get; set construct; }
		[CCode (array_length = false, array_null_terminated = true)]
		public string[] restart_command { get; set; }
		public Xfce.SMClientRestartStyle restart_style { get; set construct; }
		[NoAccessorMethod]
		public bool resumed { get; }
		public virtual signal void quit ();
		public virtual signal void quit_cancelled ();
		public virtual signal bool quit_requested ();
		public virtual signal void save_state ();
		public virtual signal void save_state_extended ();
	}
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public class TitledDialog : Gtk.Dialog, Atk.Implementor, Gtk.Buildable {
		[CCode (has_construct_function = false, type = "GtkWidget*")]
		public TitledDialog ();
		public unowned string get_subtitle ();
		public void set_subtitle (string subtitle);
		[CCode (has_construct_function = false, type = "GtkWidget*")]
		public TitledDialog.with_buttons (string title, Gtk.Window parent, Gtk.DialogFlags flags, ...);
		public string subtitle { get; set; }
	}
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h", cprefix = "XFCE_SM_CLIENT_PRIORITY_", has_type_id = false)]
	public enum SMClientPriority {
		HIGHEST,
		WM,
		CORE,
		DESKTOP,
		DEFAULT,
		LOWEST
	}
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h", cprefix = "XFCE_SM_CLIENT_RESTART_")]
	public enum SMClientRestartStyle {
		NORMAL,
		IMMEDIATELY
	}
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h", cprefix = "XFCE_SM_CLIENT_SHUTDOWN_HINT_")]
	public enum SMClientShutdownHint {
		ASK,
		LOGOUT,
		HALT,
		REBOOT
	}
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h", cprefix = "XFCE_SM_CLIENT_ERROR_")]
	public enum SmCLientErrorEnum {
		FAILED,
		INVALID_CLIENT
	}
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public const string BUTTON_TYPE_MIXED;
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public const string BUTTON_TYPE_PIXBUF;
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public const int LIBXFCE4UI_MAJOR_VERSION;
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public const int LIBXFCE4UI_MICRO_VERSION;
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public const int LIBXFCE4UI_MINOR_VERSION;
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static bool dialog_confirm (Gtk.Window parent, string stock_id, string confirm_label, string secondary_text, string primary_format);
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static void dialog_show_error (Gtk.Window parent, GLib.Error error, string primary_format);
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static void dialog_show_help (Gtk.Window parent, string application, string page, string offset);
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static void dialog_show_help_with_version (Gtk.Window parent, string application, string page, string offset, string version);
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static void dialog_show_info (Gtk.Window parent, string secondary_text, string primary_format);
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static void dialog_show_warning (Gtk.Window parent, string secondary_text, string primary_format);
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static unowned Gdk.Screen gdk_screen_get_active (int monitor_return);
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static unowned Gtk.Widget gtk_button_new_mixed (string stock_id, string label);
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static unowned Gtk.Widget gtk_frame_box_new (string label, out unowned Gtk.Widget container_return);
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static unowned Gtk.Widget gtk_frame_box_new_with_content (string label, Gtk.Widget content);
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static void gtk_window_center_on_active_screen (Gtk.Window window);
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h", cname = "libxfce4ui_check_version")]
	public static unowned string libxfce4ui_check_version (uint required_major, uint required_minor, uint required_micro);
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static int message_dialog (Gtk.Window parent, string title, string stock_id, string primary_text, string secondary_text, ...);
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static unowned Gtk.Widget message_dialog_new (Gtk.Window parent, string title, string stock_id, string primary_text, string secondary_text, ...);
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static unowned Gtk.Widget message_dialog_new_valist (Gtk.Window parent, string title, string icon_stock_id, string primary_text, string secondary_text, string first_button_text, void* args);
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static bool spawn_command_line_on_screen (Gdk.Screen screen, string command_line, bool in_terminal, bool startup_notify) throws GLib.Error;
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static bool spawn_on_screen (Gdk.Screen screen, string working_directory, string argv, string envp, GLib.SpawnFlags flags, bool startup_notify, uint32 startup_timestamp, string startup_icon_name) throws GLib.Error;
	[CCode (cheader_filename = "libxfce4ui/libxfce4ui.h")]
	public static bool spawn_on_screen_with_child_watch (Gdk.Screen screen, string working_directory, string argv, string envp, GLib.SpawnFlags flags, bool startup_notify, uint32 startup_timestamp, string startup_icon_name, GLib.Closure child_watch_closure) throws GLib.Error;
}
