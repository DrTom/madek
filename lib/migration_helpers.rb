require 'sql_helper'

module MigrationHelpers
  include ::SQLHelper
  extend ::SQLHelper
  extend self


  def ref_id model
    model.table_name.singularize + "_id"
  end



######################################################################
# general constraints
######################################################################

  def add_check table_name, check
    execute_sql "ALTER TABLE #{table_name} ADD CHECK #{check} ;"
  end

  def add_not_null_constraint table, col
    table_name = infer_table_name table
    col_name = infer_column_name col
    constraint_name = "#{table_name}_#{col_name}_not_null"
    if adapter_is_mysql?
      raise "add_not_null_constraint will only work for foreign_keys and models with mysql " if not (col.is_a? Class)
      execute_sql "ALTER TABLE #{table_name} Modify #{col_name} INTEGER NOT NULL; "
    elsif adapter_is_postgresql?
      execute_sql "ALTER TABLE #{table_name} ALTER COLUMN #{col_name} SET NOT NULL;"
    else
      raise "sorry! your db-adapter is not supported"
    end
  end

  def drop_not_null_constraint table, col, colinfo=nil
    table_name = infer_table_name table
    col_name = infer_column_name col
    if adapter_is_postgresql?
      execute_sql "ALTER TABLE #{table_name} ALTER COLUMN #{col_name} DROP NOT NULL;"
    elsif adapter_is_mysql?
      unless colinfo
        rails "mysql usese MODIFY, you need to specify the full column information for mysql"
      else
        execute_sql "ALTER TABLE #{table_name} MODIFY #{col_name} #{colinfo};"
      end
    else
      raise "your adapter is not supported yet"
    end
  end

  def add_unique_constraint table, col
    # if required make col optionally an array, because unique can refer to multiple cols
     
    table_name = infer_table_name table
    col_name = infer_column_name col
    constraint_name = "#{table_name}_#{col_name}_unique"
    execute_sql "ALTER TABLE #{table_name} ADD CONSTRAINT #{constraint_name} UNIQUE (#{col_name});"
  end


  def create_del_referenced_trigger source, target
    source_table_name = source.class == String ? source : source.table_name
    target_table_name = target.class == String ? target : target.table_name

    fkey = target_table_name.singularize + "_id"
    fun_name = "delref_fkey_#{target_table_name}_#{source_table_name}_#{fkey}"

    if SQLHelper.adapter_is_postgresql?
      execute create_del_referenced_trigger_pgsql  source_table_name, target_table_name, fkey, fun_name
    else
      # TODO warn
    end
  end


  def drop_del_referenced_trigger source, target
    source_table_name = source.class == String ? source : source.table_name
    target_table_name = target.class == String ? target : target.table_name
    fkey = target_table_name.singularize + "_id"
    fun_name = "delref_fkey_#{target_table_name}_#{source_table_name}_#{fkey}"


    if SQLHelper.adapter_is_postgresql?
      execute drop_del_referenced_trigger_pgsql  fun_name, source_table_name
    else
      # TODO warn
    end
  end

######################################################################
# misc pulic helpers
######################################################################

  def infer_table_name table
    if table.is_a? Class
      table.table_name
    else
      table.to_s
    end
  end

  def infer_column_name col
    if col.is_a? Class # col is a model that is referenced, i.e. a fkey
      fkey_name col
    else
      col.to_s
    end
  end

  def fkey_name table
    table_name = 
      if table.is_a? Class
        table.table_name
      else
        table.to_s
      end
    (ActiveSupport::Inflector.singularize table_name)+ "_id"
  end


######################################################################
# misc private helpers
######################################################################

  def shorten_schema_names fun_name
    if fun_name.size > 63
      fun_name.slice(0,20) + (Digest::SHA1.hexdigest fun_name) 
    else
      fun_name
    end
  end

  def drop_del_referenced_trigger_pgsql fun_name, table_name
    fun_name = shorten_schema_names fun_name
    <<-SQL
      DROP TRIGGER #{fun_name} ON #{table_name};
      DROP FUNCTION #{fun_name}();
    SQL
  end

  def create_del_referenced_trigger_pgsql source_table, target_table, fkey, fun_name

    fun_name = shorten_schema_names fun_name

    <<-SQL
      CREATE FUNCTION #{fun_name}() 
      RETURNS trigger
      AS $$
      DECLARE
      BEGIN
        DELETE FROM #{target_table} WHERE id = OLD.#{fkey};
        RETURN OLD;
      END $$
      LANGUAGE PLPGSQL;

      CREATE TRIGGER #{fun_name}
        AFTER DELETE
        ON #{source_table}
        FOR EACH ROW execute procedure #{fun_name}();
      SQL
  end
end
