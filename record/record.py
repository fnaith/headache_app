import csv
import math
import json

def list_to_daily_record(id, column):
  daily_record = {}
  daily_record['date'] = id
  daily_record['morningPainScale'] = int(int(0 if '' == column[0] else column[0]) * 11 / 3)
  daily_record['afternoonPainScale'] = int(int(0 if '' == column[1] else column[1]) * 11 / 3)
  daily_record['nightPainScale'] = int(int(0 if '' == column[2] else column[2]) * 11 / 3)
  daily_record['sleepingPainScale'] = int(int(0 if '' == column[3] else column[3]) * 11 / 3)
  daily_record['disgusted'] = 0 if '' == column[4] else 1
  daily_record['vomited'] = 0 if '' == column[5] else 1
  daily_record['sensitiveToLight'] = 0 if '' == column[6] else 1
  daily_record['sensitiveToSound'] = 0 if '' == column[7] else 1
  daily_record['headacheLikeBeating'] = 0 if '' == column[8] else 1
  daily_record['headacheStartFromOneSide'] = 0 if '' == column[9] else 1
  daily_record['physicalActivityAggravateHeadache'] = 0 if '' == column[10] else 1
  daily_record['eyeFlashes'] = 0 if '' == column[11] else 1
  daily_record['partialBlindness'] = 0 if '' == column[12] else 1
  daily_record['headacheHours'] = int(float(column[13]))
  daily_record['headacheMinutes'] = int(int(60 * (float(column[13]) - daily_record['headacheHours'])) / 5) * 5
  daily_record['medicineUsage'] = json.dumps([
    {
      "id": 0,
      "name": '舒腦 Suzin 5 mg',
      "isPainkiller": False,
      "quantity": column[14],
      "effectiveDegree": -1
    },
    {
      "id": 1,
      "name": '英明格 Imigran 50 mg',
      "isPainkiller": True,
      "quantity": column[15],
      "effectiveDegree": 0 if '' == column[18] else 1
    },
    {
      "id": 2,
      "name": '中藥',
      "isPainkiller": False,
      "quantity": column[16],
      "effectiveDegree": -1
    },
    {
      "id": 3,
      "name": '心康樂 Cardolol 40 mg',
      "isPainkiller": False,
      "quantity": column[17],
      "effectiveDegree": -1
    }
  ], ensure_ascii=False)
  daily_record['haveRestlessLegSyndrome'] = 0 if '' == column[19] else 1
  daily_record['haveMenstruation'] = 0 if '' == column[20] else 1
  daily_record['headacheRemark'] = ''
  daily_record['dizzy'] = 0
  daily_record['sensitiveToSmell'] = 0
  daily_record['painPointRunningAround'] = 0
  daily_record['causeByTemperatureChange'] = 0
  daily_record['causeByWindBlow'] = 0
  daily_record['causeByMuscleTightness'] = 0
  daily_record['dailyStressScale'] = 0
  daily_record['bodyTemperature'] = ''
  daily_record['diastolicBloodPressure'] = ''
  daily_record['systolicBloodPressure'] = ''
  daily_record['haveEnoughSleep'] = 0
  daily_record['haveEnoughWater'] = 0
  daily_record['haveEnoughMeal'] = 0
  daily_record['haveExercise'] = 0
  daily_record['haveCoffee'] = 0
  daily_record['haveAlcohol'] = 0
  daily_record['haveSmoke'] = 0
  daily_record['dailyActivityRemark'] = ''
  return daily_record

