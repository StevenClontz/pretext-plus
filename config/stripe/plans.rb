Stripe.plan :pretextplus_sustaining do |plan|
  # plan name as it will appear on credit card statements
  plan.name = "PreTeXt.Plus Sustaining Tier"

  # amount in cents.
  plan.amount = 500

  # currency to use for the plan (default 'usd')
  plan.currency = "usd"

  # interval must be either 'day', 'week', 'month' or 'year'
  plan.interval = "month"

  # only bill once every interval_count months (default 1)
  plan.interval_count = 1

  # number of days before charging customer's card (default 0)
  plan.trial_period_days = 0
end

# Once you have your plans defined, you can run
#
#   rake stripe:prepare
#
# This will export any new plans to stripe.com so that you can
# begin using them in your API calls.
