require 'active_record'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :adapter => "Tabelas.sqlite3"

class Disciplina < ActiveRecord::Base;
    belongs_to :Aluno
    has_and_belongs_to_many :departamentos, -> {distinct}
end