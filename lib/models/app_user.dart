/// Usuário do app. Os campos seguem o `User` do Firebase Auth
/// (uid, email, displayName, emailVerified, metadata.creationTime e
/// metadata.lastSignInTime) para facilitar a troca pelo Firebase depois.
class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.emailVerified = false,
    required this.creationTime,
    required this.lastSignInTime,
  });

  final String uid;
  final String email;
  final String displayName;
  final bool emailVerified;
  final DateTime creationTime;
  final DateTime lastSignInTime;

  AppUser copyWith({DateTime? lastSignInTime}) {
    return AppUser(
      uid: uid,
      email: email,
      displayName: displayName,
      emailVerified: emailVerified,
      creationTime: creationTime,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
    );
  }

  /// SharedPreferences só guarda tipos simples, então salvamos como JSON.
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'emailVerified': emailVerified,
        'creationTime': creationTime.toIso8601String(),
        'lastSignInTime': lastSignInTime.toIso8601String(),
      };

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      emailVerified: json['emailVerified'] as bool? ?? false,
      creationTime: DateTime.parse(json['creationTime'] as String),
      lastSignInTime: DateTime.parse(json['lastSignInTime'] as String),
    );
  }
}
