// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Worthra';

  @override
  String get appTagline => 'Tu compañero de finanzas';

  @override
  String get appBrandName => 'WORTHRA';

  @override
  String get appVersion => 'Versión de la App 1.0.0';

  @override
  String get cancelButton => 'Cancelar';

  @override
  String get deleteButton => 'Eliminar';

  @override
  String get closeButton => 'Cerrar';

  @override
  String get saveButton => 'Guardar';

  @override
  String get navHome => 'Inicio';

  @override
  String get navHistory => 'Historial';

  @override
  String get navGoals => 'Metas';

  @override
  String get navInsights => 'Análisis';

  @override
  String get portfolioLabel => 'Portafolio';

  @override
  String get guestUserName => 'Usuario Invitado';

  @override
  String dashboardGreeting(String name) {
    return 'Buenos días, $name';
  }

  @override
  String get dashboardSubtitle => 'Este es tu estado financiero de hoy.';

  @override
  String get currentBalanceLabel => 'SALDO ACTUAL';

  @override
  String get monthlyIncomeLabel => 'Ingresos Mensuales';

  @override
  String get monthlyExpensesLabel => 'Gastos Mensuales';

  @override
  String get weeklySpendingTrendLabel => 'Tendencia de Gasto Semanal';

  @override
  String get last7DaysLabel => 'Últimos 7 Días';

  @override
  String get recentTransactionsLabel => 'Transacciones Recientes';

  @override
  String get viewAllButton => 'Ver Todo';

  @override
  String get emptyDashboardMessage =>
      'Agrega tu primera transacción para llenar el panel.';

  @override
  String get dayMon => 'Lun';

  @override
  String get dayTue => 'Mar';

  @override
  String get dayWed => 'Mié';

  @override
  String get dayThu => 'Jue';

  @override
  String get dayFri => 'Vie';

  @override
  String get daySat => 'Sáb';

  @override
  String get daySun => 'Dom';

  @override
  String get vaultStatusTitle => 'Estado del Almacén Local';

  @override
  String get transactionsLabel => 'Transacciones';

  @override
  String get goalsLabel => 'Metas';

  @override
  String get storageLabel => 'Almacenamiento';

  @override
  String get localStorageValue => 'Base de Datos Isar Local';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get preferencesSection => 'Preferencias';

  @override
  String get themeLabel => 'Tema';

  @override
  String get themeLightLabel => 'Claro';

  @override
  String get themeDarkLabel => 'Oscuro';

  @override
  String get currencyLabel => 'Moneda';

  @override
  String get languageLabel => 'Idioma';

  @override
  String get remindersSection => 'Recordatorios';

  @override
  String get dailyReminderLabel => 'Recordatorio Diario';

  @override
  String get reminderTimeLabel => 'Hora del Recordatorio';

  @override
  String get securityDataSection => 'Seguridad y Datos';

  @override
  String get biometricLockLabel => 'Bloqueo Biométrico';

  @override
  String get exportCsvLabel => 'Exportar Datos (CSV)';

  @override
  String get exportingLabel => 'Exportando Datos...';

  @override
  String get aboutSection => 'Acerca de';

  @override
  String get privacyPolicyLabel => 'Política de Privacidad';

  @override
  String get privacyPolicyBody =>
      'Todos los datos de la app se almacenan localmente en tu dispositivo, a menos que agregues sincronización. Las exportaciones se crean solo cuando las solicitas.';

  @override
  String get termsLabel => 'Términos y Condiciones';

  @override
  String get termsBody =>
      'Esta versión usa una base de datos local sin conexión. Eres responsable de mantener seguros los archivos exportados si los mueves fuera de la app.';

  @override
  String get deleteAccountButton => 'Eliminar Cuenta y Datos';

  @override
  String get deleteAllDataTitle => '¿Eliminar todos los datos locales?';

  @override
  String get deleteAllDataContent =>
      'Esto borrará tus transacciones, metas y restablecerá los ajustes predeterminados en este dispositivo.';

  @override
  String get dataClearedMessage =>
      'Todos los datos locales han sido eliminados.';

  @override
  String csvExportedMessage(String path) {
    return 'CSV exportado a $path';
  }

  @override
  String get syncSection => 'Sincronización';

  @override
  String get lastSyncedLabel => 'Última Sincronización';

  @override
  String get syncNowLabel => 'Sincronizar Ahora';

  @override
  String get syncingLabel => 'Sincronizando...';

  @override
  String get syncSuccessMessage => 'Sincronización completada con éxito.';

  @override
  String get syncErrorMessage =>
      'Error de sincronización. Se reintentará cuando haya conexión.';

  @override
  String get neverSyncedLabel => 'Nunca';

  @override
  String get accountSection => 'Cuenta';

  @override
  String get signOutLabel => 'Cerrar Sesión';

  @override
  String get signOutConfirmTitle => '¿Cerrar sesión?';

  @override
  String get signOutConfirmContent =>
      'Tus datos locales permanecerán en este dispositivo.';

  @override
  String get loginTitle => 'Bienvenido de vuelta';

  @override
  String get loginSubtitle =>
      'Inicia sesión para sincronizar tus finanzas de forma segura.';

  @override
  String get signupTitle => 'Crear cuenta';

  @override
  String get signupSubtitle =>
      'Empieza a rastrear tus finanzas de forma privada.';

  @override
  String get emailLabel => 'Correo Electrónico';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get nameLabel => 'Nombre Completo';

  @override
  String get loginButton => 'Iniciar Sesión';

  @override
  String get signupButton => 'Crear Cuenta';

  @override
  String get goToSignupLabel => '¿No tienes cuenta? Regístrate';

  @override
  String get goToLoginLabel => '¿Ya tienes cuenta? Inicia sesión';

  @override
  String get loginErrorMessage =>
      'Correo o contraseña incorrectos. Inténtalo de nuevo.';

  @override
  String get signupErrorMessage => 'Error al registrarse. Inténtalo de nuevo.';

  @override
  String get continueOfflineLabel => 'Continuar sin cuenta';

  @override
  String get goalsHeaderTracker => 'RASTREADOR DE PROGRESO';

  @override
  String get goalsHeaderTitle => 'Mis Metas';

  @override
  String get goalsHeaderSubtitle =>
      'Construye riqueza mediante el ahorro intencional y las rachas.';

  @override
  String get goalsSectionSavings => 'Metas de Ahorro';

  @override
  String get goalsSectionStreaks => 'Retos de Racha';

  @override
  String get goalStatusCompleted => 'Completado 🏆';

  @override
  String get goalStatusDoneToday => 'Hecho hoy ✅';

  @override
  String get goalStatusActive => 'Activo 🔥';

  @override
  String get goalStatusNotStarted => 'Aún no iniciado';

  @override
  String get goalStatusBroken => 'Racha rota 💔';

  @override
  String get goalsEmptyTitle => 'Inicia tu Viaje Financiero';

  @override
  String get goalsEmptySubtitle =>
      'Crea una meta de ahorro o un hábito para empezar a rastrear tu progreso.';

  @override
  String get goalAddLabel => 'Añadir';

  @override
  String get goalLabelDays => 'días';

  @override
  String get insightsHeaderIntelligence => 'INTELIGENCIA FINANCIERA';

  @override
  String get insightsHeaderTitle => 'Análisis de Gastos';

  @override
  String get insightsHeaderSubtitle =>
      'Un desglose detallado de tu huella financiera.';

  @override
  String get insightsTabWeekly => 'Semanal';

  @override
  String get insightsTabMonthly => 'Mensual';

  @override
  String get insightsIncome => 'Ingresos';

  @override
  String get insightsExpenses => 'Gastos';

  @override
  String get insightsSaved => 'Ahorrado';

  @override
  String get insightsGreenBanner => 'Estás en números verdes 💪';

  @override
  String get insightsRedBanner => 'El gasto supera a los ingresos';

  @override
  String get insightsSurplus => 'Superávit neto:';

  @override
  String get insightsDeficit => 'Déficit neto:';

  @override
  String get insightsThisPeriod => 'este periodo';

  @override
  String get insightsCategoryBreakdown => 'Desglose por Categoría';

  @override
  String get insightsOfExpenses => 'de los gastos';

  @override
  String get insightsTopBadge => 'TOP';

  @override
  String get insightsTipTitle => 'Consejo con IA';

  @override
  String get insightsTipEmpty =>
      'Añade más transacciones para desbloquear consejos personalizados.';

  @override
  String insightsTipMoreThanHalf(String category, String percentage) {
    return '$category consume el $percentage% de tus gastos — ¡eso es más de la mitad! Busca formas de reducirlo.';
  }

  @override
  String insightsTipLeads(String category, String percentage) {
    return '$category lidera con un $percentage%. Considera establecer un tope mensual para esta categoría.';
  }

  @override
  String get insightsTipBalanced =>
      'Tus gastos están bien distribuidos en las categorías. ¡Mantén este equilibrio!';

  @override
  String insightsTipTop(String category, String percentage) {
    return '$category es tu área de mayor gasto con el $percentage%. ¡Buen trabajo manteniéndolo bajo control!';
  }

  @override
  String get insightsEmptyTitle => 'Sin datos de gastos';

  @override
  String get insightsEmptySubtitle =>
      'Añade transacciones de gastos y vuelve para ver tu desglose de gastos.';
}
