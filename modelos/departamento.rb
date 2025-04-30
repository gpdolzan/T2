# Trabalho 2: banco de dados usando ActiveRecord

# Gabriel Pimentel Dolzan - GRR20209948

require 'active_record'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :database => "BD.sqlite3"

class Departamento < ActiveRecord::Base;
    has_and_belongs_to_many :disciplinas, -> {distinct}
end