import 'package:flutter/material.dart';

/// Available avatar options for the user profile.
///
/// Each avatar maps to a Material Icon that students can choose
/// to personalize their profile.
enum ProfileAvatar {
  /// Default person icon.
  person,

  /// Smiling face icon.
  face,

  /// Graduation cap icon.
  school,

  /// Star icon.
  star,

  /// Rocket launch icon.
  rocket,

  /// Pets/paw icon.
  pets,

  /// Gaming controller icon.
  sportsEsports,

  /// Music note icon.
  musicNote,

  /// Paint brush icon.
  brush,

  /// Science flask icon.
  science,
}

/// Extension to provide display properties for each avatar.
extension ProfileAvatarValues on ProfileAvatar {
  /// The Material Icon for this avatar.
  IconData get icon {
    switch (this) {
      case ProfileAvatar.person:
        return Icons.person;
      case ProfileAvatar.face:
        return Icons.face;
      case ProfileAvatar.school:
        return Icons.school;
      case ProfileAvatar.star:
        return Icons.star;
      case ProfileAvatar.rocket:
        return Icons.rocket_launch;
      case ProfileAvatar.pets:
        return Icons.pets;
      case ProfileAvatar.sportsEsports:
        return Icons.sports_esports;
      case ProfileAvatar.musicNote:
        return Icons.music_note;
      case ProfileAvatar.brush:
        return Icons.brush;
      case ProfileAvatar.science:
        return Icons.science;
    }
  }

  /// Display name for accessibility labels.
  String get displayName {
    switch (this) {
      case ProfileAvatar.person:
        return 'Person';
      case ProfileAvatar.face:
        return 'Face';
      case ProfileAvatar.school:
        return 'School';
      case ProfileAvatar.star:
        return 'Star';
      case ProfileAvatar.rocket:
        return 'Rocket';
      case ProfileAvatar.pets:
        return 'Pets';
      case ProfileAvatar.sportsEsports:
        return 'Gaming';
      case ProfileAvatar.musicNote:
        return 'Music';
      case ProfileAvatar.brush:
        return 'Art';
      case ProfileAvatar.science:
        return 'Science';
    }
  }
}
