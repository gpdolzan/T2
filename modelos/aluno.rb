require 'active_record'

ActiveRecord::Base.establish_connection :adapter => "sqlite3",
                                        :adapter => "Tabelas.sqlite3"

class Aluno < ActiveRecord::Base;
    has_many :disciplinas, dependent: :destroy
    has_one :grr, dependent: :destroy
end