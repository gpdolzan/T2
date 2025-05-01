# Trabalho 2: banco de dados usando ActiveRecord

# Gabriel Pimentel Dolzan - GRR20209948

$:.push './'
require 'setup.rb'
require 'modelos/aluno.rb'
require 'modelos/grr.rb'
require 'modelos/disciplina.rb'
require 'modelos/departamento.rb'

# Exibe a lista de comandos disponíveis
def commands
  puts <<~CMD
    Comandos:
      ajuda                                 -> Lista comandos
      tabelas                               -> Lista tabelas disponíveis
      exit                                  -> Sai do programa

    Exemplo de operações em tabelas:
      insere <tabela> { atributo=valor ... }
      lista <tabela> { atributo=valor ... }
      exclui <tabela> { atributo=valor ... }
      altera <tabela> { atributo=valor ... }

    Associação Departamento-Disciplina:
      associa_dep_disc dept_id=<id> disciplina_id=<id>   -> Cria vínculo M-N
      lista dep_disc                                     -> Lista todas as associações
  CMD
end

# Insere um registro na tabela especificada
def insere_in(tabela, atributos)
  case tabela.upcase
  when 'ALUNO', 'ALUNOS'
    obj = Aluno.new
    atributos.each do |attr|
      chave, valor = attr.split('=',2)
      obj.nome  = valor if chave.downcase == 'nome'
      obj.email = valor if chave.downcase == 'email'
    end
    obj.save!

  when 'GRR', 'GRRS'
    obj = Grr.new
    atributos.each do |attr|
      chave, valor = attr.split('=',2)
      obj.numero = valor if chave.downcase == 'numero'
      obj.aluno  = Aluno.find_by(id: valor.to_i) if chave.downcase == 'aluno_id'
    end
    obj.save!

  when 'DISCIPLINA', 'DISCIPLINAS'
    obj = Disciplina.new
    atributos.each do |attr|
      chave, valor = attr.split('=',2)
      obj.nome      = valor if chave.downcase == 'nome'
      obj.codigo    = valor if chave.downcase == 'codigo'
      obj.aluno     = Aluno.find_by(id: valor.to_i) if chave.downcase == 'aluno_id'
    end
    obj.save!

  when 'DEPARTAMENTO', 'DEPARTAMENTOS'
    obj = Departamento.new
    atributos.each do |attr|
      chave, valor = attr.split('=',2)
      obj.nome = valor if chave.downcase == 'nome'
    end
    obj.save!

  else
    puts "Tabela não reconhecida: #{tabela}"
  end
end

# Lista registros da tabela
def lista_from(tabela)
  case tabela.upcase
  when 'ALUNO', 'ALUNOS'
    Aluno.all.each { |a| puts "id:#{a.id}, nome:#{a.nome}, email:#{a.email}" }
  when 'GRR', 'GRRS'
    Grr.all.each   { |g| puts "id:#{g.id}, numero:#{g.numero}, aluno_id:#{g.aluno_id}" }
  when 'DISCIPLINA', 'DISCIPLINAS'
    Disciplina.all.each { |d| puts "id:#{d.id}, nome:#{d.nome}, codigo:#{d.codigo}, aluno_id:#{d.aluno_id}" }
  when 'DEPARTAMENTO', 'DEPARTAMENTOS'
    Departamento.all.each { |d| puts "id:#{d.id}, nome:#{d.nome}" }
  when 'DEP_DISC', 'DEPARTAMENTOS_DISCIPLINAS', 'LISTA_DEP_DISC'
    Departamento.all.each do |dep|
      dep.disciplinas.each { |disc| puts "dept_id:#{dep.id} (#{dep.nome}), disc_id:#{disc.id} (#{disc.nome})" }
    end
  else
    puts "Tabela não reconhecida: #{tabela}"
  end
end

