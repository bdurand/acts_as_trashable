require 'rubygems'
require File.expand_path('../../lib/acts_as_trashable', __FILE__)
require 'sqlite3'

module ActsAsTrashable
  module Test
    def self.create_database
      ActiveRecord::Base.establish_connection("adapter" => "sqlite3", "database" => ":memory:")
      ActsAsTrashable::TrashRecord.create_table
    end

    def self.delete_database
      ActiveRecord::Base.connection.drop_table(ActsAsTrashable::TrashRecord.table_name)
      ActiveRecord::Base.connection.disconnect!
    end
  end
end
