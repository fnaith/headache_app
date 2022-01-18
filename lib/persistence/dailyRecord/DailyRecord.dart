class DailyRecord {
  static int getDate(DateTime dateTime) {
    return dateTime.year * 1000 + dateTime.month * 10 + dateTime.day;
  }

  int date = -1;
  int morningPainScale = 0;
  int afternoonPainScale = 0;
  int nightPainScale = 0;
  int sleepingPainScale = 0;
  int headacheHours = 0;
  int headacheMinutes = 0;

  bool disgusted = false;
  bool vomited = false;
  bool dizzy = false;
  bool sensitiveToLight = false;
  bool sensitiveToSound = false;
  bool sensitiveToSmell = false;
  bool headacheLikeBeating = false;
  bool headacheStartFromOneSide = false;
  bool painPointRunningAround = false;
  bool physicalActivityAggravateHeadache = false;
  bool eyeFlashes = false;
  bool partialBlindness = false;

  String medicineUsage = "[]";

  int dailyStressScale = 0;
  bool hasMenstruation = false;
  bool hasRestlessLegSyndrome = false;
  String diastolicBloodPressure = "";
  String systolicBloodPressure = "";

  DailyRecord(this.date);
  DailyRecord.fromMap(Map<String, dynamic> map) {
    date = map['date'];
    morningPainScale = map['morningPainScale'];
    afternoonPainScale = map['afternoonPainScale'];
    nightPainScale = map['nightPainScale'];
    sleepingPainScale = map['sleepingPainScale'];
    headacheHours = map['headacheHours'];
    headacheMinutes = map['headacheMinutes'];

    disgusted = map['disgusted'] != 0;
    vomited = map['vomited'] != 0;
    dizzy = map['dizzy'] != 0;
    sensitiveToLight = map['sensitiveToLight'] != 0;
    sensitiveToSound = map['sensitiveToSound'] != 0;
    sensitiveToSmell = map['sensitiveToSmell'] != 0;
    headacheLikeBeating = map['headacheLikeBeating'] != 0;
    headacheStartFromOneSide = map['headacheStartFromOneSide'] != 0;
    painPointRunningAround = map['painPointRunningAround'] != 0;
    physicalActivityAggravateHeadache = map['physicalActivityAggravateHeadache'] != 0;
    eyeFlashes = map['eyeFlashes'] != 0;
    partialBlindness = map['partialBlindness'] != 0;

    medicineUsage = map['medicineUsage'];

    dailyStressScale = map['dailyStressScale'];
    hasMenstruation = map['hasMenstruation'] != 0;
    hasRestlessLegSyndrome = map['hasRestlessLegSyndrome'] != 0;
    diastolicBloodPressure = map['diastolicBloodPressure'];
    systolicBloodPressure = map['systolicBloodPressure'];
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'morningPainScale': morningPainScale,
      'afternoonPainScale': afternoonPainScale,
      'nightPainScale': nightPainScale,
      'sleepingPainScale': sleepingPainScale,
      'headacheHours': headacheHours,
      'headacheMinutes': headacheMinutes,

      'dailyStressScale': dailyStressScale,
      'disgusted': disgusted ? 1 : 0,
      'vomited': vomited ? 1 : 0,
      'dizzy': dizzy ? 1 : 0,
      'sensitiveToLight': sensitiveToLight ? 1 : 0,
      'sensitiveToSound': sensitiveToSound ? 1 : 0,
      'sensitiveToSmell': sensitiveToSmell ? 1 : 0,
      'headacheLikeBeating': headacheLikeBeating ? 1 : 0,
      'headacheStartFromOneSide': headacheStartFromOneSide ? 1 : 0,
      'painPointRunningAround': painPointRunningAround ? 1 : 0,
      'physicalActivityAggravateHeadache': physicalActivityAggravateHeadache ? 1 : 0,
      'eyeFlashes': eyeFlashes ? 1 : 0,
      'partialBlindness': partialBlindness ? 1 : 0,

      'medicineUsage': medicineUsage,

      'dailyStressScale': dailyStressScale,
      'hasMenstruation': hasMenstruation ? 1 : 0,
      'hasRestlessLegSyndrome': hasRestlessLegSyndrome ? 1 : 0,
      'diastolicBloodPressure': diastolicBloodPressure,
      'systolicBloodPressure': systolicBloodPressure
    };
  }
}