def csv_to_json(file_path, year, month):
  with open(file_path, 'r', encoding='UTF-8') as csv_file:
    rows = list(csv.reader(csv_file))
    if 22 != len(rows):
      raise Exception('invalid row number %d' % (len(rows)))
    for row in rows:
      if 32 != len(row):
        raise Exception('invalid column number %d' % (len(row)))
    header = rows.pop(0)
    header.pop(0)
    for i in range(31):
      if str(i + 1) != header[i]:
        raise Exception('invalid header day %d' % (i + 1))
    fields = [
      '早上', '下午', '晚上', '睡眠',
      '噁心', '嘔吐', '光線', '聲音', '脈搏', '單側', '活動', '閃光', '部分', '小時', 
      '藥物-舒腦', '藥物-英明格', '藥物-中藥', '藥物-心康樂', '止痛-英明格',
      '不寧腿', '月經'
    ]
    for i in range(len(rows)):
      row = rows[i]
      field = row.pop(0)
      if fields[i] != field:
        raise Exception('invalid fidld %d %s' % (i, field))

    columns = []
    for i in range(31):
      column = []
      all_empty = True
      for row in rows:
        value = row[i]
        column.append(value)
        if "" != value:
          all_empty = False
      if not all_empty:
        id = year * 10000 + month * 100 + (i + 1)
        columns.append(list_to_daily_record(id, column))
    return columns

daily_records = []

daily_records.extend(csv_to_json('record - 2018-10.csv', 2018, 10))
daily_records.extend(csv_to_json('record - 2018-11.csv', 2018, 11))
daily_records.extend(csv_to_json('record - 2018-12.csv', 2018, 12))

daily_records.extend(csv_to_json('record - 2019-01.csv', 2019, 1))
daily_records.extend(csv_to_json('record - 2019-02.csv', 2019, 2))
daily_records.extend(csv_to_json('record - 2019-03.csv', 2019, 3))
daily_records.extend(csv_to_json('record - 2019-04.csv', 2019, 4))
daily_records.extend(csv_to_json('record - 2019-05.csv', 2019, 5))
daily_records.extend(csv_to_json('record - 2019-06.csv', 2019, 6))
daily_records.extend(csv_to_json('record - 2019-07.csv', 2019, 7))
daily_records.extend(csv_to_json('record - 2019-08.csv', 2019, 8))
daily_records.extend(csv_to_json('record - 2019-09.csv', 2019, 9))
daily_records.extend(csv_to_json('record - 2019-10.csv', 2019, 10))
daily_records.extend(csv_to_json('record - 2019-11.csv', 2019, 11))
daily_records.extend(csv_to_json('record - 2019-12.csv', 2019, 12))

daily_records.extend(csv_to_json('record - 2020-01.csv', 2020, 1))
daily_records.extend(csv_to_json('record - 2020-02.csv', 2020, 2))
daily_records.extend(csv_to_json('record - 2020-03.csv', 2020, 3))
daily_records.extend(csv_to_json('record - 2020-04.csv', 2020, 4))
daily_records.extend(csv_to_json('record - 2020-05.csv', 2020, 5))
daily_records.extend(csv_to_json('record - 2020-06.csv', 2020, 6))
daily_records.extend(csv_to_json('record - 2020-07.csv', 2020, 7))
daily_records.extend(csv_to_json('record - 2020-08.csv', 2020, 8))
daily_records.extend(csv_to_json('record - 2020-09.csv', 2020, 9))
daily_records.extend(csv_to_json('record - 2020-10.csv', 2020, 10))
daily_records.extend(csv_to_json('record - 2020-11.csv', 2020, 11))
daily_records.extend(csv_to_json('record - 2020-12.csv', 2020, 12))

daily_records.extend(csv_to_json('record - 2021-01.csv', 2021, 1))
daily_records.extend(csv_to_json('record - 2021-02.csv', 2021, 2))
daily_records.extend(csv_to_json('record - 2021-03.csv', 2021, 3))
daily_records.extend(csv_to_json('record - 2021-04.csv', 2021, 4))
daily_records.extend(csv_to_json('record - 2021-05.csv', 2021, 5))
daily_records.extend(csv_to_json('record - 2021-06.csv', 2021, 6))
daily_records.extend(csv_to_json('record - 2021-07.csv', 2021, 7))
daily_records.extend(csv_to_json('record - 2021-08.csv', 2021, 8))
daily_records.extend(csv_to_json('record - 2021-09.csv', 2021, 9))
daily_records.extend(csv_to_json('record - 2021-10.csv', 2021, 10))
daily_records.extend(csv_to_json('record - 2021-11.csv', 2021, 11))

with open('dailyRecords.txt', 'w', encoding='UTF-8') as output_file:
  output_file.write(json.dumps(daily_records, ensure_ascii=False))
