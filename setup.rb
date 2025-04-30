# Trabalho 2: banco de dados usando ActiveRecord

# Gabriel Pimentel Dolzan - GRR20209948

$:.push './'
require 'rubygems'
require 'active_record'
require 'modelos/aluno.rb'
require 'modelos/grr.rb'
require 'modelos/disciplina.rb'
require 'modelos/departamento.rb'

# Criação das tabelas

def inicia_alunos
  ActiveRecord::Base.connection.create_table :alunos do |t|
    t.string :nome
    t.string :email
  end
end

# 1-1: Aluno -> GRR

def inicia_grrs
  ActiveRecord::Base.connection.create_table :grrs do |t|
    t.string     :numero
    t.references :aluno, foreign_key: true
  end
end

# 1-n: Aluno -> Disciplina

def inicia_disciplinas
  ActiveRecord::Base.connection.create_table :disciplinas do |t|
    t.string     :nome
    t.string     :codigo
    t.references :aluno, foreign_key: true
  end
end

# n-n: join table entre Departamento e Disciplina

def inicia_departamentos
  ActiveRecord::Base.connection.create_table :departamentos do |t|
    t.string :nome
  end
end

# join table sem id

def inicia_departamentos_disciplinas
  ActiveRecord::Migration.suppress_messages do
    ActiveRecord::Migration.create_table :departamentos_disciplinas, id: false do |t|
      t.belongs_to :departamento
      t.belongs_to :disciplina
    end
  end
end

# População de dados

def popula_alunos
  lista = [
    { nome: 'João',     email: 'joao@example.com' },
    { nome: 'Maria', email: 'maria@example.com' },
    { nome: 'Pedro',   email: 'pedro@example.com' },
    { nome: 'Ana',      email: 'ana@example.com' }
  ]
  lista.each { |attrs| Aluno.create!(attrs) }
end

def popula_grrs
  Aluno.all.each_with_index do |aluno, idx|
    Grr.create!(numero: format('GRR202500%02d', idx+1), aluno: aluno)
  end
end

def popula_disciplinas
  dados = [
    { nome: 'Matemática', codigo: 'MAT101', aluno_id: 1 },
    { nome: 'Física',     codigo: 'FIS102', aluno_id: 1 },
    { nome: 'Química',    codigo: 'QUI103', aluno_id: 2 },
    { nome: 'Biologia',   codigo: 'BIO104', aluno_id: 2 },
    { nome: 'História',   codigo: 'HIS105', aluno_id: 3 },
    { nome: 'Geografia',  codigo: 'GEO106', aluno_id: 4 }
  ]
  dados.each do |d|
    Disciplina.create!(nome: d[:nome], codigo: d[:codigo], aluno_id: d[:aluno_id])
  end
end

def popula_departamentos
  ['Ciências Exatas', 'Ciências Biológicas', 'Ciências Humanas'].each do |nome|
    Departamento.create!(nome: nome)
  end
end

def popula_departamentos_disciplinas
  exatas      = Departamento.find_by(nome: 'Ciências Exatas')
  biologicas  = Departamento.find_by(nome: 'Ciências Biológicas')
  humanas     = Departamento.find_by(nome: 'Ciências Humanas')

  mat = Disciplina.find_by(codigo: 'MAT101')
  fis = Disciplina.find_by(codigo: 'FIS102')
  qui = Disciplina.find_by(codigo: 'QUI103')
  bio = Disciplina.find_by(codigo: 'BIO104')
  his = Disciplina.find_by(codigo: 'HIS105')
  geo = Disciplina.find_by(codigo: 'GEO106')

  exatas.disciplinas   << mat << fis << qui
  biologicas.disciplinas << qui << bio
  humanas.disciplinas  << his << geo
end

def popula_tudo
  popula_alunos
  popula_grrs
  popula_disciplinas
  popula_departamentos
  popula_departamentos_disciplinas
end

# Inicializa o ambiente: conexão, criação de tabelas e população
def inicia_ambiente
  ActiveRecord::Base.establish_connection(
    adapter:  'sqlite3',
    database: 'BD.sqlite3'
  )

  inicia_alunos
  inicia_grrs
  inicia_disciplinas
  inicia_departamentos
  inicia_departamentos_disciplinas
  popula_tudo

  puts "Banco de dados inicializado e populado com sucesso!"
end

inicia_ambiente