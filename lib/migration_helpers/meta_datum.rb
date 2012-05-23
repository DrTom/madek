module MigrationHelpers

  module MetaDatum


    class RawMetaDatum < ActiveRecord::Base 
      set_table_name :meta_data

      class << self
        def migrate_meta_date raw_meta_datum
          obj = YAML.load raw_meta_datum.value.gsub /^-\s+.*\n/, ""
          new_string_value=  
            if obj.is_a? Hash
              obj.try(:fetch,"free_text").try(:strip)
            else
              ""
            end
          raw_meta_datum.update_attributes ({ 
              string: new_string_value, 
              value: nil
              })
          raw_meta_datum.update_column :type, "MetaDatumDate"
        end
      end

    end



  end
end