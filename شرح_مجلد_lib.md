# شرح مجلد `lib` في تطبيق أصالة الفنون

هذا الملف مخصص لشرح كود تطبيق Flutter الموجود داخل مجلد `lib` بطريقة مناسبة للطلاب. الفكرة ليست حفظ الكود سطرا بسطر، بل فهم دور كل ملف وكيف تتعاون الملفات مع بعضها لتكوين تطبيق كامل.

## 1. الفكرة العامة للمشروع

التطبيق اسمه **أصالة الفنون**. وهو تطبيق Flutter عربي يستخدم:

- `MaterialApp.router` لبناء التطبيق مع نظام توجيه.
- `go_router` لإدارة الصفحات والمسارات.
- `flutter_riverpod` لإدارة الحالة مثل حالة تسجيل الدخول والتنقل السفلي.
- `reactive_forms` لبناء نماذج تسجيل الدخول وإنشاء الحساب والاختبار.
- `shared_preferences` لحفظ حالة الجلسة محليا.
- `dio` كطبقة جاهزة للتعامل مع API في المستقبل.

يمكن شرح المشروع للطلاب على أنه مقسم إلى ثلاث طبقات رئيسية:

- `core`: أشياء أساسية يحتاجها التطبيق كله مثل الثيم، الألوان، الشبكة، التخزين، والتوجيه.
- `features`: الميزات أو الشاشات الرئيسية مثل المصادقة، المستخدم، والمسؤول.
- `shared`: Widgets مشتركة يعاد استخدامها في أكثر من صفحة.

## 2. مسار تشغيل التطبيق من البداية

ابدأ الشرح من الملف `lib/main.dart` لأن Flutter يبدأ منه.

المسار العام هو:

1. تشغيل `main`.
2. تهيئة Flutter عبر `WidgetsFlutterBinding.ensureInitialized`.
3. تحميل `SharedPreferences`.
4. تشغيل التطبيق داخل `ProviderScope`.
5. تمرير نسخة `SharedPreferences` إلى Riverpod عبر override.
6. بناء `AuthenticityOfArtsApp`.
7. قراءة `routerProvider`.
8. عرض الصفحات حسب حالة تسجيل الدخول.

يمكن تبسيط ذلك للطلاب بهذا التشبيه:

> `main.dart` هو باب التطبيق. قبل أن يدخل المستخدم، نجهز الذاكرة المحلية، ثم نعطي التطبيق نظام إدارة الحالة، ثم نفتح أول صفحة حسب حالة الجلسة.

## 3. شرح ملفات البداية والتوجيه

### `lib/main.dart`

هذا هو ملف البداية في التطبيق.

أهم ما فيه:

- يستورد Flutter و Riverpod و SharedPreferences.
- الدالة `main` غير متزامنة لأنها تنتظر تحميل `SharedPreferences`.
- `ProviderScope` هو الحاوية التي تجعل Providers متاحة في كل التطبيق.
- `sharedPreferencesProvider.overrideWithValue(sharedPreferences)` يعني: بدل أن يكون مزود SharedPreferences فارغا، نعطيه النسخة الحقيقية.
- `AuthenticityOfArtsApp` يرث من `ConsumerWidget` حتى يستطيع قراءة providers.
- يستخدم `MaterialApp.router` بدلا من `MaterialApp` العادي لأن التطبيق يعتمد على GoRouter.
- التطبيق مضبوط على اللغة العربية:
  - `locale: const Locale('ar')`
  - `supportedLocales: const [Locale('ar')]`
  - `GlobalMaterialLocalizations.delegates`
- الثيم المستخدم هو `AppTheme.light()`.

نقطة مهمة للطلاب:

`ConsumerWidget` يشبه `StatelessWidget`، لكنه يستطيع استخدام `WidgetRef ref` لقراءة الحالة من Riverpod.

### `lib/core/route/router.dart`

هذا الملف مسؤول عن مسارات التطبيق.

يحتوي على enum اسمه `AppRoute`:

- `login('/')`
- `register('/register')`
- `admin('/admin')`
- `users('/users')`

كل قيمة تمثل صفحة ومسارها.

ثم يوجد `routerProvider` الذي ينشئ كائن `GoRouter`.

أهم جزء في هذا الملف هو `redirect`:

- إذا كان المستخدم غير مسجل الدخول وحاول الدخول إلى صفحة محمية، يرجعه إلى صفحة تسجيل الدخول.
- إذا كان المستخدم مسجلا الدخول وحاول فتح صفحة تسجيل الدخول أو إنشاء الحساب، ينقله إلى الصفحة المناسبة لدوره:
  - المستخدم العادي إلى `/users`
  - المسؤول إلى `/admin`

لشرحها للطلاب:

> `redirect` يعمل مثل حارس باب. يسأل: هل المستخدم مسجل؟ ما دوره؟ هل الصفحة مسموحة له؟

