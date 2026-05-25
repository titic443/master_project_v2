

```text
customer_01_title_dropdown = "Mr"  
customer_02_firstname_textfield.valid = "นายทดสอบ valid"  
customer_02_firstname_textfield.invalid = "นายทดสอบ invalid"  
IF [customer_04_agree_terms_checkbox] = "checked" THEN customer_02_firstname_textfield = "valid"
```

```text
    customer_01_title_dropdown: "Mr.", "Mrs.", "Ms", "Dr"
    customer_02_firstname_textfield: valid, invalid
    customer_03_phone_textfield: valid, invalid
    customer_04_agree_terms_checkbox: checked, unchecked

    IF [customer_04_agree_terms_checkbox] = "checked" THEN customer_02_firstname_textfield = "valid"
```


```dart
        testWidgets('pairwise_valid_invalid_cases_1', (tester) async {
        final providers = <BlocProvider>[
            BlocProvider<PropertySearchCubit>(create: (_) => PropertySearchCubit()),
        ];
        final w = MaterialApp(home: MultiBlocProvider(providers: providers, child: PropertySearchPage()));
        await tester.pumpWidget(w);
        // dataset: byKey.search_01_location_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_01_location_textfield')), 'X');
        await tester.pump();
        await tester.ensureVisible(find.byKey(const Key('search_02_type_dropdown')));
        await tester.tap(find.byKey(const Key('search_02_type_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('บ้านเดี่ยว').last);
        await tester.tap(find.text('บ้านเดี่ยว').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.tap(find.byKey(const Key('search_03_bedrooms_dropdown')));
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('3').last);
        await tester.tap(find.text('3').last);
        await tester.pumpAndSettle();
        await tester.pumpAndSettle();
        // dataset: byKey.search_04_min_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_04_min_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_05_max_price_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_05_max_price_textfield')), '');
        await tester.pump();
        // dataset: byKey.search_06_min_area_textfield[0].invalid
        await tester.enterText(find.byKey(const Key('search_06_min_area_textfield')), '0');
        await tester.pump();
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.byKey(const Key('search_08_end_button')));
        await tester.tap(find.byKey(const Key('search_08_end_button')));
        await tester.pumpAndSettle();
        });

```