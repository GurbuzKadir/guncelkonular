import 'dart:convert';

import 'package:xrandom/xrandom.dart';
import 'dart:math';
import 'package:encrypt/encrypt.dart';
import 'dart:io';

File file = new File("random.txt");

// Xorshift rastgele sayı üreteci algoritması ve AES şifreleme algoritması kütüphane olarak eklendi.
// Kaynak kodları açık halde dosyalar içerisinde verildi.
// Uyarı : Kaynak kodları tek başına çalışamaz.
main() {
  Random xrandom32 = Xorshift32(); // Xorshift32 => 32 bit rastgele sayı üreteci
  Random xrandom128p =
      Xorshift128p(); // Xorshift128+ => 128 bit rastgele sayı üreteci
  Random xorshiro128pp =
      Xoshiro128pp(); //Xoshiro128pp => 128 bit güçlendirilmiş rastgele sayı üreteci

  var a32 = xrandom32.nextBool();
  var b32 = xrandom32.nextDouble();
  var c32 = xrandom32.nextInt(100);

  var a128p = xrandom128p.nextBool();
  var b128p = xrandom128p.nextDouble();
  var c128p = xrandom128p.nextInt(100);

  var a128pp = xorshiro128pp.nextBool();
  var b128pp = xorshiro128pp.nextDouble();
  var c128pp = (xorshiro128pp.nextInt(100000000)) + 100000;
  var dizi=[];

  print("1 milyon bit üreteci");
  //1 milyon üreteç
  var a128pp_ml="";
  file.writeAsStringSync("", mode: FileMode.write);
  for(var i=0;i<1000000;i++){
    a128pp_ml=xorshiro128pp.nextInt(2).toString();
    //burada
    dizi.add(a128pp_ml);
    print(a128pp_ml +" "+i.toString());
  }
  //todo > dosya xorshift proje dosyası içerisine random.txt olarak kayıt edilir.
  //todo > her seferinde dosya temizlenir tekrar yazılır
  //todo > tüm testler yapıldı ve random sayı üreteci testlerinden geçti.
  //burada
  file.writeAsStringSync("${(dizi.toString().replaceAll(",", "").replaceAll("[", "").replaceAll("]", ""))}", mode: FileMode.append);
  print('Rastgele sayı üreteci');
  print('-----------------------------------------------------------');
  print('--> Xorshift32 <--');
  print(a32);
  print(b32);
  print(c32);
  print('--> Xorshift128+ <--');
  print(a128p);
  print(b128p);
  print(c128p);
  print('--> Xoshiro128++ <--');
  print(a128pp);
  print(b128pp);
  print(c128pp);
  print('-----------------------------------------------------------');

  final text = 'Merhaba bu bir deneme yazısıdır.';
  final key = Key.fromUtf8('B896AE00A730A4962DB1C26729243E4B'); //32 bit Key
  final iv = IV.fromLength(16);

  final encrypter = Encrypter(AES(key));

  final encrypted = encrypter.encrypt(text, iv: iv);
  final decrypted = encrypter.decrypt(encrypted, iv: iv);
  final encrypted2 = encrypter.encrypt(c128pp.toString(), iv: iv);
  final decrypted2 = encrypter.decrypt(encrypted2, iv: iv);


  print('');
  print('AES şifreleme');
  print('-----------------------------------------------------------');
  print('Normal yazı şifreleme');
  print(decrypted);
  print(encrypted.base64);
  print('Üretilen random sayıyı şifreleme');
  print(decrypted2);
  print(encrypted2.base64);
  print('---------------------------son--------------------------------');
}