### `lib/core/not_found_page.dart`

صفحة تظهر عند فتح رابط غير موجود.

تستخدم:

- `Scaffold`
- `SafeArea`
- `Center`
- `ConstrainedBox`
- `DecoratedBox`
- زر `FilledButton` يرجع المستخدم إلى البداية.

الهدف منها تحسين تجربة المستخدم بدلا من ظهور شاشة خطأ فارغة.

## 4. شرح ملفات الحالة والجلسة

### `lib/features/auth/application/session_state.dart`

هذا الملف يصف حالة المستخدم.

يحتوي على enum اسمه `AppUserRole`:

- `guest`: زائر.
- `user`: مستخدم عادي.
- `admin`: مسؤول.

لكل دور ثلاث خصائص:

- `storageValue`: القيمة التي تحفظ في SharedPreferences.
- `label`: النص العربي المعروض.
- `homePath`: الصفحة التي يذهب إليها المستخدم بعد تسجيل الدخول.

ثم توجد class اسمها `SessionState` تحتوي:

- `isAuthenticated`: هل المستخدم مسجل الدخول؟
- `role`: دور المستخدم.
- `token`: رمز الدخول إن وجد.

الدالة `copyWith` مهمة لأنها تسمح بتغيير جزء من الحالة دون إعادة كتابة كل القيم.

مثال للتبسيط:

> إذا أردنا فقط تغيير `isAuthenticated` إلى true، لا نحتاج إنشاء كل الحالة من الصفر. نستعمل `copyWith`.

### `lib/features/auth/application/session_controller.dart`

هذا الملف يدير الجلسة فعليا.

يحتوي على:

- `sessionControllerProvider`: مزود Riverpod من نوع `NotifierProvider`.
- `SessionController`: class تتحكم في حالة الجلسة.

الدالة `build`:

- تقرأ القيم المحفوظة من `SharedPreferences`.
- تبني أول حالة للتطبيق عند التشغيل.

الدالة `signIn`:

- تجعل المستخدم مسجل الدخول.
- تحفظ الدور والتوكن محليا.
- إذا لم يأت token من API، تضع token تجريبي مثل `demo-token-user`.

الدالة `signOut`:

- تعيد المستخدم إلى حالة زائر.
- تمسح الدور والتوكن من التخزين المحلي.

نقطة مهمة:

هذه الصفحة هي الرابط بين واجهة التطبيق والتخزين المحلي.

### `lib/core/storage/shared_preferences_provider.dart`

هذا الملف يعرف provider ل SharedPreferences.

الملف نفسه لا ينشئ SharedPreferences، بل يرمي `UnimplementedError`.

لماذا؟

لأن النسخة الحقيقية يتم تمريرها في `main.dart` باستخدام override.

هذا أسلوب جيد في Riverpod لأنه يجعل الاعتماديات واضحة وقابلة للاختبار.

## 5. شرح صفحات تسجيل الدخول وإنشاء الحساب

### `lib/features/auth/presentation/login_page.dart`

هذه صفحة تسجيل الدخول.

تستخدم:

- `ConsumerWidget` لأنها تقرأ providers.
- `ReactiveForm` لأنها تعتمد على مكتبة `reactive_forms`.
- `AuthPageFrame` كإطار تصميم جاهز للصفحة.

في أعلى الملف يوجد `loginFormProvider`.

هذا provider ينشئ `FormGroup` يحتوي حقلين:

- `phone`
- `password`

لكل حقل Validators:

- رقم الهاتف مطلوب.
- رقم الهاتف لا يقل عن 8 أرقام.
- رقم الهاتف يطابق pattern محدد.
- كلمة المرور مطلوبة ولا تقل عن 8 أحرف.

يوجد provider آخر:

`loginPasswordVisibleProvider`

وظيفته حفظ هل كلمة المرور ظاهرة أم مخفية.

داخل الواجهة:

- `ReactiveTextField` لحقل الهاتف.
- `ReactiveTextField` لحقل كلمة المرور.
- زر لتبديل ظهور كلمة المرور.
- زر تسجيل الدخول.

الدالة `_submit`:

1. تتحقق من صحة النموذج.
2. تقرأ الهاتف وكلمة المرور.
3. تستخدم بيانات تجريبية:
   - `11111111` مع `12345678` يدخل كمستخدم عادي.
   - `22222222` مع `12345678` يدخل كمسؤول.
4. إذا كانت البيانات خاطئة تعرض `SnackBar`.
5. إذا كانت صحيحة تستدعي `signIn`.
6. تنتقل إلى الصفحة المناسبة حسب الدور.

نقطة تعليمية:

هذه الصفحة لا تتصل بالخادم حاليا. تسجيل الدخول هنا تجريبي ومحلي.

### `lib/features/auth/presentation/register_page.dart`

