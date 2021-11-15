Ransack.configure do |config|
  config.add_predicate 'has_every_term', arel_predicate: 'matches_all', formatter: proc { |v|
    v.split(/[[:blank:]]+/).map do |t|
      "%#{t.to_s.gsub(/([\\%_.])/, '\\\\\\1')}%"
    end
  }
end
