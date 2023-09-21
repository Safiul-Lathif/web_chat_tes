import 'dart:convert';

class ProfileSwap {
  final String token, tag, role;

  ProfileSwap({
    required this.token,
    required this.tag,
    required this.role,
  });

  factory ProfileSwap.fromJson(Map<String, dynamic> jsonData) {
    return ProfileSwap(
      token: jsonData['token'],
      tag: jsonData['tag'],
      role: jsonData['role'],
    );
  }

  static Map<String, dynamic> toMap(ProfileSwap profileDetail) => {
        'token': profileDetail.token,
        'tag': profileDetail.tag,
        'role': profileDetail.role,
      };

  static String encode(List<ProfileSwap> profileDetails) => json.encode(
        profileDetails
            .map<Map<String, dynamic>>(
                (profileDetails) => ProfileSwap.toMap(profileDetails))
            .toList(),
      );

  static List<ProfileSwap> decode(String profileDetails) =>
      (json.decode(profileDetails) as List<dynamic>)
          .map<ProfileSwap>((item) => ProfileSwap.fromJson(item))
          .toList();
}
