// add_ternak_modal
using Gtk;
using GLib;
using Gee;

namespace AslisGtk {
    [GtkTemplate (ui = "/aslis/dpbo/id/pages/add_modal.ui")]
    public class AddTernakModal : Gtk.ApplicationWindow {

        // Entries
        [GtkChild]
        private unowned Gtk.Entry namaTernakEntry;
        [GtkChild]
        private unowned Gtk.Entry umurTernakEntry;
        [GtkChild]
        private unowned Gtk.Entry beratTernakEntry;
        [GtkChild]
        private unowned Gtk.ComboBoxText genderTernakComboBox;
        [GtkChild]
        private unowned Gtk.Entry tempatLahirTernakEntry;

        // Button
        [GtkChild]
        private unowned Gtk.Button createButton;
        [GtkChild]
        private unowned Gtk.Button cancelButton;

        // Label
        [GtkChild]
        private unowned Gtk.Label resultLabel;

        public AddTernakModal (Gtk.Window parentWindow) {
            var cssProvider = new Gtk.CssProvider ();
            cssProvider.load_from_resource ("/aslis/dpbo/id/style/add_modal.css");
            Gtk.StyleContext.add_provider_for_display (Gdk.Display.get_default (), cssProvider, 1);

            Object(application: parentWindow.application);
            set_transient_for(parentWindow);

            genderTernakComboBox.set_active (0);
            
            cancelButton.clicked.connect (cancelHandler);

            createButton.clicked.connect (createHandler);
        }

        public void cancelHandler () {
            this.close();
        }

        public void createHandler () {
            ArrayList<string> genderList = new ArrayList<string>();
            genderList.add("Pilih");
            genderList.add("Jantan");
            genderList.add("Betina");

            string nama = namaTernakEntry.text;
            string umur = umurTernakEntry.text;
            string berat = beratTernakEntry.text;
            string gender = genderList[genderTernakComboBox.get_active()];
            string tempatLahir = tempatLahirTernakEntry.text;

            // Check if "Pilih" is the one chosen
            if (gender == "Pilih") {
                resultLabel.set_text ("Please choose the gender");
                return;
            }

            // Check if any of the required fields is empty
            if ((nama == null || nama.length == 0) || (umur == null || umur.length == 0) || 
                (berat == null || berat.length == 0) || (gender == null || gender.length == 0) ||
                (tempatLahir == null || tempatLahir.length == 0)) {

                resultLabel.label = "Please fill in all required fields.";
                return;
            }

            if (saveTernak(nama, umur, berat, gender, tempatLahir)) {
                resultLabel.set_label("Insert Ternak succesful");
                
                this.close();
            } else {
                resultLabel.set_label("Inserting Fail");
                return;
            }
        }

        public bool saveTernak (string nama, string umur, string berat, string gender, string tempatLahir) {
            string path = "src/database/ternak.csv";
            File file = File.new_for_path (path);

            try {
                int id = getLastId ();

                bool fileExists = file.query_exists();

                GLib.FileOutputStream os = file.append_to(GLib.FileCreateFlags.NONE);
        
                if (!fileExists) {
                    // Create a new file and write the header
                    string header = "{id},{nama},{umur},{berat},{gender},{tempat_lahir}\n";
                    uint8[] headerBytes = header.data;
                    os.write(headerBytes, null);
                }

                // Create a new line with username and password
                string ternakLine = "%d,%s,%s,%s,%s,%s\n".printf(id + 1, nama, umur, berat, gender, tempatLahir);
                uint8[] dataBytes = ternakLine.data;

                // Write the new line to the file
                os.write (dataBytes, null);
                return true; // Registration successful
            } catch (Error e) {
                print ("Error: %s\n", e.message);
            }

            return false; 
        }

        public int getLastId () {
            try {
                string path = "src/database/ternak.csv";
                File file = File.new_for_path (path);
        
                if (file.query_exists ()) {
                    var @is = file.read ();
                    var dis = new DataInputStream (@is);
        
                    string line = null;
                    string lastLine = null;
        
                    while ((line = dis.read_line ()) != null) {
                        lastLine = line;
                    }
        
                    // Check if the file is not empty
                    if (lastLine != null) {
                        string[] fields = lastLine.split (",");
        
                        if (fields.length > 0) {
                            // Check if the last line is the header line
                            if (fields[0] == "id" && fields.length >= 6) {
                                return 0;
                            }
        
                            int lastId = int.parse (fields[0]);
                            return lastId;
                        }
                    }
                }
            } catch (Error e) {
                warning ("Error reading last ID from CSV: %s", e.message);
            }
        
            // Default to 1 if the CSV file is empty or doesn't exist
            return 0;
        }
    }
}