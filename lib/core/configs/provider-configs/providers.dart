import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../../providers/auth_provider.dart';
import '../../../../providers/favorite_provider.dart';
import '../../../../providers/product_provider.dart';

class ProviderConfigs {
  static List<SingleChildWidget> providerDeclaration = [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => FavoriteProvider()),
  ];
}
