# this is used in config/environments/production.rb.
#don't wanna use NewRelic -Iratu
env "RAILS_LOG_TO_STDOUT", "true"

set :output, "log/whenever.log"

every 1.hour do
  runner "Maintenance.hourly"
end

every 1.day do
  runner "Maintenance.daily"
end

every 1.week, :at => "1:30 am" do
  runner "Maintenance.weekly"
end
