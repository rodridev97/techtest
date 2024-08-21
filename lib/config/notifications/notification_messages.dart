import 'package:flutter/material.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotificationMessages {
  /// Displays an error notification with the given [message] to the user.
  static void error(BuildContext context,
      {required String message,
      required String title,
      double height = 100,
      double width = 250}) {
    return ElegantNotification.error(
      description: Text(
        message,
        style: const TextStyle(
          fontSize: 15.0,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.red.shade600,
          fontSize: 18.0,
        ),
      ),
      background: Colors.red.shade100,
      height: height,
      width: width,
    ).show(context);
  }

  /// Displays a success notification with the given [message] to the user.
  static void success(BuildContext context,
      {required String message, required String title}) {
    return ElegantNotification.success(
      description: Text(message, style: const TextStyle(fontSize: 15.0)),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.green.shade600,
          fontSize: 18.0,
        ),
      ),
      background: Colors.green.shade100,
      height: 100,
    ).show(context);
  }

  // Displays a warning notification with the given [message] to the user.
  static void warning(BuildContext context, {required String message}) {
    return ElegantNotification.info(
      progressIndicatorBackground: Colors.blue.shade100,
      description: Text(message, style: const TextStyle(fontSize: 18.0)),
      title: Text(
        'Advertencia',
        style: TextStyle(
          color: Colors.yellow.shade900,
          fontSize: 20.0,
        ),
      ),
      background: Colors.yellow.shade100,
      height: 100,
    ).show(context);
  }

  static Widget dialogConfirm(
    BuildContext context, {
    required String title,
    required String message,
    Color? iconColor = Colors.grey,
    required VoidCallback? onCancel,
    required VoidCallback? onAccept,
  }) {
    return AlertDialog(
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.center,
      buttonPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 20),
      title: Text(title),
      icon: Icon(
        FontAwesomeIcons.circleExclamation,
        size: 40.0,
        color: iconColor,
      ),
      content: Text(
        message,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18),
      ),
      actions: [
        FilledButton(
          onPressed: onCancel,
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: onAccept,
          child: const Text('Aceptar'),
        )
      ],
    );
  }

  static Widget dialogDelete(
    BuildContext context, {
    required String title,
    required String message,
    Color? iconColor = Colors.grey,
    required void Function() onCancel,
    required Future<void> Function() onAccept,
  }) {
    return DialogDeleteWidget(
      title: title,
      onCancel: onCancel,
      onAccept: onAccept,
      iconColor: iconColor ?? Colors.grey,
      message: message,
    );
  }
}

class DialogDeleteWidget extends StatefulWidget {
  const DialogDeleteWidget({
    super.key,
    required this.title,
    this.isLoading,
    required this.onCancel,
    required this.onAccept,
    required this.iconColor,
    required this.message,
  });

  final String title;
  final String message;
  final bool? isLoading;
  final void Function() onCancel;
  final Future<void> Function() onAccept;
  final Color iconColor;

  @override
  State<DialogDeleteWidget> createState() => _DialogDeleteWidgetState();
}

class _DialogDeleteWidgetState extends State<DialogDeleteWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      actionsAlignment: MainAxisAlignment.center,
      buttonPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 20),
      title: Text(widget.title),
      icon: Icon(
        FontAwesomeIcons.trashCan,
        size: 40.0,
        color: widget.iconColor,
      ),
      content: Text(
        widget.message,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 18),
        textAlign: TextAlign.center,
      ),
      actions: [
        FilledButton(
          onPressed: !_isLoading
              ? () {
                  setState(() {
                    _isLoading = true;
                  });
                  widget.onCancel();
                  setState(() {
                    _isLoading = false;
                  });
                }
              : null,
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                !_isLoading ? Colors.lightBlue.shade900 : Colors.blue.shade200,
          ),
          onPressed: !_isLoading
              ? () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await widget.onAccept();
                  setState(() {
                    _isLoading = false;
                  });
                }
              : null,
          child: !_isLoading
              ? const Text('Aceptar')
              : const SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(),
                ),
        )
      ],
    );
  }
}
