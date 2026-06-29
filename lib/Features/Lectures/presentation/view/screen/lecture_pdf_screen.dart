import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../Core/models/lecture.dart';
import '../../../../../Core/services/drive_link.dart';
import '../../../../../Core/translations/locale_keys.g.dart';
import '../../../../../Core/widget/app_dialogs.dart';

class LecturePdfScreen extends StatelessWidget {
  final Lecture lecture;
  const LecturePdfScreen({super.key, required this.lecture});

  @override
  Widget build(BuildContext context) {
    final url = lecture.pdfUrl ?? '';
    final directUrl = DriveLink.toDirectDownload(url);

    return Scaffold(
      appBar: AppBar(
        title: Text(lecture.title),
        actions: [
          IconButton(
            tooltip: LocaleKeys.openInBrowser.tr(),
            icon: const Icon(Icons.open_in_new_rounded),
            onPressed: () async {
              final preview = DriveLink.toPreview(url);
              final uri = Uri.tryParse(preview);
              if (uri != null &&
                  !await launchUrl(uri,
                      mode: LaunchMode.externalApplication)) {
                if (context.mounted) {
                  AppDialogs.snack(context, LocaleKeys.cannotOpenLink.tr(),
                      error: true);
                }
              }
            },
          ),
        ],
      ),
      body: url.isEmpty
          ? Center(child: Text(LocaleKeys.mediaNotAvailable.tr()))
          : PdfViewer.uri(
              Uri.parse(directUrl),
              params: PdfViewerParams(
                loadingBannerBuilder: (context, bytes, total) =>
                    const Center(child: CircularProgressIndicator()),
                errorBannerBuilder: (context, error, stack, docRef) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline_rounded, size: 56),
                        const SizedBox(height: 12),
                        Text(LocaleKeys.somethingWentWrong.tr(),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () async {
                            final uri =
                                Uri.tryParse(DriveLink.toPreview(url));
                            if (uri != null) {
                              await launchUrl(uri,
                                  mode: LaunchMode.externalApplication);
                            }
                          },
                          icon: const Icon(Icons.open_in_new_rounded),
                          label: Text(LocaleKeys.openInBrowser.tr()),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
