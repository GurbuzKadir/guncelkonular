part of encrypt;

class Encrypted {
  Encrypted(this._bytes);

  final Uint8List _bytes;

  Encrypted.fromBase16(String encoded) : _bytes = decodeHexString(encoded);

  Encrypted.fromBase64(String encoded)
      : _bytes = convert.base64.decode(encoded);

  Encrypted.from64(String encoded) : _bytes = convert.base64.decode(encoded);

  Encrypted.fromUtf8(String input)
      : _bytes = Uint8List.fromList(convert.utf8.encode(input));

  Encrypted.fromLength(int length) : _bytes = SecureRandom(length).bytes;

  Encrypted.fromSecureRandom(int length) : _bytes = SecureRandom(length).bytes;

  Encrypted.allZerosOfLength(int length) : _bytes = Uint8List(length);

  Uint8List get bytes => _bytes;

  String get base16 =>
      _bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();

  String get base64 => convert.base64.encode(_bytes);

  @override
  bool operator ==(other) {
    if (other is Encrypted) {
      return const ListEquality().equals(bytes, other.bytes);
    }

    return false;
  }
}

class IV extends Encrypted {
  IV(Uint8List bytes) : super(bytes);

  IV.fromBase16(String encoded) : super.fromBase16(encoded);

  IV.fromBase64(String encoded) : super.fromBase64(encoded);

  IV.fromUtf8(String input) : super.fromUtf8(input);

  IV.fromLength(int length) : super.fromLength(length);

  IV.fromSecureRandom(int length) : super(SecureRandom(length).bytes);

  IV.allZerosOfLength(int length) : super.allZerosOfLength(length);
}

class Key extends Encrypted {
  Key(Uint8List bytes) : super(bytes);

  Key.fromBase16(String encoded) : super.fromBase16(encoded);

  Key.fromBase64(String encoded) : super.fromBase64(encoded);

  Key.fromUtf8(String input) : super.fromUtf8(input);

  Key.fromLength(int length) : super.fromLength(length);

  Key.fromSecureRandom(int length) : super(SecureRandom(length).bytes);

  Key.allZerosOfLength(int length) : super.allZerosOfLength(length);

  Key stretch(int desiredKeyLength,
      {int iterationCount = 100, Uint8List? salt}) {
    if (salt == null) {
      salt = SecureRandom(desiredKeyLength).bytes;
    }

    final params = Pbkdf2Parameters(salt, iterationCount, desiredKeyLength);
    final pbkdf2 = PBKDF2KeyDerivator(Mac('SHA-1/HMAC'))..init(params);

    return Key(pbkdf2.process(_bytes));
  }

  int get length => bytes.lengthInBytes;
}
