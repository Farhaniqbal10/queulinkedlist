program Antrian;
uses crt, mmsystem, sysutils;
type
  PInfo = record
  antrian : String[8];
  end;
  PData = ^TData;
  TData = record

    info: PInfo;
    Next: PData;
  end;

var
  awal, akhir: PData;
  pilihan: integer;
  penghitung : integer;
  antrian_meja_1 : PInfo;
  nomor_antrian_meja_2 : PInfo;
  banyak_data : integer;

function parent(nomor_simpul : integer): integer;

begin
  parent := nomor_simpul div 2;
end;

function leftchild(nomor_simpul : integer): integer;
begin
  leftchild := nomor_simpul * 2;
end;

function rightchild(nomor_simpul : integer): integer;
begin
  rightchild := nomor_simpul * 2 + 1;
end;



function ambilNilaiDariHeap(n : integer) : PData;
var 
  bantu : PData;
  posisi : integer;
begin
  bantu := awal;
  posisi := 1;
  while (bantu <> akhir) and (posisi <> n) do
  begin
    bantu := bantu^.next;
    posisi := posisi + 1;
  end;  
  ambilNilaiDariHeap := bantu;
end;


procedure tukar(nomor_simpul1:integer;nomor_simpul2:integer);
var
  temp:PInfo;
begin
   temp := ambilNilaiDariHeap(nomor_simpul1)^.info;
   ambilNilaiDariHeap(nomor_simpul1)^.info := ambilNilaiDariHeap(nomor_simpul2)^.info;
   ambilNilaiDariHeap(nomor_simpul2)^.info := temp;
end;


procedure geser_ke_atas() ;
var
  nomor_simpul : integer;
begin
  nomor_simpul := banyak_data;
  while(nomor_simpul > 1) and ( ambilNilaiDariHeap(parent(nomor_simpul))^.info.antrian > ambilNilaiDariHeap(nomor_simpul)^.info.antrian ) do
  begin
    tukar(nomor_simpul, parent(nomor_simpul));
    nomor_simpul := parent(nomor_simpul);
  end;
end;


procedure buatHeap(nomor_simpul : integer);
begin
  if (ambilNilaiDariHeap(nomor_simpul)^.info.antrian > ambilNilaiDariHeap(leftchild(nomor_simpul))^.info.antrian)
     or
       (ambilNilaiDariHeap(nomor_simpul)^.info.antrian > ambilNilaiDariHeap(rightchild(nomor_simpul))^.info.antrian) then
  begin
    if (ambilNilaiDariHeap(leftchild(nomor_simpul))^.info.antrian < ambilNilaiDariHeap(rightchild(nomor_simpul))^.info.antrian ) then
    begin
      tukar(nomor_simpul, leftchild(nomor_simpul));
      buatHeap(leftchild(nomor_simpul));
    end
    else
    begin
      tukar(nomor_simpul, rightchild(nomor_simpul));
      buatHeap(rightchild(nomor_simpul));
    end;
  end;
end;


procedure reorganisasi;
var
  nomor_simpul : integer;
begin
  nomor_simpul := parent(banyak_data);
  while (nomor_simpul >= 1) do 
  begin
    buatHeap(nomor_simpul);
    nomor_simpul := nomor_simpul - 1;
  end;
end;


function hapus_antrian() : PInfo;
var
  pHapus : PData;
  info : PInfo;
begin
  info := awal^.info;
  if (awal = akhir) then
  begin
    Dispose(awal);
    awal := nil;
    akhir := nil;
  end
  else
  begin
    pHapus := awal;
    awal := awal^.Next;
    Dispose(pHapus);
  end;
  banyak_data := banyak_data - 1;
  hapus_antrian := info;
end;


procedure sisip_belakang( i:String; var awal, akhir:PData );
var
  baru:PData;
  begin
      new(baru);
      baru^.info.antrian :=i;
      baru^.next:=nil;
      if (awal=nil) then
          awal:=baru
      else  
        akhir^.next:=baru;
        akhir:=baru;
end;


procedure ambilAntrianBisnis();
var
  info : PInfo;
begin
  ClrScr;
  penghitung := penghitung + 1;
  banyak_data := banyak_data + 1;
  info.antrian := 'B'+IntToStr(penghitung);
  sisip_belakang(info.antrian, awal, akhir);
  geser_ke_atas();
  WriteLn('Nomor antrian anda : ', info.antrian);
  WriteLn('Tekan enter untuk melanjutkan.');
  readln();
