import 'package:poultry_pal/consts/consts.dart';

Widget loadingIndicator() {
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(redColor),
  );
}
