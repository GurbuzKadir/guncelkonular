part of encrypt;

class Encrypter {
  final Algorithm algo;

  Encrypter(this.algo);

  Encrypted encryptBytes(List<int> input, {IV? iv, Uint8List? associatedData}) {
    if (input is Uint8List) {
      return algo.encrypt(input, iv: iv, associatedData: associatedData);
    }

    return algo.encrypt(
      Uint8List.fromList(input),
      iv: iv,
      associatedData: associatedData,
    );
  }

  Encrypted encrypt(
    String input, {
    IV? iv,
    Uint8List? associatedData,
  }) {
    return encryptBytes(
      convert.utf8.encode(input),
      iv: iv,
      associatedData: associatedData,
    );
  }

  List<int> decryptBytes(Encrypted encrypted,
      {IV? iv, Uint8List? associatedData}) {
    return algo
        .decrypt(encrypted, iv: iv, associatedData: associatedData)
        .toList();
  }

  String decrypt(
    Encrypted encrypted, {
    IV? iv,
    Uint8List? associatedData,
  }) {
    return convert.utf8.decode(
      decryptBytes(encrypted, iv: iv, associatedData: associatedData),
      allowMalformed: true,
    );
  }

  String decrypt16(String encoded, {IV? iv, Uint8List? associatedData}) {
    return decrypt(
      Encrypted.fromBase16(encoded),
      iv: iv,
      associatedData: associatedData,
    );
  }

  String decrypt64(String encoded, {IV? iv, Uint8List? associatedData}) {
    return decrypt(
      Encrypted.fromBase64(encoded),
      iv: iv,
      associatedData: associatedData,
    );
  }
}