هذه صفحة إنشاء حساب جديد.

تستخدم `registerFormProvider` لإنشاء نموذج يحتوي:

- الاسم الكامل.
- رقم الهاتف.
- العنوان.
- تاريخ الميلاد.
- كلمة المرور.
- تأكيد كلمة المرور.

يوجد validator مهم:

`Validators.mustMatch('password', 'confirmPassword')`

وظيفته التأكد أن كلمتي المرور متطابقتان.

توجد providers للتحكم بإظهار كلمة المرور:

- `registerPasswordVisibleProvider`
- `registerConfirmPasswordVisibleProvider`

داخل الصفحة يوجد `LayoutBuilder` لمعرفة عرض المساحة:

- إذا العرض كبير، تعرض بعض الحقول بجانب بعضها في Row.
- إذا العرض صغير، تعرضها تحت بعضها في Column.

هذا يتم عبر widget خاص اسمه `_AdaptiveFields`.

يوجد أيضا widget خاص اسمه `_BirthDateField`:

- يعرض تاريخ الميلاد.
- عند الضغط عليه يفتح `showDatePicker`.
- بعد اختيار التاريخ يحدث قيمة الحقل داخل النموذج.

الدالة `_submit`:

- إذا النموذج غير صحيح، تلمس كل الحقول لإظهار الأخطاء.
- إذا صحيح، تعرض رسالة نجاح.
- تعيد المستخدم إلى صفحة تسجيل الدخول.

نقطة تعليمية:

صفحة التسجيل حاليا لا تحفظ المستخدم في API. هي واجهة جاهزة يمكن ربطها لاحقا بملف PHP أو API.

## 6. شرح صفحة المسؤول

### `lib/features/admin/presentation/admin_home_page.dart`

هذه صفحة بسيطة للمسؤول.

تعرض `DashboardShell` مع:

- عنوان لوحة المسؤول.
- وصف الصفحة.
- قائمة ميزات:
  - إدارة المستخدمين.
  - إدارة الأعمال الفنية.
  - تقارير ومتابعة.

الصفحة لا تبني التصميم بنفسها، بل تعطي البيانات إلى widget مشتركة اسمها `DashboardShell`.

نقطة تعليمية:

هذا مثال جيد على فصل البيانات عن التصميم. صفحة المسؤول تحدد المحتوى، و `DashboardShell` يتولى شكل العرض.

## 7. شرح صفحات المستخدم

### `lib/features/users/presentation/users_home_page.dart`

هذه هي الصفحة الرئيسية بعد دخول المستخدم العادي.

تستخدم `ConsumerWidget` لأنها تقرأ:

- `userBottomNavProvider` لمعرفة التبويب الحالي.
- `sessionControllerProvider` عند تسجيل الخروج.

تتكون من:

- `AppBar` مخصص شفاف مع شعار وعنوان وزر خروج.
- خلفية متدرجة.
- `IndexedStack` لعرض الصفحة المختارة.
- `NavigationBar` في الأسفل للتنقل بين:
  - الرئيسية.
  - الأقسام.
  - المعلومات الشخصية.

لماذا `IndexedStack`؟

لأنه يحتفظ بالصفحات موجودة، ويغير فقط الصفحة الظاهرة حسب `selectedIndex`.

الدالة `_titleForTab`:

ترجع عنوان AppBar حسب التبويب.

الودجت `_LogoutAction`:

- يرسم زر خروج بتدرج لوني.
- عند الضغط يظهر Dialog تأكيد.
- إذا وافق المستخدم، يستدعي `signOut`.

نقطة تعليمية:

هذه الصفحة تمثل container للتنقل الداخلي الخاص بالمستخدم، وليست صفحة محتوى واحدة فقط.

### `lib/features/users/presentation/users_navigation.dart`

ملف صغير لكنه مهم.

يعرف:

`userBottomNavProvider`

وهو provider يحتفظ برقم التبويب الحالي.

القيمة الابتدائية `0` تعني تبويب الرئيسية.

الدالة `setIndex` تغير التبويب.

### `lib/features/users/presentation/pages/users_main_page.dart`

صفحة الرئيسية داخل واجهة المستخدم.

تستخدم:

- `UsersPageContainer`
- `UsersHomeFeed`

المتغير `_homeFeedItems` فارغ حاليا، لذلك سيعرض التطبيق حالة فارغة: "لا يوجد شيء لعرضه".

نقطة تعليمية:

هذه الصفحة جاهزة لاستقبال منشورات أو فعاليات لاحقا بمجرد تعبئة القائمة.

### `lib/features/users/presentation/pages/users_categories_page.dart`

صفحة الأقسام.

تستخدم:

- `_sections`: قائمة ثابتة بالأقسام.
- `_UsersCategoriesGrid`: تعرض الأقسام بتخطيط responsive.
- `UsersCategoryCard`: كرت لكل قسم.

