import 'package:deacon_school_admin/Core/services/drive_link.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DriveLink extracts id from a share link', () {
    const url =
        'https://drive.google.com/file/d/1A2b3C4d5E6f7G8h9I0jKlMnOpQr/view?usp=sharing';
    expect(DriveLink.extractId(url), '1A2b3C4d5E6f7G8h9I0jKlMnOpQr');
    expect(DriveLink.toDirectDownload(url),
        'https://drive.google.com/uc?export=download&id=1A2b3C4d5E6f7G8h9I0jKlMnOpQr');
    expect(DriveLink.isValid(url), isTrue);
    expect(DriveLink.isValid('not a link'), isFalse);
  });
}
