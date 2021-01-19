import stats, algorithm, math
from strutils import align, alignLeft

type
  AggregateResult = object
    count: int
    min, max, sum, average, median, percentile95: float64
  RoundType = enum
    roundOff, ceil, floor
  PaddingType = enum
    right, left

proc percentile(datas: openArray[float64], percent: int): float64 =
    ## datas はソート済みでなければならない。
    var pos = int((datas.len + 1) * percent / 100)
    if pos < 0:
      pos = 0
    elif datas.len <= pos:
      pos = datas.len - 1
    result = datas[pos]

proc aggregate(data: seq[float64], needMedian = false, needPercentile95 = false): AggregateResult =
  var rs: RunningStat
  rs.push(data)
  result.count = rs.n
  result.min = rs.min
  result.max = rs.max
  result.sum = rs.sum
  result.average = rs.mean

  var data = data
  if needMedian or needPercentile95:
    data.sort
  if needMedian:
    result.median = data.percentile(50)
  if needPercentile95:
    result.percentile95 = data.percentile(95)

proc formatInt(data: float64, roundType = roundOff, paddingType = right, padChar = ' ', paddingDigit = 0): string =
  let num =
    case roundType
    of roundOff: data.round
    of ceil: data.ceil
    of floor: data.floor

  result = $num
  if 0 < paddingDigit:
    result =
      case paddingType
      of right: result.align(paddingDigit, padChar)
      of left: result.alignLeft(paddingDigit, padChar)

when isMainModule and not defined modeTest:
  discard