الأقسام الحالية:

- اللوحات.
- المنحوتات.
- المعارض.
- الفن الرقمي.
- خدمات التوثيق.
- مقتنيات خاصة.

كل قسم يحتوي:

- عنوان.
- وصف.
- أيقونة.
- ألوان.

عند الضغط على كرت قسم:

- ينتقل التطبيق إلى `UsersSectionPage`.
- يرسل لها بيانات القسم: العنوان والوصف والأيقونة والألوان.

نقطة تعليمية:

هذه الصفحة لا تكرر صفحة لكل قسم. تستخدم صفحة واحدة عامة وتغير محتواها حسب البيانات المرسلة.

### `lib/features/users/presentation/pages/users_section_page.dart`

هذه صفحة تفاصيل القسم.

تستقبل من الصفحة السابقة:

- `title`
- `subtitle`
- `icon`
- `colors`

تستخدم `DefaultTabController` بثلاث تبويبات:

- فيديوهات.
- منشورات.
- فعاليات.

مكونات الصفحة:

- `AppBar` يعرض اسم القسم.
- خلفية متدرجة.
- `_SectionCover` لعرض غلاف القسم.
- زر `تقديم اختبار`.
- `_SectionTabs` لعرض التبويبات.
- `TabBarView` لعرض محتوى كل تبويب.

حاليا محتوى التبويبات فارغ، لذلك يظهر لكل تبويب نص مثل:

`لا توجد فيديوهات في هذا القسم حالياً`

زر الاختبار يفتح:

`UsersSectionTestPage(sectionTitle: title)`

نقطة تعليمية:

هذه الصفحة تعلم الطلاب فكرة page parameters، أي أن الصفحة نفسها قابلة لإعادة الاستخدام مع بيانات مختلفة.

### `lib/features/users/presentation/pages/users_section_test_page.dart`

هذه صفحة اختبار القسم.

تستخدم:

- `ReactiveForm`
- `Provider.autoDispose.family`
- `RadioListTile`
- `AlertDialog`

في أعلى الملف:

`usersSectionTestFormProvider`

هو provider من نوع family، أي أنه يأخذ `sectionTitle` كمعامل. ينشئ النموذج ديناميكيا حسب عدد الأسئلة.

النموذج يحتوي حقولا مثل:

- `question_0`
- `question_1`
- وهكذا حتى آخر سؤال.

كل سؤال مطلوب الإجابة.

داخل الصفحة:

- تعرض عنوان القسم.
- تعرض تعليمات.
- تستخدم `List.generate` لإنشاء بطاقة لكل سؤال.
- كل سؤال يعرض اختيارات باستخدام `RadioListTile`.

الدالة `_submit`:

1. تتحقق من أن كل الأسئلة مجابة.
2. تحسب النتيجة.
3. تستدعي `markSectionAsPassed`.
4. تعرض Dialog بالنتيجة.
5. بعد الضغط على موافق:
   - تجعل التبويب الحالي هو الرئيسية.
   - تغلق الصفحات حتى الصفحة الأولى.

class `_TestQuestion`:

يمثل سؤالا واحدا ويتكون من:

- نص السؤال.
- قائمة الإجابات.
- رقم الإجابة الصحيحة.

القائمة `_questions` تحتوي 10 أسئلة ثابتة.

معلومة مهمة:

كل الإجابات الصحيحة حاليا هي الاختيار الأول `correctIndex: 0`.

### `lib/features/users/application/users_passed_sections_controller.dart`

هذا الملف يدير الأقسام التي اجتازها المستخدم.

يحتوي على model:

`PassedSectionCertificate`

ويمثل شهادة أو نتيجة لقسم مجتاز.

خصائصه:

- `sectionTitle`
- `score`
- `totalQuestions`
- `certificatePdfPath`
- `percentage`

الدالة `percentage` تحسب النسبة المئوية.

ثم يوجد:

`UsersPassedSectionsController`

الحالة الابتدائية قائمة فارغة.

الدالة `markSectionAsPassed`:

- تحسب النسبة.
- إذا كانت أقل من 60% لا تحفظ القسم.
- إذا كان القسم غير محفوظ، تضيفه.
- إذا كان محفوظا سابقا، لا تحدثه إلا إذا كانت النتيجة الجديدة أعلى من القديمة.

نقطة تعليمية:

هذا مثال ممتاز على business logic: القاعدة ليست في واجهة المستخدم فقط، بل في controller مستقل.

### `lib/features/users/presentation/pages/users_profile_page.dart`

صفحة المعلومات الشخصية.

تستخدم `ConsumerWidget` لأنها تقرأ:

`usersPassedSectionsProvider`

تعرض:

- صورة رمزية للمستخدم.
- اسم افتراضي.
- نص يوضح إمكانية الربط بالخادم لاحقا.
- معلومات ثابتة:
  - رقم الهاتف.
  - العنوان.
  - تاريخ الميلاد.