end;

procedure ambilAntrianPersonal();
var
  info : PInfo;
begin
  ClrScr;
  penghitung := penghitung + 1;
  banyak_data := banyak_data + 1;
  info.antrian := 'P'+IntToStr(penghitung);
  sisip_belakang(info.antrian, awal, akhir);
  geser_ke_atas();
  WriteLn('Nomor antrian anda : ', info.antrian);
  WriteLn('Tekan enter untuk melanjutkan.');
  readln();
end;


function apakahkosong():boolean;
begin
  if awal = nil then
    apakahkosong := true
    else
    apakahkosong := false;
end;


procedure Meja1();
var 
  i : integer;
  namafile : string;
  Pnamafile : PChar;
begin
  ClrScr;
  if apakahkosong = true then
  begin
    WriteLn('Tidak ada antrian ');
  end
  else
  begin
    antrian_meja_1 := hapus_antrian;
    reorganisasi;
    WriteLn('Nomor antrian ',antrian_meja_1.antrian,' ke meja satu' );
    playsound('Nomorantrian.wav',0,0);
    if antrian_meja_1.antrian[1]='B' then
      playsound('B.wav',0,0)
    else
      playsound('p.wav',0,0);
    
    for i:= 2 to length(antrian_meja_1.antrian)do
    begin 
      namafile:=antrian_meja_1.antrian[i]+'.wav';
      Pnamafile:=StrAlloc(length(namafile));
      pnamafile:=StrPcopy(Pnamafile,namafile);
      playsound(PChar(Pnamafile),0,0);
    end;
    playsound('dimeja1.wav',0,0);
    end;
    WriteLn('tekan enter untuk melanjutkan ');
    ReadLn();
end;


procedure Meja2();
var 
  i : integer;
  namafile : String;
  Pnamafile : PChar;
begin
  ClrScr;
  if apakahkosong = true then
  begin
    WriteLn('Tidak ada antrian ');
  end
  else
  begin
    nomor_antrian_meja_2 := hapus_antrian;
    reorganisasi;
    WriteLn('Nomor antrian ',nomor_antrian_meja_2.antrian,' ke meja Dua' );
    playsound('Nomorantrian.wav',0,0);
    if nomor_antrian_meja_2.antrian[1]='B' then
      playsound('B.wav',0,0)
    else
      playsound('p.wav',0,0);
    
    for i:= 2 to length(nomor_antrian_meja_2.antrian)do 
    begin 
      namafile:=nomor_antrian_meja_2.antrian[i]+'.wav';
      Pnamafile:=StrAlloc(length(namafile));
      pnamafile:=StrPcopy(Pnamafile,namafile);
      playsound(pchar(Pnamafile),0,0);
    end;
    playsound('dimeja2.wav',0,0);
    end;
    WriteLn('tekan enter untuk melanjutkan ');
    ReadLn();
end;


function tampilMenu() : integer;
var
  pilihan : integer;
begin
    ClrScr;
    WriteLn('======= Aplikasi Antrian Bank Dengan Prioritas =======');
    WriteLn('Antrian Meja 1 : ', antrian_meja_1.antrian);
    WriteLn('Antrian Meja 2 : ', nomor_antrian_meja_2.antrian);
    if (awal <> nil) then WriteLn('Antrian selanjutnya : ', awal^.info.antrian);
    WriteLn('1. Daftar antrian bisnis');
    WriteLn('2. Daftar antrian personal');
    WriteLn('3. Panggil nomor antrian di meja 1');
    WriteLn('4. Panggil nomor antrian di meja 2');
    WriteLn('5. Keluar ');
    Writeln('==================== Kelompok 8 ======================');
    Write('Pilihan anda : ');
    ReadLn(pilihan);
    tampilMenu := pilihan;
end;


begin
  banyak_data := 0;

  awal := nil;
  akhir := nil;

  antrian_meja_1.antrian := '-';
  nomor_antrian_meja_2.antrian := '-';
  repeat
    pilihan := tampilMenu();
    case(pilihan) of 
      1 : ambilAntrianBisnis;
      2 : ambilAntrianPersonal;
      3 : Meja1;
      4 : Meja2;
    end;
  until pilihan = 5
end.
