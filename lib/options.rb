# TODO change all to maps instead of arrays
# and change usage across the entire app

module Options
  BEVERAGE = [
    'americano',
    'cappucino',
    'coffee',
    'chai',
    'dirty_chai',
    'espesso',
    'hot_chocolate',
    'latte',
    'macchiato',
    'mocha',
    'steam_milk',
    'white_mocha'
  ]

  DECAF = [
    nil,
    'decaf',
    'halfcaf'
  ]

  LOCATION = [
    'here',
    'to_go'
  ]

  MILK = [
    nil,
    'almond',
    'skim',
    'soy',
    'whole'
  ]

  STATUSES = {
    abandonded: 'abandonded',
    cancelled: 'cancelled',
    in_progress: 'in_progress',
    made: 'made',
    pending: 'pending',
    retrieved: 'retrieved'
  }

  TEMPERATURE = [
    'cold',
    'hot'
  ]
end