- زر تعديل المعلومات الشخصية.
- الأقسام المجتازة بنسبة 60% أو أكثر.

إذا لم يجتز المستخدم أي قسم:

تعرض `_PassedSectionsEmptyState`.

إذا اجتاز أقساما:

تعرض قائمة من `_PassedSectionCard`.

`_PassedSectionCard`:

- يعرض عنوان القسم.
- يعرض النتيجة والنسبة.
- إذا لم يوجد PDF للشهادة، يظهر Dialog يقول لا تتوفر حاليا شهادة.

نقطة تعليمية:

هذه الصفحة تجمع بين بيانات ثابتة مؤقتة وبيانات ديناميكية قادمة من Riverpod.

## 8. شرح Widgets الخاصة بواجهة المستخدم

### `lib/features/users/presentation/widgets/users_category_card.dart`

Widget تعرض كرت قسم.

تأخذ:

- `title`
- `colors`
- `onTap`

تستخدم:

- `Material`
- `InkWell`
- `Ink`
- `BoxDecoration`
- `LinearGradient`

`_CategoryCover` يرسم الجزء العلوي من الكرت بتدرج لوني.

نقطة تعليمية:

استخدم `InkWell` عندما تريد تأثير ضغط جميل داخل Material design.

### `lib/features/users/presentation/widgets/users_feed_widgets.dart`

يحتوي على:

- `UsersHomeFeed`
- `UsersFeedItem`
- `_UsersFeedPostCard`
- `_UsersEmptyFeedCard`

`UsersHomeFeed`:

- إذا كانت القائمة فارغة يعرض empty state.
- إذا كانت القائمة تحتوي عناصر يعرض كرت لكل عنصر.

`UsersFeedItem`:

model بسيط يمثل منشورا في الصفحة الرئيسية:

- عنوان.
- محتوى.
- معلومات إضافية.
- نوع المنشور.
- أيقونة.

نقطة تعليمية:

هذا مثال على فصل شكل العرض عن شكل البيانات.

### `lib/features/users/presentation/widgets/users_page_container.dart`

Widget عامة لتغليف صفحات المستخدم.

وظيفتها:

- إضافة padding مناسب.
- حساب عرض الشاشة.
- استخدام `AppBreakpoints` لجعل العرض responsive.
- إضافة مسافة أسفل الصفحة حتى لا يغطيها شريط التنقل السفلي.

بدونها سنكرر نفس الكود في كل صفحة.

### `lib/features/users/presentation/widgets/users_profile_info_tile.dart`

Widget صغيرة لعرض معلومة في صفحة الملف الشخصي.

تأخذ:

- أيقونة.
- عنوان.
- قيمة.

مثال:

- العنوان: رقم الهاتف.
- القيمة: +963 9XX XXX XXX.

## 9. شرح Widgets المشتركة

### `lib/shared/widgets/app_logo_mark.dart`

Widget ترسم شعار التطبيق.

تعرض:

- مربع بحواف دائرية.
- تدرج لوني.
- أيقونة `auto_awesome`.
- النص `AF`.

مستخدمة في صفحات الدخول، لوحة المسؤول، وصفحة المستخدم.

نقطة تعليمية:

عندما يتكرر شعار في أكثر من مكان، الأفضل جعله Widget مستقلة.

### `lib/shared/widgets/auth_page_frame.dart`

إطار عام لصفحات المصادقة الحالية.

يستخدم في:

- `LoginPage`
- `RegisterPage`

يأخذ:

- `badge`
- `title`
- `subtitle`
- `child`
- `footer`
- `maxWidth`

يبني:

- خلفية متدرجة.
- دوائر مضيئة زخرفية.
- بطاقة رئيسية.
- رأس ملون فيه الشعار والعنوان.
- جزء سفلي يحتوي النموذج.
- Footer اختياري مثل رابط إنشاء حساب أو تسجيل الدخول.

نقطة تعليمية:

هذا الملف يجعل صفحة الدخول وصفحة التسجيل بنفس الهوية البصرية دون تكرار كود التصميم.

### `lib/shared/widgets/auth_layout.dart`

هذا إطار آخر لصفحات المصادقة، لكنه يبدو أقدم أو بديل.

يعرض:

- لوحة تعريفية `ShowcasePanel`.
- بطاقة نموذج `FormCard`.
- يدعم التخطيط على desktop بشكل صفين، وعلى الشاشات الصغيرة بشكل عمودي.

في الكود الحالي، صفحات login/register تستخدم `AuthPageFrame` وليس `AuthLayout`.

نقطة تعليمية:

يمكن اعتبار هذا الملف مكونا جاهزا لإعادة الاستخدام أو نسخة تصميم بديلة.

### `lib/shared/widgets/dashboard_shell.dart`

