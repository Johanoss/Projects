import 'package:image_picker/image_picker.dart';

class UserModel {
  final String fName;
  final String lName;
  final String age;
  final String email;
  final String password;
  final String skills;
  final String hobbies;
  final String? bio;
  final String? imageUrl;
  final XFile? localImage;
  final String? backgroundImageUrl;
  final XFile? localBackgroundImage;
  final String? backgroundType;
  final String? backgroundValue;
  final double glassOpacity;
  final double glassBlur;
  final double glassBorderOpacity;
  final String? shadowColor;
  final double shadowOpacity;
  final double shadowBlur;
  final double shadowOffsetX;
  final double shadowOffsetY;

  const UserModel({
    required this.fName,
    required this.lName,
    required this.age,
    required this.email,
    required this.password,
    required this.skills,
    required this.hobbies,
    this.bio,
    this.imageUrl,
    this.localImage,
    this.backgroundImageUrl,
    this.localBackgroundImage,
    this.backgroundType = 'color',
    this.backgroundValue,
    this.glassOpacity = 0.3,
    this.glassBlur = 10,
    this.glassBorderOpacity = 0.2,
    this.shadowColor,
    this.shadowOpacity = 0.3,
    this.shadowBlur = 20,
    this.shadowOffsetX = 0,
    this.shadowOffsetY = 10,
  });

  UserModel copyWith({
    String? fName,
    String? lName,
    String? age,
    String? email,
    String? password,
    String? skills,
    String? hobbies,
    String? bio,
    String? imageUrl,
    XFile? localImage,
    String? backgroundImageUrl,
    XFile? localBackgroundImage,
    String? backgroundType,
    String? backgroundValue,
    double? glassOpacity,
    double? glassBlur,
    double? glassBorderOpacity,
    String? shadowColor,
    double? shadowOpacity,
    double? shadowBlur,
    double? shadowOffsetX,
    double? shadowOffsetY,
  }) {
    return UserModel(
      fName: fName ?? this.fName,
      lName: lName ?? this.lName,
      age: age ?? this.age,
      email: email ?? this.email,
      password: password ?? this.password,
      skills: skills ?? this.skills,
      hobbies: hobbies ?? this.hobbies,
      bio: bio ?? this.bio,
      imageUrl: imageUrl ?? this.imageUrl,
      localImage: localImage ?? this.localImage,
      backgroundImageUrl: backgroundImageUrl ?? this.backgroundImageUrl,
      localBackgroundImage: localBackgroundImage ?? this.localBackgroundImage,
      backgroundType: backgroundType ?? this.backgroundType,
      backgroundValue: backgroundValue ?? this.backgroundValue,
      glassOpacity: glassOpacity ?? this.glassOpacity,
      glassBlur: glassBlur ?? this.glassBlur,
      glassBorderOpacity: glassBorderOpacity ?? this.glassBorderOpacity,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOpacity: shadowOpacity ?? this.shadowOpacity,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      shadowOffsetX: shadowOffsetX ?? this.shadowOffsetX,
      shadowOffsetY: shadowOffsetY ?? this.shadowOffsetY,
    );
  }
}