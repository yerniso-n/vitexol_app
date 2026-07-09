import 'package:flutter_test/flutter_test.dart';
import 'package:vitexol_app/main.dart';

void main() {
  testWidgets('La pantalla inicial muestra VITEXOL',
          (WidgetTester tester) async {
        await tester.pumpWidget(const VitexolApp());

        expect(find.text('VITEXOL'), findsOneWidget);
        expect(find.text('Iniciar sesión'), findsOneWidget);
        expect(find.text('Crear una cuenta'), findsOneWidget);
      });
}