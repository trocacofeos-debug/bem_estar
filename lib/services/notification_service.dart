import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // =====================================================
  // INIT
  // =====================================================
  static Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    try {
      tz.setLocalLocation(
        tz.getLocation('America/Sao_Paulo'),
      );
    } catch (e) {
      debugPrint(
        'Erro timezone: $e',
      );
    }

    const androidSettings =
        AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
    );

    final androidPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin
        ?.requestNotificationsPermission();

    await androidPlugin
        ?.createNotificationChannel(
      const AndroidNotificationChannel(
        'agenda_channel',
        'Agenda',
        description:
            'Lembretes de aulas',
        importance: Importance.max,
      ),
    );

    await androidPlugin
        ?.createNotificationChannel(
      const AndroidNotificationChannel(
        'default_channel',
        'Notificações',
        description:
            'Canal padrão',
        importance: Importance.max,
      ),
    );

    _initialized = true;

    debugPrint(
      'NotificationService iniciado',
    );
  }

  // =====================================================
  // TESTE IMEDIATO
  // =====================================================
  static Future<void>
      showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const details =
        NotificationDetails(
      android:
          AndroidNotificationDetails(
        'default_channel',
        'Notificações',
        channelDescription:
            'Canal padrão',
        importance:
            Importance.max,
        priority:
            Priority.high,
      ),
    );

    await _plugin.show(
      id,
      title,
      body,
      details,
    );

    debugPrint(
      'Notificação enviada',
    );
  }

  // =====================================================
  // AGENDAR
  // =====================================================
  static Future<void>
      scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    if (dateTime.isBefore(
      DateTime.now(),
    )) {
      debugPrint(
        'Data inválida',
      );
      return;
    }

    final tzDate =
        tz.TZDateTime.from(
      dateTime,
      tz.local,
    );

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzDate,
      const NotificationDetails(
        android:
            AndroidNotificationDetails(
          'agenda_channel',
          'Agenda',
          channelDescription:
              'Lembretes de aulas',
          importance:
              Importance.max,
          priority:
              Priority.high,
        ),
      ),
      androidScheduleMode:
          AndroidScheduleMode
              .exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation
              .absoluteTime,
    );

    debugPrint(
      'Notificação agendada para: $dateTime',
    );
  }

  // =====================================================
  // LEMBRETE AULA
  // =====================================================
  static Future<void>
      agendarLembreteAula({
    required int id,
    required String nomeAula,
    required DateTime dataHoraAula,
  }) async {
    final lembrete =
        dataHoraAula.subtract(
      const Duration(
        minutes: 30,
      ),
    );

    if (lembrete.isBefore(
      DateTime.now(),
    )) {
      return;
    }

    await scheduleNotification(
      id: id,
      title: 'Lembrete',
      body:
          'Sua aula de $nomeAula começa em 30 minutos.',
      dateTime: lembrete,
    );
  }

  // =====================================================
  // CANCELAR
  // =====================================================
  static Future<void> cancel(
    int id,
  ) async {
    await _plugin.cancel(id);
  }

  // =====================================================
  // CANCELAR TODAS
  // =====================================================
  static Future<void>
      cancelAll() async {
    await _plugin.cancelAll();
  }

  // =====================================================
  // PENDENTES
  // =====================================================
  static Future<List<
          PendingNotificationRequest>>
      pendingNotifications() async {
    return await _plugin
        .pendingNotificationRequests();
  }

  // =====================================================
  // DEBUG
  // =====================================================
  static Future<void>
      debugPendentes() async {
    final lista =
        await _plugin
            .pendingNotificationRequests();

    debugPrint(
      'Pendentes: ${lista.length}',
    );

    for (final item in lista) {
      debugPrint(
        'ID=${item.id} '
        'TITLE=${item.title}',
      );
    }
  }
}