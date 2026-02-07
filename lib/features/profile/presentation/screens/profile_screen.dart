import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_mate/core/constants/app_strings.dart';
import 'package:math_mate/core/constants/profile_avatars.dart';
import 'package:math_mate/features/profile/presentation/cubit/profile_cubit.dart';

/// Profile screen with form fields and avatar selection.
///
/// This is the first [StatefulWidget] in the settings flow because
/// it manages [TextEditingController] lifecycle and form state.
///
/// Key concepts demonstrated:
/// - [Form] + [GlobalKey<FormState>] for collective validation
/// - [TextFormField] with `validator` callbacks
/// - [TextEditingController] lifecycle (init/dispose)
/// - [AutovalidateMode] (disabled → onUserInteraction after submit)
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _schoolController;

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  ProfileAvatar? _selectedAvatar;
  bool _avatarError = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<ProfileCubit>().state;
    _nameController = TextEditingController(text: state.name);
    _emailController = TextEditingController(text: state.email);
    _schoolController = TextEditingController(text: state.school);
    _selectedAvatar = state.avatar;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profileTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: AppStrings.profileName,
                  hintText: AppStrings.profileNameHint,
                ),
                textInputAction: TextInputAction.next,
                validator: _validateName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: AppStrings.profileEmail,
                  hintText: AppStrings.profileEmailHint,
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: _validateEmail,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _schoolController,
                decoration: const InputDecoration(
                  labelText: AppStrings.profileSchool,
                  hintText: AppStrings.profileSchoolHint,
                ),
                textInputAction: TextInputAction.done,
                validator: _validateSchool,
              ),
              const SizedBox(height: 24),
              Text(
                AppStrings.profileAvatar,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (_avatarError)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    AppStrings.profileAvatarRequired,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              _buildAvatarGrid(),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _onSave,
                child: const Text(AppStrings.profileSave),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarGrid() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: ProfileAvatar.values.map((avatar) {
        final isSelected = _selectedAvatar == avatar;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedAvatar = avatar;
              _avatarError = false;
            });
          },
          child: Semantics(
            label: avatar.displayName,
            selected: isSelected,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
              child: Icon(
                avatar.icon,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _onSave() {
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
      _avatarError = _selectedAvatar == null;
    });

    final isFormValid =
        _formKey.currentState?.validate() ?? false;
    if (!isFormValid || _selectedAvatar == null) return;

    unawaited(
      context.read<ProfileCubit>().saveProfile(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            school: _schoolController.text.trim(),
            avatar: _selectedAvatar,
          ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(AppStrings.profileSaved),
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.profileNameRequired;
    }
    final trimmed = value.trim();
    if (trimmed.length < 2) {
      return AppStrings.profileNameTooShort;
    }
    if (trimmed.length > 50) {
      return AppStrings.profileNameTooLong;
    }
    final nameRegExp = RegExp(r'^[a-zA-Z\s\-]+$');
    if (!nameRegExp.hasMatch(trimmed)) {
      return AppStrings.profileNameInvalid;
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.profileEmailRequired;
    }
    final emailRegExp = RegExp(
      r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
    );
    if (!emailRegExp.hasMatch(value.trim())) {
      return AppStrings.profileEmailInvalid;
    }
    return null;
  }

  String? _validateSchool(String? value) {
    if (value != null && value.trim().length > 100) {
      return AppStrings.profileSchoolTooLong;
    }
    return null;
  }
}