Widget عامة لبناء لوحة تحكم.

تستخدم في صفحة المسؤول.

تحتوي على model:

`DashboardFeature`

ويمثل بطاقة ميزة:

- أيقونة.
- عنوان.
- وصف.

`DashboardShell`:

- يعرض الشعار.
- يعرض زر خروج.
- يعرض عنوان ووصف اللوحة.
- يعرض الميزات في Wrap responsive.

يستخدم `AppBreakpoints` لتحديد:

- الهوامش.
- عرض المحتوى.
- عدد الأعمدة.

نقطة تعليمية:

هذا مثال على Widget عامة يمكن استخدامها للمدير أو أي دور آخر بتغيير النصوص فقط.

## 10. شرح ملفات الثيم والألوان

### `lib/core/theme/app_colors.dart`

هذا الملف يحتوي ألوان التطبيق الأساسية.

فيه:

- ألوان الوضع الفاتح.
- ألوان الوضع الداكن.
- ألوان للأقسام مثل اللوحات والمنحوتات والفن الرقمي.

تستخدم هذه الألوان في `AppTheme` وفي كروت الأقسام.

نقطة تعليمية:

بدل كتابة رقم اللون في كل صفحة، نجمع الألوان في ملف واحد لتسهيل التعديل لاحقا.

### `lib/core/theme/app_text_styles.dart`

هذا الملف يعرف أنماط النصوص.

يستخدم خطين:

- `Almarai` للنص العربي.
- `Sora` كخط مساعد ولبعض العناوين.

الدالة `textTheme` تأخذ `ColorScheme` وترجع `TextTheme`.

تحدد:

- `displayLarge`
- `displayMedium`
- `headlineLarge`
- `headlineMedium`
- `titleLarge`
- `titleMedium`
- `bodyLarge`
- `bodyMedium`
- `labelLarge`
- `labelMedium`

نقطة تعليمية:

`TextTheme` يجعل التطبيق متناسقا. إذا تغير حجم العنوان، يتغير في كل مكان يستخدم نفس النمط.

### `lib/core/theme/theme.dart`

هذا أهم ملف في الثيم.

يحتوي على class:

`AppTheme`

وفيه:

- `light()`: ثيم الوضع الفاتح.
- `dark()`: ثيم الوضع الداكن.
- `_buildTheme()`: دالة مشتركة لبناء ThemeData.

`_buildTheme` تضبط:

- `ColorScheme`
- لون خلفية Scaffold.
- `textTheme`
- خط التطبيق.
- شكل AppBar.
- شكل Cards.
- شكل Inputs.
- شكل Buttons.
- شكل SnackBar.
- شكل Chips.
- شكل NavigationBar.
- شكل FloatingActionButton.

يوجد أيضا:

`AppStatusColors`

وهو `ThemeExtension` لإضافة ألوان خاصة مثل:

- success
- warning

نقطة تعليمية:

Flutter يعطيك ThemeData جاهز، لكن إذا أردت ألوانا خاصة بتطبيقك تستطيع إضافة `ThemeExtension`.

### `lib/core/theme/app_dimensions.dart`

يعرف أبعادا قياسية مثل:

- المسافات.
- الزوايا.
- ارتفاع الأزرار.
- أحجام الأيقونات.

يعتمد على `SizeConfig` حتى تكون الأبعاد responsive.

ملاحظة:

هذا الملف غير مستخدم كثيرا في الصفحات الحالية، لكنه جاهز لتوحيد القياسات لاحقا.

### `lib/core/theme/app_elevations.dart`

ملف صغير يحتوي قيم ارتفاع الظلال:

- low
- medium
- high

مفيد إذا أردنا توحيد الظلال في التطبيق.

### `lib/core/color.dart`

هذا ملف ألوان قديم أو بديل.

يحتوي class اسمها `ColorApp` مع ألوان ثابتة مثل:

- whiteApp
- blackApp
- success
- error
- primaryColor

في الهيكلة الحالية، الملف الأكثر تنظيما هو:

`lib/core/theme/app_colors.dart`

يمكن للطلاب فهم `core/color.dart` كملف قديم أو legacy palette.

## 11. شرح الاستجابة لحجم الشاشة

### `lib/core/size_config.dart`

هذا الملف يحسب أبعاد الشاشة.

يحتوي على:

- `screenWidth`
- `screenHeight`
- `blockSizeHorizontal`
- `blockSizeVertical`
- `isMobile`
- `isTablet`
- `isDesktop`
- `adaptive`
- `sp`

الفكرة:

- `w(10)` تعني 10% من عرض الشاشة.
- `h(10)` تعني 10% من ارتفاع الشاشة.
- `adaptive` يعطي قيمة مختلفة حسب نوع الشاشة.
- `sp` يساعد على تحجيم النص مع حدود دنيا وعليا.

### `lib/core/layout/app_breakpoints.dart`

