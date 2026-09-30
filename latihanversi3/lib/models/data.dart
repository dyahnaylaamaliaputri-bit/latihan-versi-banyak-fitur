//Membuat kelas user untuk menyimpan data user untuk login
class User {
  String username;
  String password;
  String nama;

  User({
    required this.username,
    required this.password,
    required this.nama,
  }); //syarat kalo mau membuat objek
}

User user1 = User(
  username: 'Nayla',
  password: 'nayla123',
  nama: 'Dyah Nayla',
);