# Exclui registros da tabela
def exclui_from(tabela, cond)
  case tabela.upcase
  when 'ALUNO', 'ALUNOS'
    if cond.start_with?('id=')
      id = cond.split('=',2)[1].to_i
      Aluno.find_by(id: id)&.destroy
    end
  when 'GRR', 'GRRS'
    if cond.start_with?('id=')
      id = cond.split('=',2)[1].to_i
      Grr.find_by(id: id)&.destroy
    end
  when 'DISCIPLINA', 'DISCIPLINAS'
    if cond.start_with?('id=')
      id = cond.split('=',2)[1].to_i
      Disciplina.find_by(id: id)&.destroy
    end
  when 'DEPARTAMENTO', 'DEPARTAMENTOS'
    if cond.start_with?('id=')
      id = cond.split('=',2)[1].to_i
      Departamento.find_by(id: id)&.destroy
    end
  else
    puts "Tabela não reconhecida: #{tabela}"
  end
end

# Altera registros da tabela
def altera_from(tabela, atributos)
  case tabela.upcase
  when 'ALUNO', 'ALUNOS'
    obj = nil
    atributos.each { |attr| obj = Aluno.find_by(id: attr.split('=',2)[1].to_i) if attr.start_with?('id=') }
    if obj
      atributos.each do |attr|
        chave, valor = attr.split('=',2)
        obj.nome  = valor if chave.downcase=='nome'
        obj.email = valor if chave.downcase=='email'
      end
      obj.save!
    end
  when 'GRR', 'GRRS'
    obj = nil
    atributos.each { |attr| obj = Grr.find_by(id: attr.split('=',2)[1].to_i) if attr.start_with?('id=') }
    if obj
      atributos.each do |attr|
        chave, valor = attr.split('=',2)
        obj.numero = valor if chave.downcase=='numero'
        obj.aluno  = Aluno.find_by(id: valor.to_i) if chave.downcase=='aluno_id'
      end
      obj.save!
    end
  when 'DISCIPLINA', 'DISCIPLINAS'
    obj = nil
    atributos.each { |attr| obj = Disciplina.find_by(id: attr.split('=',2)[1].to_i) if attr.start_with?('id=') }
    if obj
      atributos.each do |attr|
        chave, valor = attr.split('=',2)
        obj.nome   = valor if chave.downcase=='nome'
        obj.codigo = valor if chave.downcase=='codigo'
      end
      obj.save!
    end
  when 'DEPARTAMENTO', 'DEPARTAMENTOS'
    obj = nil
    atributos.each { |attr| obj = Departamento.find_by(id: attr.split('=',2)[1].to_i) if attr.start_with?('id=') }
    if obj
      atributos.each do |attr|
        chave, valor = attr.split('=',2)
        obj.nome = valor if chave.downcase=='nome'
      end
      obj.save!
    end
  else
    puts "Tabela não reconhecida: #{tabela}"
  end
end

# Cria associação M-N entre departamento e disciplina
def associa_dep_disc(attrs)
  dept = nil; disc = nil
  attrs.each do |attr|
    chave, valor = attr.split('=',2)
    dept = Departamento.find_by(id: valor.to_i)     if chave.downcase=='dept_id'
    disc = Disciplina.find_by(id: valor.to_i)      if chave.downcase=='disciplina_id'
  end
  if dept && disc
    dept.disciplinas << disc
    puts "Associado departamento #{dept.id} -> disciplina #{disc.id}"
  else
    puts 'Erro na associação: ids inválidos.'
  end
end

# Programa principal
puts 'Digite "ajuda" para ver comandos. "exit" sai.'
loop do
  print '> '
  input = gets&.strip
  args = input.split
  cmd = args[0].upcase

  case cmd
  when 'EXIT'         then break
  when 'AJUDA'        then commands
  when 'TABELAS'      then puts 'Aluno, Grr, Disciplina, Departamento, Dep_Disc'
  when 'INSERE'       then args.size>=3 ? insere_in(args[1], args[2..]) : puts('Uso: insere <tabela> { atributo=valor ... }')
  when 'LISTA'        then args.size>=2 ? lista_from(args[1]) : puts('Uso: lista <tabela>')
  when 'EXCLUI'       then args.size==3? exclui_from(args[1], args[2]) : puts('Uso: exclui <tabela> <condição>')
  when 'ALTERA'       then args.size>=3? altera_from(args[1], args[2..]) : puts('Uso: altera <tabela> { atributo=valor ... }')
  when 'ASSOCIA_DEP_DISC' then args.size>=2? associa_dep_disc(args[1..]) : puts('Uso: associa_dep_disc dept_id=<id> disciplina_id=<id>')
  else                   puts "Comando desconhecido: #{cmd}"
  end
end