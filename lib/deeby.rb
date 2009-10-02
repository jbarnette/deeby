class Deeby
  VERSION = "1.0.0"

  ACTIVE = "config/database.yml"
  BACKUP = "config/database.yml.deeby"

  def self.swap engine
    temp = "config/database.#{engine}.yml"

    cp ACTIVE, BACKUP
    cp temp, ACTIVE
    at_exit { cp BACKUP, ACTIVE ; rm BACKUP }
  end
end

Dir["config/database.*.yml"].each do |f|
  next unless /database\.(\w+)\.yml$/ =~ f
  desc "Temporarily switch the DB to #{$1}."
  task("db:#{$1}") { Deeby.swap $1  }
end