هذا الملف أبسط وأوضح في الاستخدام الحالي.

يعرف نقاط التحول:

- tablet = 720
- desktop = 1100
- wideDesktop = 1440

ويقدم دوال:

- `isTabletWidth`
- `isDesktopWidth`
- `horizontalPadding`
- `adaptiveColumns`
- `contentWidth`

يستخدم كثيرا في صفحات المستخدم و Dashboard.

نقطة تعليمية:

`AppBreakpoints` يجيب عن سؤال: كيف يجب أن يتغير التخطيط عندما تكبر الشاشة؟

## 12. شرح ملفات الشبكة و API

### `lib/core/network/api_config.dart`

يحتوي إعدادات API العامة:

- `baseUrl`
- `connectTimeout`
- `receiveTimeout`
- `sendTimeout`

`baseUrl` يقرأ من:

`String.fromEnvironment('API_BASE_URL')`

وإذا لم توجد قيمة يستخدم:

`https://example.com/authenticity_api`

نقطة تعليمية:

يمكن تغيير رابط API عند البناء دون تغيير الكود.

### `lib/core/network/api_endpoints.dart`

يجمع مسارات API في مكان واحد.

مثل:

- `/auth/login.php`
- `/auth/register.php`
- `/users/profile.php`
- `/artworks/list.php`

الفائدة:

بدل كتابة المسار في كل صفحة، نكتبه مرة واحدة ونستخدمه عند الحاجة.

### `lib/core/network/dio_provider.dart`

ينشئ نسخة `Dio`.

يضبط:

- `baseUrl`
- timeout
- headers
  - Accept: application/json
  - Content-Type: application/json

ثم يضيف interceptor.

الـ interceptor يعمل قبل إرسال كل request:

- يقرأ `api_token` من SharedPreferences.
- إذا وجد token يضيفه إلى header:

`Authorization: Bearer <token>`

نقطة تعليمية:

الـ interceptor يوفر علينا إضافة التوكن يدويا في كل طلب.

### `lib/core/network/api_client.dart`

هذا غلاف بسيط فوق Dio.

يقدم دوال:

- `getJson`
- `postJson`
- `postFormData`

الفائدة:

الصفحات أو controllers لا تحتاج التعامل مع Dio مباشرة. تستخدم `ApiClient`.

### `lib/core/network/https.dart`

يحتوي `MyHttpOverrides`.

وظيفته السماح بالشهادات غير الموثوقة:

`badCertificateCallback => true`

مهم جدا للطلاب:

هذا قد يستخدم فقط أثناء التطوير مع خادم محلي أو شهادة غير رسمية. لا ينصح باستخدامه في الإنتاج لأنه يضعف الأمان.

## 13. مفاهيم Flutter المهمة الموجودة في المشروع

### StatelessWidget

Widget لا تملك حالة داخلية.

أمثلة:

- `AdminHomePage`
- `UsersCategoryCard`
- `AppLogoMark`

### ConsumerWidget

Widget تقرأ الحالة من Riverpod.

أمثلة:

- `AuthenticityOfArtsApp`
- `LoginPage`
- `RegisterPage`
- `UsersHomePage`
- `UsersProfilePage`
- `DashboardShell`

### Provider

يعطي قيمة أو object لباقي التطبيق.

أمثلة:

- `routerProvider`
- `dioProvider`
- `apiClientProvider`

### NotifierProvider

يدير حالة قابلة للتغيير.

أمثلة:

- `sessionControllerProvider`
- `userBottomNavProvider`
- `usersPassedSectionsProvider`

### autoDispose

يعني أن provider يتم التخلص منه عندما لا يعود مستخدما.

مفيد للنماذج المؤقتة مثل:

- نموذج تسجيل الدخول.
- نموذج إنشاء الحساب.
- نموذج الاختبار.

### FormGroup

يمثل مجموعة حقول في reactive_forms.

كل حقل اسمه key مثل:

- `phone`
- `password`

وكل حقل يمكن أن يكون له validators.

### Navigator و GoRouter

المشروع يستخدم الاثنين:

- GoRouter للتنقل الرئيسي بين login/register/admin/users.
- Navigator مع MaterialPageRoute للتنقل الداخلي إلى صفحة القسم والاختبار.

يمكن شرح ذلك هكذا:

> GoRouter يدير أبواب التطبيق الرئيسية، و Navigator يستخدم هنا للصفحات الفرعية داخل تجربة المستخدم.

## 14. ملاحظات مهمة عند شرح المشروع

