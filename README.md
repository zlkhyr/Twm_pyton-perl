# Mendownload berita dari kompas.com dengan Python dan meng-extract title dan contentnya menggunakan Perl

## Cara mejalankan script python untuk mendownload file HTML
Edit script python dan sesuaikan path untuk menyimpan file yang akan di download
```sh
with open(os.path.join("path/ke/folder",f"{namaFile}"),"w") as file:
  file.write(req_berita.text)
```

Panggil fungsi downloadPage dan masukkan parameter sesuai dengan berita yang ingin di download
```sh
downloadPage(kategori, tanggal_akhir, bulan, tahun)
```

## Cara mejalankan script perl untuk membersihkan dan extract judul dan isi dari halaman web
Edit scipt dan sesuaikan path untuk menyimpan file hasil yang telah dibersihkan
```sh
my $PATHCLEAN = "/paht/ke/folder";
```

Run script python dengan argument file yang akan di bersihkan
```sh
perl extractcontent.pl path\ke\file
```
