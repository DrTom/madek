FactoryGirl.define do

  factory :meta_datum_date do
    string "2011-01-01"
    meta_key {MetaKey.find_by_id 8}
  end

end

