//import 'dart:async';
//import 'dart:typed_data';
//import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
//import 'package:trans/base/screen/BaseScreen.dart';
//import 'package:trans/base/style/BaseStyle.dart';
//import 'dart:ui' as ui;
//
//class FollowOrderScreen extends BaseScreen {
//  SolidController _controller = SolidController();
//  Completer<GoogleMapController> _completer = Completer();
//
//  static final CameraPosition _currentPosition =
//      CameraPosition(target: LatLng(10.738220, 106.703020), zoom: 18);
//
//  Set<Marker> _markers = {};
//
//  @override
//  void initState() {
//    super.initState();
//
//    /**
//     * Move to ware house
//     */
//    moveToWareHouse();
//
//    /**
//     * Add marker
//     */
//    addMarker();
//  }
//
//  addMarker() async {
//    final markerIcon = await getBitmapDescriptorFromAssetBytes(
//        'assets/images/marker_box.png', 80);
//    _markers.add(Marker(
//        markerId: MarkerId('Order ID'),
//        position: LatLng(10.738220, 106.703020),
//        infoWindow: InfoWindow(
//            title: 'Đơn hàng của bạn đã đến kho.',
//            snippet: 'Xem chi tiết đơn hàng',
//            onTap: () {
//              _controller.isOpened ? _controller.hide() : _controller.show();
//            }),
//        icon: markerIcon));
//    if (!mounted) {
//      return;
//    }
//    setState(() {});
//  }
//
//  Future<Uint8List> getBytesFromAsset(String path, int width) async {
//    ByteData data = await rootBundle.load(path);
//    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//        targetWidth: width);
//    ui.FrameInfo fi = await codec.getNextFrame();
//    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
//        .buffer
//        .asUint8List();
//  }
//
//  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
//      String path, int width) async {
//    final Uint8List imageData = await getBytesFromAsset(path, width);
//    return BitmapDescriptor.fromBytes(imageData);
//  }
//
//  moveToWareHouse() async {
//    final GoogleMapController mapController = await _completer.future;
//
//    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
//      bearing: 192.8334901395799,
//      target: LatLng(10.738220, 106.703020),
//      zoom: 18.0,
//    )));
//  }
//
//  @override
//  Widget onInitBody(BuildContext context) {
//    return GoogleMap(
//      compassEnabled: false,
//      zoomControlsEnabled: false,
//      mapType: MapType.normal,
//      initialCameraPosition: _currentPosition,
//      markers: _markers,
//      onMapCreated: (GoogleMapController controller) {
//        _completer.complete(controller);
//      },
//    );
//  }
//
//  @override
//  Widget onInitBottomSheet(BuildContext context) {
//    final EdgeInsets padding = MediaQuery.of(context).padding;
//
//    return Container(
//        padding: EdgeInsets.only(bottom: padding.bottom / 2),
//        child: SolidBottomSheet(
//          controller: _controller,
//          draggableBody: true,
//          headerBar: Container(
//              decoration: BoxDecoration(
//                  color: Colors.orange,
//                  borderRadius: BorderRadius.only(
//                      topLeft: Radius.circular(12),
//                      topRight: Radius.circular(12))),
//              height: 50,
//              child: Row(
//                children: <Widget>[
//                  /// Back icon
//                  IconButton(
//                    icon: Icon(Icons.keyboard_backspace, color: Colors.white),
//                    onPressed: () {
//                      popScreen(context);
//                    },
//                  ),
//
//                  /// Title
//                  Expanded(
//                      child: Text('Thông tin đơn hàng',
//                          textAlign: TextAlign.center,
//                          style: TextStyle(color: Colors.white, fontSize: 16))),
//
//                  /// Focus on package
//                  IconButton(
//                    icon: Icon(Icons.pin_drop, color: primaryColor),
//                    onPressed: () async {
//                      await moveToWareHouse();
//                    },
//                  ),
//                ],
//              )),
//          body: Container(
//            child: ListView(
//              children: <Widget>[
//                Text('text'),
//                Text('text'),
//                Text('text'),
//                Text('text'),
//              ],
//            ),
//          ),
//        ));
//  }
//}
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';

import 'dart:math' show cos, sqrt, asin;

import 'package:trans/base/screen/BaseScreen.dart';
import 'package:trans/base/style/BaseStyle.dart';

class FollowOrderScreen extends BaseScreen {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  SolidController solidController = SolidController();

  final Geolocator _geolocator = Geolocator();

  Position _currentPosition;
  String _currentAddress;

