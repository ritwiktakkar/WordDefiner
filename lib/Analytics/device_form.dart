class DeviceForm {
  String deviceName;
  String deviceVersion;
  String identifier;
  String appBuildNumber;

  DeviceForm(this.deviceName, this.deviceVersion, this.identifier,
      this.appBuildNumber);

  Map toJson() => {
        'deviceName': deviceName,
        'deviceVersion': deviceVersion,
        'identifier': identifier,
        'appBuildNumber': appBuildNumber,
      };
}
