import 'package:fluent_ui/fluent_ui.dart';

class Toast{
  String message;
  bool isLong = false;

  Toast(this.message, this.isLong);

  void showInfo(BuildContext context){
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
          title: const Text(''),
          content:  Text(message),
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
          severity: InfoBarSeverity.info,
          isLong: isLong
      );
    });
  }
  void showWarning(BuildContext context){
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
          title: const Text(''),
          content:  Text(message),
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
          severity: InfoBarSeverity.warning,
          isLong: isLong
      );
    });
  }
  void showSuccess(BuildContext context){
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
          title: const Text(''),
          content:  Text(message),
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
          severity: InfoBarSeverity.success,
          isLong: isLong
      );
    });
  }
  void showError(BuildContext context){
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
          title: const Text(''),
          content:  Text(message),
          action: IconButton(
            icon: const Icon(FluentIcons.clear),
            onPressed: close,
          ),
          severity: InfoBarSeverity.error,
          isLong: isLong
      );
    });
  }
}