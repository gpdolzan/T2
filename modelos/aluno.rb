# Trabalho 2: banco de dados usando ActiveRecord

# Gabriel Pimentel Dolzan - GRR20209948

require 'active_record'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :database => "BD.sqlite3"

class Aluno < ActiveRecord::Base;
    has_many :disciplinas, dependent: :destroy
    has_one :grr, dependent: :destroy
end