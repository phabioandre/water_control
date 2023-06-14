import 'package:thingsboard_client/thingsboard_client.dart';

// ThingsBoard REST API URL
const thingsBoardApiEndpoint = 'https://thingsboard.cloud';

void main() async {
  try {
    // Create instance of ThingsBoard API Client
    var tbClient = ThingsboardClient(thingsBoardApiEndpoint);

    // Perform login with default Tenant Administrator credentials
    await tbClient.login(LoginRequest('phabioandre@yahoo.com.br', 'senha4321'));

    var deviceName = 'Sonda';

    // Construct device object
    //  var device = Device(deviceName, 'Sensor');
    // device.additionalInfo = {'description': 'My test device!'};

    // Add device
    // var savedDevice = await tbClient.getDeviceService().saveDevice(device);
    //  print('savedDevice: $savedDevice');

    // Create entity filter to get device by its name
    var entityFilter = EntityNameFilter(
        entityType: EntityType.DEVICE, entityNameFilter: deviceName);

    // Prepare list of queried device fields
    var deviceFields = <EntityKey>[
      EntityKey(type: EntityKeyType.ENTITY_FIELD, key: 'name'),
      EntityKey(type: EntityKeyType.ENTITY_FIELD, key: 'type'),
      EntityKey(type: EntityKeyType.ENTITY_FIELD, key: 'createdTime')
    ];

    // Prepare list of queried device timeseries
    var deviceTelemetry = <EntityKey>[
      EntityKey(type: EntityKeyType.TIME_SERIES, key: 'Oxigenio'),
      EntityKey(type: EntityKeyType.TIME_SERIES, key: 'Ph')
    ];

    // Create entity query with provided entity filter, queried fields and page link
    var devicesQuery = EntityDataQuery(
        entityFilter: entityFilter,
        entityFields: deviceFields,
        latestValues: deviceTelemetry,
        pageLink: EntityDataPageLink(
            pageSize: 10,
            sortOrder: EntityDataSortOrder(
                key: EntityKey(
                    type: EntityKeyType.ENTITY_FIELD, key: 'createdTime'),
                direction: EntityDataSortOrderDirection.DESC)));

    // Create timeseries subscription command to get data for 'temperature' and 'humidity' keys for last hour with realtime updates
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    var timeWindow = Duration(hours: 1).inMilliseconds;

    var tsCmd = TimeSeriesCmd(
        keys: ['Oxigenio', 'Ph'],
        startTs: currentTime - timeWindow,
        timeWindow: timeWindow);

    // Create subscription command with entities query and timeseries subscription
    var cmd = EntityDataCmd(query: devicesQuery, tsCmd: tsCmd);

    // Create subscription with provided subscription command
    var telemetryService = tbClient.getTelemetryService();
    var subscription = TelemetrySubscriber(telemetryService, [cmd]);

    // Create listener to get data updates from WebSocket
    subscription.entityDataStream.listen((entityDataUpdate) {
      print('Received entity data update: $entityDataUpdate');
    });

    // Perform subscribe (send subscription command via WebSocket API and listen for responses)
    subscription.subscribe();
/*
    // Post sample telemetry
    var rng = Random();
    for (var i = 0; i < 5; i++) {
      await Future.delayed(Duration(seconds: 1));
      var temperature = 10 + 20 * rng.nextDouble();
      var humidity = 30 + 40 * rng.nextDouble();
      var telemetryRequest = {'Oxigenio': oxigenio, 'Ph': ph};
      print('Save telemetry request: $telemetryRequest');
      var res = await tbClient
          .getAttributeService()
          .saveEntityTelemetry(savedDevice.id!, 'TELEMETRY', telemetryRequest);
      print('Save telemetry result: $res');
    }
*/
    // Wait few seconds to show data updates are received by subscription listener
    await Future.delayed(Duration(seconds: 20));

    // Finally unsubscribe to release subscription
    subscription.unsubscribe();

    // Delete the device
    //  await tbClient.getDeviceService().deleteDevice(savedDevice.id!.id!);

    // Finally perform logout to clear credentials
    await tbClient.logout();
  } catch (e, s) {
    print('Error: $e');
    print('Stack: $s');
  }
}