- تسجيل الدخول تجريبي وليس مربوطا ب API حاليا.
- إنشاء الحساب يعرض رسالة نجاح فقط ولا يرسل البيانات للخادم.
- صفحة الملف الشخصي تعرض بيانات ثابتة مؤقتة.
- صفحة الرئيسية للمستخدم فارغة حاليا لأنها تنتظر عناصر feed.
- صفحة القسم تعرض تبويبات فارغة لكنها جاهزة للمحتوى.
- نتيجة الاختبار تحفظ في الذاكرة فقط عبر Riverpod، ولا تحفظ في SharedPreferences أو خادم.
- طبقة API جاهزة لكنها غير مستخدمة فعليا في صفحات الدخول الحالية.
- `AuthLayout` موجود لكنه غير مستخدم حاليا، بينما `AuthPageFrame` هو المستخدم في صفحات المصادقة.
- `core/color.dart` يبدو ملف ألوان قديم، والثيم الحديث يعتمد على `core/theme/app_colors.dart`.
- `https.dart` يجب الحذر منه في الإنتاج.

## 15. ترتيب مقترح لشرح المشروع للطلاب

1. اشرح فكرة Flutter: كل شيء Widget.
2. افتح `main.dart` واشرح نقطة البداية.
3. افتح `router.dart` واشرح المسارات والحماية.
4. افتح `session_state.dart` ثم `session_controller.dart` واشرح حالة تسجيل الدخول.
5. افتح `login_page.dart` واشرح النموذج والتحقق والانتقال.
6. افتح `register_page.dart` واشرح النموذج الأكبر و DatePicker.
7. افتح `users_home_page.dart` واشرح `NavigationBar` و `IndexedStack`.
8. افتح `users_categories_page.dart` واشرح القائمة الثابتة وتمرير البيانات.
9. افتح `users_section_page.dart` واشرح tabs وزر الاختبار.
10. افتح `users_section_test_page.dart` واشرح إنشاء الأسئلة وحساب النتيجة.
11. افتح `users_profile_page.dart` واشرح قراءة الأقسام المجتازة من provider.
12. افتح ملفات `shared/widgets` واشرح إعادة الاستخدام.
13. افتح ملفات `theme` واشرح كيف نوحد شكل التطبيق.
14. افتح ملفات `network` واشرح كيف سيكون الربط مع API.

## 16. مثال شرح مبسط أمام الطلاب

يمكن قول الآتي:

> التطبيق يبدأ من `main.dart`. عند التشغيل نجهز التخزين المحلي ثم نفتح التطبيق داخل Riverpod. بعد ذلك `router.dart` يقرر الصفحة المناسبة: هل المستخدم زائر؟ إذن يذهب إلى تسجيل الدخول. هل هو مستخدم؟ يذهب إلى صفحة المستخدم. هل هو مسؤول؟ يذهب إلى لوحة المسؤول.

ثم:

> صفحات الدخول والتسجيل تستخدم Reactive Forms، أي أن النموذج نفسه يعرف الحقول والقواعد. عندما يضغط المستخدم الزر، نفحص النموذج. إذا فيه أخطاء نظهرها، وإذا كان صحيحا نكمل العملية.

ثم:

> واجهة المستخدم بعد الدخول فيها شريط تنقل سفلي. القيمة الحالية محفوظة في provider. عندما يضغط المستخدم على تبويب، نغير الرقم، و `IndexedStack` يعرض الصفحة المناسبة.

ثم:

> صفحة الاختبار تحسب النتيجة. إذا حصل المستخدم على 60% أو أكثر، نضيف القسم إلى قائمة الأقسام المجتازة. صفحة الملف الشخصي تقرأ هذه القائمة وتعرضها.

## 17. أسئلة تدريبية للطلاب

- أين يتم تحديد أول صفحة يراها المستخدم؟
- ما الفرق بين `Provider` و `NotifierProvider`؟
- لماذا نستخدم `FormGroup` في صفحة تسجيل الدخول؟
- أين يتم حفظ حالة تسجيل الدخول؟
- ماذا يحدث إذا حاول مستخدم غير مسجل الدخول فتح `/users`؟
- لماذا استخدمنا `IndexedStack` في صفحة المستخدم؟
- أين يتم حساب نتيجة الاختبار؟
- لماذا لا يتم حفظ القسم إذا كانت النسبة أقل من 60%؟
- ما فائدة `AppTheme`؟
- ما فائدة `ApiClient` إذا كان بإمكاننا استخدام Dio مباشرة؟

## 18. أفكار تطوير يمكن إعطاؤها كواجب

- ربط تسجيل الدخول الحقيقي بملف API.
- ربط إنشاء الحساب بالخادم.
- جعل بيانات الملف الشخصي تأتي من API.
- حفظ الأقسام المجتازة في SharedPreferences أو قاعدة بيانات.
- إضافة منشورات حقيقية إلى الصفحة الرئيسية.
- إضافة محتوى داخل تبويبات القسم.
- فتح شهادة PDF عند توفر `certificatePdfPath`.
- فصل أسئلة الاختبار حسب القسم بدلا من استخدام نفس الأسئلة لكل الأقسام.

