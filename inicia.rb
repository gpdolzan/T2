$:.push './'
require 'rubygems'
require 'active_record'
require 'modelos/aluno.rb'
require 'modelos/departamento.rb'
require 'modelos/disciplina.rb'
require 'modelos/grr.rb'

def inicia_aluno
  ActiveRecord::Base.connection.create_table :aluno do |t|
    t.string :nome
    t.string :idade
    t.string :sexo
    t.string :cpf
  end
end

# def inicia_departamento
# def inicia_disciplina
# def inicia_grr