import 'package:worddefiner/Analytics/device_form.dart';
import 'package:worddefiner/Analytics/definition_form.dart';

class AnalyticsForm {
  DefinitionForm definitionForm;
  DeviceForm deviceForm;

  AnalyticsForm(this.definitionForm, this.deviceForm);

  Map toJson() => {
        'query': definitionForm.query,
        'isFound': definitionForm.isFound,
        'deviceName': deviceForm.deviceName,
        'deviceVersion': deviceForm.deviceVersion,
        'identifier': deviceForm.identifier,
        'appBuildNumber': deviceForm.appBuildNumber,
      };
}
