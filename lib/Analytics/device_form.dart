class DeviceForm {
  String deviceName;
  String deviceVersion;
  String identifier;

  DeviceForm(this.deviceName, this.deviceVersion, this.identifier);

  Map toJson() => {
        'deviceName': deviceName,
        'deviceVersion': deviceVersion,
        'identifier': identifier
      };
}
