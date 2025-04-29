require 'active_record'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :adapter => "Tabelas.sqlite3"

class Departamento < ActiveRecord::Base;
    has_and_belongs_to_many :disciplinas, -> {distinct}
end