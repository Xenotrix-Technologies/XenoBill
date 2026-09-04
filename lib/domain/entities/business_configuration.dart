import 'package:equatable/equatable.dart';
import 'business_type.dart';
import 'business_features.dart';
import 'business_terminology.dart';

class BusinessConfiguration extends Equatable {
  final BusinessType type;
  final BusinessFeatures features;
  final BusinessTerminology terminology;

  const BusinessConfiguration({
    required this.type,
    required this.features,
    required this.terminology,
  });

  factory BusinessConfiguration.fromType(BusinessType type, {BusinessFeatures? customFeatures}) {
    return BusinessConfiguration(
      type: type,
      features: customFeatures ?? type.defaultFeatures,
      terminology: type.defaultTerminology,
    );
  }

  bool get isRetail => type == BusinessType.retail || type == BusinessType.supermarket || type == BusinessType.wholesale;
  bool get isService => type == BusinessType.service || type == BusinessType.freelancer || type == BusinessType.professionalService || type == BusinessType.salon || type == BusinessType.beauty || type == BusinessType.spa;
  bool get isRestaurant => type == BusinessType.restaurant || type == BusinessType.cafe || type == BusinessType.bakery;
  bool get isHotel => type == BusinessType.hotel;
  bool get isMixed => type == BusinessType.mixed || type == BusinessType.repair;
  bool get isOther => type == BusinessType.other;

  @override
  List<Object?> get props => [type, features, terminology];
}
