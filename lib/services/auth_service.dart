import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';
import '../utils/validators.dart';
import 'auth_exception.dart';

/// Autenticação local com SharedPreferences.
///
/// Os nomes dos métodos são os mesmos do FirebaseAuth
/// (createUserWithEmailAndPassword, signInWithEmailAndPassword, signOut,
/// currentUser), então trocar pelo Firebase depois muda pouco nas telas.
///
/// SharedPreferences é um armazenamento chave-valor simples e limitado,
/// por isso guardamos só UM usuário: cada cadastro substitui o anterior.
class AuthService {
  AuthService._(this._prefs);

  static const _kUser = 'auth.user';
  static const _kPasswordHash = 'auth.passwordHash';
  static const _kSalt = 'auth.salt';
  static const _kSignedIn = 'auth.signedIn';

  static final _random = Random.secure();

  final SharedPreferences _prefs;

  static Future<AuthService> create() async {
    return AuthService._(await SharedPreferences.getInstance());
  }

  /// Usuário logado, ou null se ninguém entrou (igual ao Firebase).
  AppUser? get currentUser {
    final signedIn = _prefs.getBool(_kSignedIn) ?? false;
    return signedIn ? _storedUser : null;
  }

  AppUser? get _storedUser {
    final json = _prefs.getString(_kUser);
    if (json == null) return null;
    return AppUser.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  /// Cadastra e já deixa o usuário logado (o Firebase faz o mesmo).
  /// Sobrescreve qualquer cadastro anterior.
  Future<AppUser> createUserWithEmailAndPassword({
    required String displayName,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (!Validators.isValidEmail(normalizedEmail)) {
      throw const AuthException('invalid-email');
    }
    if (password.length < Validators.minPasswordLength) {
      throw const AuthException('weak-password');
    }

    final now = DateTime.now();
    final user = AppUser(
      uid: _generateUid(),
      email: normalizedEmail,
      displayName: displayName.trim(),
      creationTime: now,
      lastSignInTime: now,
    );

    // A senha nunca é salva: guardamos só o hash com um salt aleatório.
    final salt = _generateSalt();
    await _prefs.setString(_kUser, jsonEncode(user.toJson()));
    await _prefs.setString(_kSalt, salt);
    await _prefs.setString(_kPasswordHash, _hash(password, salt));
    await _prefs.setBool(_kSignedIn, true);
    return user;
  }

  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (!Validators.isValidEmail(normalizedEmail)) {
      throw const AuthException('invalid-email');
    }

    final user = _storedUser;
    final salt = _prefs.getString(_kSalt);
    final savedHash = _prefs.getString(_kPasswordHash);

    // Mesma mensagem para e-mail inexistente e senha errada, como o Firebase
    // faz hoje: assim ninguém descobre quais e-mails estão cadastrados.
    if (user == null ||
        salt == null ||
        savedHash == null ||
        user.email != normalizedEmail ||
        _hash(password, salt) != savedHash) {
      throw const AuthException('invalid-credential');
    }

    final updated = user.copyWith(lastSignInTime: DateTime.now());
    await _prefs.setString(_kUser, jsonEncode(updated.toJson()));
    await _prefs.setBool(_kSignedIn, true);
    return updated;
  }

  /// Sai da conta, mas mantém o cadastro salvo para o próximo login.
  Future<void> signOut() async {
    await _prefs.setBool(_kSignedIn, false);
  }

  String _hash(String password, String salt) {
    return sha256.convert(utf8.encode('$salt$password')).toString();
  }

  String _generateSalt() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    return base64UrlEncode(bytes);
  }

  /// 28 caracteres alfanuméricos, mesmo formato do uid do Firebase.
  String _generateUid() {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    return List.generate(28, (_) => chars[_random.nextInt(chars.length)])
        .join();
  }
}
