require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    @columns ||= 
      DBConnection.execute2(<<-SQL).first.map {|column| column.to_sym}
        SELECT * 
        FROM "#{table_name}"
      SQL
  end

  def self.finalize!
    self.columns.each do |column|
      define_method(column) do
        self.attributes[column]
      end

      define_method("#{column}=") do |arg|
        self.attributes[column] = arg
      end
    end
  end
  

  def self.table_name=(table_name)

    @table_name ||= table_name
  end

  def self.table_name
    @table_name ||= "#{self}".tableize
  end

  def self.all
    all_this_stuff = DBConnection.execute(<<-SQL)
      SELECT 
        *
      FROM
        "#{table_name}"
      
    SQL

    parse_all(all_this_stuff)
  end

  def self.parse_all(results)
    results.map do |result|
      self.new(result)
    end
  end

  def self.find(id)
    thing = DBConnection.execute(<<-SQL, id).first
      SELECT
        *
      FROM 
        "#{table_name}"
      WHERE
        id = ?
      LIMIT 
        1
    SQL

  end

  def initialize(params = {})
    params.each_pair do |attr_name, val| 
      attr_name = attr_name.to_sym
      unless self.class.columns.include?(attr_name)
        raise("unknown attribute '#{attr_name}'")
      end

      send("#{attr_name}=", val) 
    end
  end

  def attributes
    @attributes ||= Hash.new
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
