import 'package:live_shop/app/app.dart';
import 'package:live_shop/bootstrap.dart';

Future<void> main() async {
  await bootstrap(() => const App());
}
