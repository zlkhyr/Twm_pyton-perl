import os
import requests
from bs4 import BeautifulSoup as sp

# Author: Zul Akhyar
# Npm   : 2008107010080
# Department of Informatics
# College of Science, Syiah Kuala Univ

# kategori    : kategori dari berita {}
# tgl_akhir   : berita sapai dengan tanggal berapa yang akan di download
# bulan       : bulan
# tahun       : tahun

def downloadPage(kategori, tgl_akhir, bulan, tahun):
    # iterasi dimulai tanggal 1
    tgl = 1 
    while tgl <= tgl_akhir:
        # untuk tiap tanggal iterasi dari page 1
        page = 1 
        # selama list_berita punya lenght ambil list_berita dari page tertentu
        while True:
            # http request untuk mengekstak list berita
            response = requests.get(f"https://indeks.kompas.com/?site={kategori}&date={tahun}-{bulan}-{tgl}&page={page}").text
            # mem-parsing respon HTML menggunakan parser lxml.
            parser = sp(response,'lxml')
            # ambil list berita
            list_berita = parser.select('div.articleItem')
            
            #cek apakah ada list berita pada page tertentu
            if not list_berita:
                break
            # iterasi dalam list_berita untuk mendownload berita
            for i in range(len(list_berita)):
                # http request untuk mendapatkan halaman berita
                req_berita = requests.get(list_berita[i].find('a').get('href'))
                # cek code status
                if req_berita.status_code == 200:
                    # ambil title untuk nama file nantinya
                    namaFile = list_berita[i].find('h2',{'class':'articleTitle'}).text.replace(" ","_").replace("/","_")
                    # simpan halaman html dalam file
                    with open(os.path.join("downloaded/kategori_2",f"{namaFile}"),"w") as file:
                        file.write(req_berita.text)
                else:# error jika code status tidak 200
                    print(f"Gagal utnuk mendownload. Error : {req_berita.status_code}")
            # pemberitahuan jika berita pada page tertentu telah semua di download
            print(f"page {page} Done!")
            page += 1 #lanjut page selanjutnya
        # pemberitahuan jika berita pada tanggal tertentu telah semua di download
        print(f"berita tanggal {tgl}/{bulan}/{tahun} Done!")
        tgl += 1 #lajut tanggal selanjutnya


downloadPage("properti", 30, 9, 2023)