  final TextEditingController startAddressController = TextEditingController();
  final TextEditingController destinationAddressController =
      TextEditingController();

  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;

  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _textField({
    TextEditingController controller,
    String label,
    String hint,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue[300],
              width: 1,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  _initCurrentLocation(double lat, double lng) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lng),
          zoom: 18.0,
        ),
      ),
    );
  }

  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      _currentPosition = position;

      print('CURRENT POS: $_currentPosition');

      /// Init current location
      _initCurrentLocation(position.latitude, position.longitude);

      circle = Circle(
          circleId: CircleId("car"),
//          radius: newLocalData.accuracy,
          zIndex: 1,
          strokeColor: Colors.blue,
          center: LatLng(position.latitude, position.longitude),
          fillColor: Colors.blue.withAlpha(70));

      await _getAddress();

      /// Update new date
      setState(() {});
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.thoroughfare}, ${place.subAdministrativeArea}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance() async {
    try {
      // Retrieving placemarks from addresses
      List<Placemark> startPlacemark =
          await _geolocator.placemarkFromAddress(_startAddress);
      List<Placemark> destinationPlacemark =
          await _geolocator.placemarkFromAddress(_destinationAddress);

      if (startPlacemark != null && destinationPlacemark != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        Position startCoordinates = _startAddress == _currentAddress
            ? Position(
                latitude: _currentPosition.latitude,
                longitude: _currentPosition.longitude)
            : startPlacemark[0].position;
        Position destinationCoordinates = destinationPlacemark[0].position;

        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId('$startCoordinates'),
          position: LatLng(
            startCoordinates.latitude,
            startCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: _startAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId('$destinationCoordinates'),
          position: LatLng(
            destinationCoordinates.latitude,
            destinationCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: _destinationAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Adding the markers to the list
        markers.add(startMarker);
        markers.add(destinationMarker);

        print('START COORDINATES: $startCoordinates');
        print('DESTINATION COORDINATES: $destinationCoordinates');

        Position _northeastCoordinates;
        Position _southwestCoordinates;

        // Calculating to check that
        // southwest coordinate <= northeast coordinate
        if (startCoordinates.latitude <= destinationCoordinates.latitude) {
          _southwestCoordinates = startCoordinates;
          _northeastCoordinates = destinationCoordinates;
        } else {
          _southwestCoordinates = destinationCoordinates;
          _northeastCoordinates = startCoordinates;
        }

        // Accommodate the two locations within the
        // camera view of the map
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                _northeastCoordinates.latitude,
                _northeastCoordinates.longitude,
              ),
              southwest: LatLng(
                _southwestCoordinates.latitude,
                _southwestCoordinates.longitude,
              ),
            ),
            100.0,
          ),
        );

        // Calculating the distance between the start and the end positions
        // with a straight path, without considering any route
        // double distanceInMeters = await Geolocator().bearingBetween(
        //   startCoordinates.latitude,
        //   startCoordinates.longitude,
        //   destinationCoordinates.latitude,
        //   destinationCoordinates.longitude,
        // );

        await _createPolylines(startCoordinates, destinationCoordinates);

        double totalDistance = 0.0;

        // Calculating the total distance by adding the distance
        // between small segments
        for (int i = 0; i < polylineCoordinates.length - 1; i++) {
          totalDistance += _coordinateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude,
          );
        }

        setState(() {
          _placeDistance = totalDistance.toStringAsFixed(2);
          print('DISTANCE: $_placeDistance km');
        });

        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Create the polylines for showing the route between two places
  _createPolylines(Position start, Position destination) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyB9VULXpdEt_OGYLhwkk6SW1NvahQ4j7vA', // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  Timer timer;
  int second = 0;
  int number = 192;
  int timesDelay = 180;
  Circle circle;

  @override
  void initState() {
    super.initState();
    destinationAddressController.text = '$number Nguyễn Đình Chiểu Quận 3';

    const oneSec = const Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      second++;
      print('second : $second');
      /**
       * Handle update number
       */
      _handleUpdateNumber(second);
    });

    _getCurrentLocation();
  }

  _handleUpdateNumber(int value) {
    if (value == 60) {
      number = 30;
      destinationAddressController.text = '$number Nguyễn Đình Chiểu Quận 3';
      _destinationAddress = destinationAddressController.text;
      _handleDrawRoutes();
      setState(() {});
    }
  }

  _handleDrawRoutes() {
    if (_startAddress.isNotEmpty && _destinationAddress.isNotEmpty) {
      {
        if (markers.isNotEmpty) markers.clear();
        if (polylines.isNotEmpty) polylines.clear();
        if (polylineCoordinates.isNotEmpty) polylineCoordinates.clear();
        _placeDistance = null;

        /// Update new data
        setState(() {});

        _calculateDistance().then((isCalculated) {
          if (isCalculated) {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('Distance Calculated Successfully'),
              ),
            );
          } else {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('Error Calculating Distance'),
              ),
            );
          }
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget onInitBody(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            /// Create google map widget
            _createGoogleMapWidget(),

            /// Create header widget
            _createHeaderWidget(),

            /// Create routes widget
            _createRoutesWidget(height, width),
          ],
        ),
      ),
    );
  }

  Widget _createRoutesWidget(double height, double width) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Card(
              child: Container(
                width: width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(height: 10),
                    _textField(
                        label: 'Start',
                        hint: 'Choose starting point',
                        prefixIcon: Icon(Icons.looks_one),
//                        suffixIcon: IconButton(
//                          icon: Icon(Icons.my_location),
//                          onPressed: () {
//                            startAddressController.text = _currentAddress;
//                            _startAddress = _currentAddress;
//                          },
//                        ),
                        controller: startAddressController,
                        width: width,
                        locationCallback: (String value) {
                          setState(() {
                            _startAddress = value;
                          });
                        }),
                    SizedBox(height: 10),
                    _textField(
                        label: 'Destination',
                        hint: 'Choose destination',
                        prefixIcon: Icon(Icons.looks_two),
                        controller: destinationAddressController,
                        width: width,
                        locationCallback: (String value) {
                          setState(() {
                            _destinationAddress = value;
                          });
                        }),
                    SizedBox(height: 10),
                    Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Visibility(
                              visible: _placeDistance == null ? false : true,
                              child: Text(
                                'DISTANCE: $_placeDistance km',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),
                            RaisedButton(
                              onPressed: () {
                                /**
                                 * Handle draw routes
                                 */
                                _handleDrawRoutes();
                              },
                              color: primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Show Route'.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _createHeaderWidget() {
    return SafeArea(
        child: Container(
            margin: EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                    onTap: () {
                      popScreen(context);
                    },
                    child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.grey, shape: BoxShape.circle),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 14,
                          color: Colors.white,
                        ))),
                GestureDetector(
                    onTap: () {
                      /// Init current location
                      _initCurrentLocation(_currentPosition.latitude,
                          _currentPosition.longitude);
                    },
                    child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.blue, shape: BoxShape.circle),
                        child: Icon(
                          Icons.my_location,
                          size: 14,
                          color: Colors.white,
                        ))),
              ],
            )));
  }

  Widget _createGoogleMapWidget() {
    return GoogleMap(
      padding: EdgeInsets.all(10),
//      markers: markers != null ? Set<Marker>.from(markers) : null,
      markers: markers ?? Set<Marker>.from(markers),
      initialCameraPosition: _initialLocation,
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapType: MapType.terrain,
      polylines: Set<Polyline>.of(polylines.values),
      onMapCreated: _onMapCreated,
      onCameraMove: (CameraPosition position) {
//        LatLng value = position.target;
//        _initCurrentLocation(value.latitude, value.longitude);
      },
      onCameraIdle: () {},
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

//  @override
//  Widget onInitBottomSheet(BuildContext context) {
//    final EdgeInsets padding = MediaQuery.of(context).padding;
//    return Container(
//        padding: EdgeInsets.only(bottom: padding.bottom / 2),
//        child: SolidBottomSheet(
//          controller: solidController,
//          maxHeight: 200,
//          draggableBody: true,
//          headerBar: Container(
//            height: 50,
//            decoration: BoxDecoration(
//                color: Colors.orange,
//                borderRadius: BorderRadius.only(
//                    topLeft: Radius.circular(4), topRight: Radius.circular(4))),
//            child: Container(
//                margin: EdgeInsets.only(left: 10, right: 10),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    Text('Status of order : ',
//                        style: TextStyle(color: Colors.white)),
//                    Text('Delivering for VCS',
//                        style: TextStyle(
//                            color: Colors.white, fontWeight: FontWeight.bold))
//                  ],
//                )),
//          ),
//          body: Container(
//            child: ListView(
//              children: <Widget>[
//                Text('text'),
//                Text('text'),
//                Text('text'),
//                Text('text'),
//              ],
//            ),
//          ),
//        ));
//  }
}
