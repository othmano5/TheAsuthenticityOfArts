import 'package:flutter_riverpod/flutter_riverpod.dart';

final usersPassedSectionsProvider = NotifierProvider<
    UsersPassedSectionsController, List<PassedSectionCertificate>>(
  UsersPassedSectionsController.new,
);

class PassedSectionCertificate {
  const PassedSectionCertificate({
    required this.sectionTitle,
    required this.score,
    required this.totalQuestions,
    this.certificatePdfPath,
  });

  final String sectionTitle;
  final int score;
  final int totalQuestions;
  final String? certificatePdfPath;

  int get percentage => ((score / totalQuestions) * 100).round();

  PassedSectionCertificate copyWith({
    String? sectionTitle,
    int? score,
    int? totalQuestions,
    String? certificatePdfPath,
    bool clearPdfPath = false,
  }) {
    return PassedSectionCertificate(
      sectionTitle: sectionTitle ?? this.sectionTitle,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      certificatePdfPath:
          clearPdfPath ? null : certificatePdfPath ?? this.certificatePdfPath,
    );
  }
}

class UsersPassedSectionsController
    extends Notifier<List<PassedSectionCertificate>> {
  @override
  List<PassedSectionCertificate> build() => const [];

  void markSectionAsPassed({
    required String sectionTitle,
    required int score,
    required int totalQuestions,
    String? certificatePdfPath,
  }) {
    final percentage = (score / totalQuestions) * 100;
    if (percentage < 60) {
      return;
    }

    final existingIndex = state.indexWhere(
      (item) => item.sectionTitle == sectionTitle,
    );

    if (existingIndex == -1) {
      state = [
        ...state,
        PassedSectionCertificate(
          sectionTitle: sectionTitle,
          score: score,
          totalQuestions: totalQuestions,
          certificatePdfPath: certificatePdfPath,
        ),
      ];
      return;
    }

    final existing = state[existingIndex];
    if (score <= existing.score) {
      return;
    }

    final updated = [...state];
    updated[existingIndex] = existing.copyWith(
      score: score,
      totalQuestions: totalQuestions,
      certificatePdfPath: certificatePdfPath,
    );
    state = updated;
  }
}
