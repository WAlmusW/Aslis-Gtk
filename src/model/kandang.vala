using Gee;

public class Kandang {
    public ArrayList<Ternak> list_ternak;

    public Kandang () {
        list_ternak = new ArrayList<Ternak>();
    }

    public void add (string nama, string umur, int berat, int gender, string tempat_lahir) {
        Ternak ternak = new Ternak(nama, umur, berat, gender, tempat_lahir);
        list_ternak.add(ternak);
    }

    public void delete (string nama) {
        for (int i = 0; i < list_ternak.size; i++) {
            if (list_ternak[i].nama == nama) {
                list_ternak.remove_at(i);
                break;
            }
        }
    }

    public int count () {
        return list_ternak.size;
    }
}