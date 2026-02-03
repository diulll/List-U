import 'package:flutter/material.dart';

void main() {
  runApp(const AplikasiTodoList());
}

class AplikasiTodoList extends StatelessWidget {
  const AplikasiTodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To-Do List Keren',
      theme: ThemeData(
        useMaterial3: true, 
        colorSchemeSeed: Colors.indigo, 
        brightness: Brightness.light,
      ),
      home: const HalamanUtama(),
    );
  }
}

class HalamanUtama extends StatefulWidget {
  const HalamanUtama({super.key});

  @override
  State<HalamanUtama> createState() => _HalamanUtamaState();
}

class _HalamanUtamaState extends State<HalamanUtama> {
  // Ini tempat menyimpan daftar tugas kita
  final List<Map<String, dynamic>> _daftarTugas = [];
  
  final TextEditingController _controller = TextEditingController();

  // Fungsi menambah tugas baru
  void _tambahTugas(String judul) {
    setState(() {
      _daftarTugas.add({'judul': judul, 'selesai': false});
    });
    _controller.clear();
    Navigator.of(context).pop(); // Tutup dialog setelah simpan
  }

  // Fungsi mencoret tugas (selesai/belum)
  void _ubahStatusTugas(int index) {
    setState(() {
      _daftarTugas[index]['selesai'] = !_daftarTugas[index]['selesai'];
    });
  }

  // Fungsi menghapus tugas
  void _hapusTugas(int index) {
    setState(() {
      _daftarTugas.removeAt(index);
    });
  }
  void _tampilkanDialogTambah() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Tambah Tugas Baru"),
        content: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Mau ngerjain apa hari ini?",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Batal"),
          ),
          FilledButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                _tambahTugas(_controller.text);
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Daily Tasks",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      // Tampilkan gambar kosong jika tidak ada tugas
      body: _daftarTugas.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.task_alt_rounded, 
                    size: 100, 
                    color: Colors.grey.shade300
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Belum ada tugas, santai dulu!",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _daftarTugas.length,
              itemBuilder: (context, index) {
                final tugas = _daftarTugas[index];
                return Dismissible(
                  key: UniqueKey(), // Kunci unik untuk fitur swipe
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.red.shade400,
                    ),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _hapusTugas(index),
                  child: Card(
                    elevation: 0,
                    color: tugas['selesai'] 
                        ? Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5)
                        : Theme.of(context).colorScheme.surfaceVariant,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Checkbox(
                        value: tugas['selesai'],
                        shape: const CircleBorder(),
                        onChanged: (_) => _ubahStatusTugas(index),
                      ),
                      title: Text(
                        tugas['judul'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: tugas['selesai']
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: tugas['selesai'] ? Colors.grey : Colors.black87,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.grey),
                        onPressed: () => _hapusTugas(index),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tampilkanDialogTambah,
        label: const Text("Tambah"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}