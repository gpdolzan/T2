# Trabalho 2: banco de dados usando ActiveRecord

# Gabriel Pimentel Dolzan - GRR20209948

require 'active_record'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :database => "BD.sqlite3"

class Disciplina < ActiveRecord::Base;
    belongs_to :aluno
    has_and_belongs_to_many :departamentos, -> {distinct}
end