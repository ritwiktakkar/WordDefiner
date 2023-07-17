class DeviceForm {
  String deviceName;
  String deviceVersion;
  String identifier;
  String appVersion;

  DeviceForm(
      this.deviceName, this.deviceVersion, this.identifier, this.appVersion);

  Map toJson() => {
        'deviceName': deviceName,
        'deviceVersion': deviceVersion,
        'identifier': identifier,
        'appVersion': appVersion,
      };
}
