

const USD_RATE = 1404.51;
const DONG_RATE = 0.055;
const YEN_RATE = 9.07;
const YIAN_RATE = 193.91;
const TAIWAN_DOLLAR_RATE = 43.11;

const exchangeRateMap = {
  'usd': {
    'name': 'US Dollar',
    'symbol': 'USD',
    'rate': USD_RATE,
  },
  'dong': {
    'name': 'Vietnam Dong',
    'symbol': 'VND',
    'rate': DONG_RATE,
  },
  'yen': {
    'name': 'Japan Yen',
    'symbol': 'JPY',
    'rate': YEN_RATE
  },
  'yian': {
    'name': 'Chinese Yian',
    'symbol': 'CNY',
    'rate': YIAN_RATE
  },
  'taiwan': {
    'name': 'Taiwan Dollar',
    'symbol': 'TWD',
    'rate': TAIWAN_DOLLAR_RATE,
  }
};