library usps_sdk;

import 'package:sexy_api_client/sexy_api_client.dart';
import 'package:xml_parser/xml_parser.dart';
//Variables and enums
//---------------------------------------------------------------------------
const String _uspsApiUrl = "https://secure.shippingapis.com";
//USPS Types
//---------------------------------------------------------------------------
class USPSError{
  USPSError({
    required this.errorCode,
    required this.description,
    required this.source,
  });
  final String errorCode;
  final String description;
  final String source;
}
class USPSAddress{
  USPSAddress({
    required this.firmName,
    required this.address1,
    required this.address2,
    required this.city,
    required this.state,
    required this.zip4,
    required this.zip5,
    this.urbanization = "",
  });
  ///Firm Name
  final String firmName;
  ///Delivery Address in the destination address. May contain secondary unit designator, such as APT or SUITE, for Accountable mail.)
  final String address1;
  ///Delivery Address in the
  ///destination address.
  ///Required for all mail and
  ///packages, however 11-
  ///digit Destination Delivery
  ///Point ZIP+4 Code can be
  ///provided as an alternative
  ///in the Detail 1 Record.
  final String address2;
  final String city;
  final String state;
  ///Destination 5-digit ZIP
  ///Code. Numeric values (0-
  ///9) only. If International, all
  ///zeroes.
  final String zip5;
  ///Destination ZIP+4 Numeric
  ///values (0-9) only. If
  ///International, all zeroes.
  ///Default to spaces if not
  ///available.
  final String zip4;
  ///Urbanization.
  ///For Puerto Rico addresses only.
  final String urbanization;
  //Parse request response
  static USPSAddress parse(String xml){
    XmlDocument xmlDocument = XmlDocument.from(xml)!;
    return USPSAddress(
      address1: xmlDocument.getElement("Address1") == null ? "" : xmlDocument.getElement("Address1")!.text ?? "", 
      address2: xmlDocument.getElement("Address2") == null ? "" : xmlDocument.getElement("Address2")!.text ?? "", 
      city: xmlDocument.getElement("City") == null ? "" : xmlDocument.getElement("City")!.text ?? "", 
      state: xmlDocument.getElement("State") == null ? "" : xmlDocument.getElement("State")!.text ?? "", 
      zip4: xmlDocument.getElement("Zip4") == null ? "" : xmlDocument.getElement("Zip4")!.text ?? "", 
      zip5: xmlDocument.getElement("Zip5") == null ? "" : xmlDocument.getElement("Zip5")!.text ?? "",
      firmName: xmlDocument.getElement("FirmName") == null ? "" : xmlDocument.getElement("FirmName")!.text ?? "",
      urbanization: xmlDocument.getElement("Urbanization") == null ? "" : xmlDocument.getElement("Urbanization")!.text ?? "",
    );
  }
}
class USPSSpecialService{
  USPSSpecialService({
    required this.serviceID,
    required this.serviceName,
    required this.available,
    required this.price,
  });
  final String serviceID;
  final String serviceName;
  final bool available;
  final double price;
}
class DomesticRates{
  DomesticRates({
    required this.rate,
    required this.availableServices,
  });
  final double rate;
  final List<USPSSpecialService> availableServices;
  static DomesticRates parse(String xml){
    XmlDocument document = XmlDocument.from(xml)!;
    //Special services
    List<XmlElement> specialServices = document.getElements("SpecialService")!;
    List<USPSSpecialService> parsedSpecialServices = [];
    for(XmlElement specialService in specialServices){
      parsedSpecialServices.add(USPSSpecialService(
        serviceID: specialService.getElement("ServiceID") == null ? "" : specialService.getElement("ServiceID")!.text ?? "",
        serviceName: specialService.getElement("ServiceName") == null ? "" : specialService.getElement("ServiceName")!.text ?? "",
        available: bool.fromEnvironment(specialService.getElement("Available") == null ? "" : specialService.getElement("Available")!.text ?? ""),
        price: double.parse(specialService.getElement("Price") == null ? "" : specialService.getElement("Price")!.text ?? ""),
      ));
    }
    return DomesticRates(
      rate: double.parse(document.getElement("Rate")!.text!),
      //TODO:
      availableServices: parsedSpecialServices,
    );
  }
}
//Functions
//---------------------------------------------------------------------------
void _errorThrower(String response){
  if(response.contains("<Error>")){
    XmlDocument xmlDocument = XmlDocument.from(response)!;
    XmlElement errorTag = xmlDocument.getChild("Error")!;
    String errorCode = errorTag.getChild("Number")!.text!;
    String errorDescription = errorTag.getChild("Description")!.text!;
    String errorSource = errorTag.getChild("Source")!.text!;
    throw USPSError(
      errorCode: errorCode, 
      description: errorDescription, 
      source: errorSource,
    );
  }
}
class USPSServiceType{
  static String firstClassCommercial = "";
  static String firstClass = "First Class";
  static String firstClassHFPCommercial = "First Class HFP Commercial";
  static String firstClassReturns = "First Class Returns";
  static String parcelSelectGround = "Parcel Select Ground";
  static String parcelSelectDE = "Parcel Select DE";
  static String parcelSelectLW = "Parcel Select LW";
  static String priority = "Priority";
  static String priorityCommercial = "Priority Commercial";
  static String priorityCPP = "Priority CPP";
  static String priorityHFPCommercial = "Priority HFP Commercial";
  static String priorityMailExpress = "Priority Mail Express";
  static String priorityMailExpressCommercial = "Priority Mail Express Commercial";
  static String priorityMailExpressCpp = "Priority Mail Express CPP";
  static String priorityMailExpressSh = "Priority Mail Express Sh";
  static String priorityMailExpressShCommercial = "Priority Mail Express Sh Commercial";
  static String priorityMailExpressHFP = "Priority Mail Express HFP";
  static String priorityMailExpressHFPCommercial = "Priority Mail Express HFP Commercial";
  static String priorityMailExpressHFPCPP = "Priority Mail Express HFP CPP";
  static String priorityMailCubic = "Priority Mail Cubic";
  static String priorityMailCubicReturns = "Priority Mail Cubic Returns";
  static String priorityMailReturns = "Priority Mail Returns";
  static String retailGround = "Retail Ground";
  static String groundReturns = "Ground Returns";
  static String media = "Media";
  static String library = "Library";
  static String all = "All";
  static String online = "Online";
  static String plus = "Plus";
  static String bpm = "BPM";
  static String connectLocal = "Connect Local";
}
class USPSContainer{
  static String variable = "VARIABLE";
  static String flatRateEnvelope = "FLAT RATE ENVELOPE";
  static String paddedFlatRateEnvelope = "PADDED FLAT RATE ENVELOPE";
  static String legalFlatRateEnvelope = "LEGAL FLAT RATE ENVELOPE";
  static String smFlatRateEnvelope = "SM FLAT RATE ENVELOPE";
  static String windowFlatRateEnvelope = "WINDOW FLAT RATE ENVELOPE";
  static String giftCardFlatRateEnvelope = "GIFT CARD FLAT RATE ENVELOPE";
  static String smFlateRateBox = "SM FLAT RATE BOX";
  static String mdFlatRateBox = "MD FLAT RATE BOX";
  static String lgFlatRateBox = "LG FLAT RATE BOX";
  static String regionalBoxA = "REGIONALRATEBOXA";
  static String regionalBoxB = "REGIONALRATEBOXB";
  static String cubicParcels = "CUBIC PARCELS";
  static String cubicSoftPack = "CUBIC SOFT PACK";
  static String smFlatRateBag = "SM FLAT RATE BAG";
  static String lgFlatRateBag = "LG FLAT RATE BAG";
  static String flatRateBox = "FLAT RATE BOX";
}
//USPS SDK
//---------------------------------------------------------------------------
class USPSSdk{
  USPSSdk({
    required this.userID,
  });
  final String userID;
  Future<USPSAddress> validate({
    required USPSAddress address,
  })async{
    String xmlBody = '''
<?xml version="1.0" ?>
<AddressValidateRequest USERID="$userID">
  <Revision>1</Revision>
  <Address ID="0">
    <FirmName>${address.firmName}</FirmName>
    <Address1>${address.address1}</Address1>
    <Address2>${address.address2}</Address2>
    <City>${address.city}</City>
    <State>${address.state}</State>
    <Urbanization>${address.urbanization}</Urbanization>
    <Zip5>${address.zip5}</Zip5>
    <Zip4>${address.zip4}</Zip4>
  </Address>
</AddressValidateRequest>
''';
    String response  = await SexyAPI(
      url: _uspsApiUrl,
      path: "/ShippingAPI.dll",
      parameters: {
        "API" : "Verify",
        "XML" : xmlBody,
      },
    ).get();
    _errorThrower(response);
    return USPSAddress.parse(response);
  }
  //ZIP Code Lookup API
  Future<USPSAddress> zipCodeLookupAPI({
    ///Firm Name
    String firmName = "",
    ///Delivery Address in the destination address. May contain secondary unit designator, such as APT or SUITE, for Accountable mail.)
    String address1 = "",
    ///Delivery Address in the
    ///destination address.
    ///Required for all mail and
    ///packages, however 11-
    ///digit Destination Delivery
    ///Point ZIP+4 Code can be
    ///provided as an alternative
    ///in the Detail 1 Record.
    required String address2,
    ///City name of the
    ///destination address. 
    String city = "",
    ///Two-character state code
    ///of the destination address
    String state = "",
    ///Urbanization.
    ///For Puerto Rico addresses only.
    String urbanization = "",
    ///Destination 5-digit ZIP
    ///Code. Numeric values (0-
    ///9) only. If International, all
    ///zeroes.
    String zip5 = "",
    ///Destination ZIP+4 Numeric
    ///values (0-9) only. If
    ///International, all zeroes.
    ///Default to spaces if not
    ///available.
    String zip4 = "",
  })async{
    String xmlBody = '''
    <?xml version="1.0" ?>
    <ZipCodeLookupRequest USERID="$userID">
      <Revision>1</Revision>
      <Address ID="0">
        <FirmName>$firmName</FirmName>
        <Address1>$address1</Address1>
        <Address2>$address2</Address2>
        <City>$city</City>
        <State>$state</State>
        <Urbanization>$urbanization</Urbanization>
        <Zip5>$zip5</Zip5>
        <Zip4>$zip4</Zip4>
      </Address>
    </ZipCodeLookupRequest>
    ''';
    String response  = await SexyAPI(
      url: _uspsApiUrl,
      path: "/ShippingAPI.dll",
      parameters: {
        "API" : "ZipCodeLookup",
        "XML" : xmlBody,
      },
    ).get();
    _errorThrower(response);
    return USPSAddress.parse(response);
  }
  //CityStateLookup API
  Future<USPSAddress> cityStateLookup({
    required int zip5,
  })async{
    String xmlBody = '''
    <CityStateLookupRequest USERID="$userID">
      <ZipCode ID='0'>
        <Zip5>$zip5</Zip5>
      </ZipCode>
    </CityStateLookupRequest>
    ''';
    String response  = await SexyAPI(
      url: _uspsApiUrl,
      path: "/ShippingAPI.dll",
      parameters: {
        "API" : "CityStateLookup",
        "XML" : xmlBody,
      },
    ).get();
    _errorThrower(response);
    return USPSAddress.parse(response);
  }
  Future<DomesticRates> domesticRates({
    required String uspsServiceType,
    required int zipOrigination,
    required int zipDestination,
    required double pounds,
    required double ounces,
    ///Value must be numeric. Units are inches. If partial
    ///dimensions are provided, an error response will
    ///return. Length, Width, Height are required for
    ///accurate pricing of a rectangular package when
    ///any dimension of the item exceeds 12 inches. In
    ///addition, Girth is required only for a nonrectangular package in addition to Length, Width,
    ///Height when any dimension of the package
    ///exceeds 12 inches. For rectangular packages,
    ///the Girth dimension must be left blank as this
    ///dimension is to only be used for nonrectangular packages.
    double width = 0,
    ///Value must be numeric. Units are inches. If partial
    ///dimensions are provided, an error response will
    ///return. Length, Width, Height are required for
    ///accurate pricing of a rectangular package when
    ///any dimension of the item exceeds 12 inches. In
    ///addition, Girth is required only for a nonrectangular package in addition to Length, Width,
    ///Height when any dimension of the package
    ///exceeds 12 inches. For rectangular packages,
    ///the Girth dimension must be left blank as this
    ///dimension is to only be used for nonrectangular packages.
    double height = 0,
    ///Value must be numeric. Units are inches. If partial
    ///dimensions are provided, an error response will
    ///return. Length, Width, Height are required for
    ///accurate pricing of a rectangular package when
    ///any dimension of the item exceeds 12 inches. In
    ///addition, Girth is required only for a nonrectangular package in addition to Length, Width,
    ///Height when any dimension of the package
    ///exceeds 12 inches. For rectangular packages,
    ///the Girth dimension must be left blank as this
    ///dimension is to only be used for nonrectangular packages.
    double length = 0,
    double value = 0,
    uspsContainer = "",
  })async{
    String xmlBody = '''
    <RateV4Request USERID="$userID">
    <Revision>2</Revision>
      <Package ID="0">
        <Service>$uspsServiceType</Service>
        <ZipOrigination>$zipOrigination</ZipOrigination>
        <ZipDestination>$zipDestination</ZipDestination>
        <Pounds>$pounds</Pounds>
        <Ounces>$ounces</Ounces>
        <Container>$uspsContainer</Container>
        <Width>$width</Width>
        <Length>$length</Length>
        <Height>$height</Height>
        <Girth></Girth>
        <Value>$value</Value>
        <Machinable>TRUE</Machinable>
      </Package>
    </RateV4Request>
    ''';
    String response  = await SexyAPI(
      url: _uspsApiUrl,
      path: "/ShippingAPI.dll",
      parameters: {
        "API" : "RateV4",
        "XML" : xmlBody,
      },
    ).get();
    _errorThrower(response);
    return DomesticRates.parse(response);
  }
  Future<String> internationalRates({
    required String uspsServiceType,
    required int zipOrigination,
    required int zipDestination,
    required double pounds,
    required double ounces,
    required String country,
    ///Value must be numeric. Units are inches. If partial
    ///dimensions are provided, an error response will
    ///return. Length, Width, Height are required for
    ///accurate pricing of a rectangular package when
    ///any dimension of the item exceeds 12 inches. In
    ///addition, Girth is required only for a nonrectangular package in addition to Length, Width,
    ///Height when any dimension of the package
    ///exceeds 12 inches. For rectangular packages,
    ///the Girth dimension must be left blank as this
    ///dimension is to only be used for nonrectangular packages.
    double width = 0,
    ///Value must be numeric. Units are inches. If partial
    ///dimensions are provided, an error response will
    ///return. Length, Width, Height are required for
    ///accurate pricing of a rectangular package when
    ///any dimension of the item exceeds 12 inches. In
    ///addition, Girth is required only for a nonrectangular package in addition to Length, Width,
    ///Height when any dimension of the package
    ///exceeds 12 inches. For rectangular packages,
    ///the Girth dimension must be left blank as this
    ///dimension is to only be used for nonrectangular packages.
    double height = 0,
    ///Value must be numeric. Units are inches. If partial
    ///dimensions are provided, an error response will
    ///return. Length, Width, Height are required for
    ///accurate pricing of a rectangular package when
    ///any dimension of the item exceeds 12 inches. In
    ///addition, Girth is required only for a nonrectangular package in addition to Length, Width,
    ///Height when any dimension of the package
    ///exceeds 12 inches. For rectangular packages,
    ///the Girth dimension must be left blank as this
    ///dimension is to only be used for nonrectangular packages.
    double length = 0,
    double value = 0,
    uspsContainer = "",
    required DateTime acceptanceDateTime,
    required int utc,
  })async{
    //Convert date time to UTC
    acceptanceDateTime = acceptanceDateTime.toUtc();
    String xmlBody = '''
    <IntlRateV2Request USERID= "$userID">
    <Revision>2</Revision>
    <Package ID="1ST">
      <Pounds>$pounds</Pounds>
      <Ounces>$ounces</Ounces>
      <Machinable>True</Machinable>
      <MailType>Package</MailType>
      <GXG>
        <POBoxFlag>Y</POBoxFlag>
        <GiftFlag>Y</GiftFlag>
      </GXG>
      <ValueOfContents>$value</ValueOfContents>
      <Country>$country</Country>
      <Container>$uspsContainer</Container>
      <Width>$width</Width>
      <Length>$length</Length>
      <Height>$height</Height>
      <Girth>0</Girth>
      <OriginZip>$zipOrigination</OriginZip>
      <CommercialFlag>N</CommercialFlag>
      <AcceptanceDateTime>${acceptanceDateTime.year}-${acceptanceDateTime.month}-${acceptanceDateTime.day}T${acceptanceDateTime.hour}:${acceptanceDateTime.minute}:${acceptanceDateTime.second}-$utc:${acceptanceDateTime.minute}</AcceptanceDateTime>
      <DestinationPostalCode>$zipDestination</DestinationPostalCode>
    </Package>
    </IntlRateV2Request>
    ''';
    String response  = await SexyAPI(
      url: _uspsApiUrl,
      path: "/ShippingAPI.dll",
      parameters: {
        "API" : "IntlRateV2",
        "XML" : xmlBody,
      },
    ).get();
    _errorThrower(response);
    return response;
  }
  Future<String> trackAndConfirm({
    ///Must be alphanumeric characters.
    required String trackID,
  })async{
    String xmlBody = '''
    <TrackRequest USERID="$userID">
      <TrackID ID="$trackID"></TrackID>
    </TrackRequest>
    ''';
    String response  = await SexyAPI(
      url: _uspsApiUrl,
      path: "/ShippingAPI.dll",
      parameters: {
        "API" : "TrackV2",
        "XML" : xmlBody,
      },
    ).get();
    _errorThrower(response);
    return response;
  }
}