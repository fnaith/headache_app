class DailyRecord {
  static int getDate(DateTime dateTime) {
    return calculateDate(dateTime.year, dateTime.month, dateTime.day);
  }

  static int calculateDate(int year, int month, int day) {
    return year * 10000 + month * 100 + day;
  }

  int date = -1;
  int morningPainScale = 0;
  int afternoonPainScale = 0;
  int nightPainScale = 0;
  int sleepingPainScale = 0;
  int headacheHours = 0;
  int headacheMinutes = 0;
  String headacheRemark = "";

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
  bool causeByTemperatureChange = false;
  bool causeByWindBlow = false;
  bool causeByMuscleTightness = false;

  String medicineUsage = "[]";

  String dailyActivityRemark = "";
  int dailyStressScale = 0;
  bool haveMenstruation = false;
  bool haveRestlessLegSyndrome = false;
  String bodyTemperature = "";
  String diastolicBloodPressure = "";
  String systolicBloodPressure = "";
  bool haveSeeADoctor = false;
  bool haveEnoughSleep = true;
  bool haveEnoughWater = true;
  bool haveEnoughMeal = true;
  bool haveExercise = false;
  bool haveCoffee = false;
  bool haveAlcohol = false;
  bool haveSmoke = false;

  DailyRecord(this.date);
  DailyRecord.fromMap(Map<String, dynamic> map) {
    date = map['date'];
    morningPainScale = map['morningPainScale'];
    afternoonPainScale = map['afternoonPainScale'];
    nightPainScale = map['nightPainScale'];
    sleepingPainScale = map['sleepingPainScale'];
    headacheHours = map['headacheHours'];
    headacheMinutes = map['headacheMinutes'];
    headacheRemark = map['headacheRemark'];

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
    causeByTemperatureChange = map['causeByTemperatureChange'] != 0;
    causeByWindBlow = map['causeByWindBlow'] != 0;
    causeByMuscleTightness = map['causeByMuscleTightness'] != 0;

    medicineUsage = map['medicineUsage'];

    dailyActivityRemark = map['dailyActivityRemark'];
    dailyStressScale = map['dailyStressScale'];
    haveMenstruation = map['haveMenstruation'] != 0;
    haveRestlessLegSyndrome = map['haveRestlessLegSyndrome'] != 0;
    bodyTemperature = map['bodyTemperature'];
    diastolicBloodPressure = map['diastolicBloodPressure'];
    systolicBloodPressure = map['systolicBloodPressure'];
    if (null != map['haveSeeADoctor']) {
      haveSeeADoctor = map['haveSeeADoctor'] != 0;
    }
    haveEnoughSleep = map['haveEnoughSleep'] != 0;
    haveEnoughWater = map['haveEnoughWater'] != 0;
    haveEnoughMeal = map['haveEnoughMeal'] != 0;
    haveExercise = map['haveExercise'] != 0;
    haveCoffee = map['haveCoffee'] != 0;
    haveAlcohol = map['haveAlcohol'] != 0;
    haveSmoke = map['haveSmoke'] != 0;
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
      'headacheRemark': headacheRemark,

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
      'causeByTemperatureChange': causeByTemperatureChange ? 1 : 0,
      'causeByWindBlow': causeByWindBlow ? 1 : 0,
      'causeByMuscleTightness': causeByMuscleTightness ? 1 : 0,

      'medicineUsage': medicineUsage,

      'dailyActivityRemark': dailyActivityRemark,
      'dailyStressScale': dailyStressScale,
      'haveMenstruation': haveMenstruation ? 1 : 0,
      'haveRestlessLegSyndrome': haveRestlessLegSyndrome ? 1 : 0,
      'bodyTemperature': bodyTemperature,
      'diastolicBloodPressure': diastolicBloodPressure,
      'systolicBloodPressure': systolicBloodPressure,
      'haveSeeADoctor': haveSeeADoctor ? 1 : 0,
      'haveEnoughSleep': haveEnoughSleep ? 1 : 0,
      'haveEnoughWater': haveEnoughWater ? 1 : 0,
      'haveEnoughMeal': haveEnoughMeal ? 1 : 0,
      'haveExercise': haveExercise ? 1 : 0,
      'haveCoffee': haveCoffee ? 1 : 0,
      'haveAlcohol': haveAlcohol ? 1 : 0,
      'haveSmoke': haveSmoke ? 1 : 0
    };
  }
}
