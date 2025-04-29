require 'active_record'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :adapter => "Tabelas.sqlite3"

class Grr < ActiveRecord::Base;
  belongs_to :aluno
end