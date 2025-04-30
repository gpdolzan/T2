# Gabriel Pimentel Dolzan - GRR20209948
$:.push './'
require_relative 'setup_trabalho2'
require_relative 'modelos/aluno'
require_relative 'modelos/grr'
require_relative 'modelos/disciplina'
require_relative 'modelos/departamento'

# Exibe a lista de comandos disponíveis
def printa_comandos
  puts <<~CMD
    Comandos:
      help                                  -> Lista comandos
      tabelas                               -> Lista tabelas disponíveis
      q                                     -> Sai do programa

    Operações em tabelas:
      <operação> <tabela> { atributo=valor ... }
        insere, lista, exclui, altera

    Associação Departamento-Disciplina:
      associa_dep_disc dept_id=<id> disciplina_id=<id>   -> Cria vínculo M-N
      lista_dep_disc                                     -> Lista todas as associações
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
      if chave.downcase == 'aluno_id'
        obj.aluno = Aluno.find_by(id: valor.to_i)
      end
    end
    obj.save!

  when 'DISCIPLINA', 'DISCIPLINAS'
    obj = Disciplina.new
    atributos.each do |attr|
      chave, valor = attr.split('=',2)
      obj.nome      = valor if chave.downcase == 'nome'
      obj.codigo    = valor if chave.downcase == 'codigo'
      if chave.downcase == 'aluno_id'
        obj.aluno = Aluno.find_by(id: valor.to_i)
      end
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
    Aluno.all.each do |a|
      puts "id:#{a.id}, nome:#{a.nome}, email:#{a.email}"
    end
  when 'GRR', 'GRRS'
    Grr.all.each do |g|
      puts "id:#{g.id}, numero:#{g.numero}, aluno_id:#{g.aluno_id}"
    end
  when 'DISCIPLINA', 'DISCIPLINAS'
    Disciplina.all.each do |d|
      puts "id:#{d.id}, nome:#{d.nome}, codigo:#{d.codigo}, aluno_id:#{d.aluno_id}"
    end
  when 'DEPARTAMENTO', 'DEPARTAMENTOS'
    Departamento.all.each do |d|
      puts "id:#{d.id}, nome:#{d.nome}"
    end
  when 'DEP_DISC', 'DEPARTAMENTOS_DISCIPLINAS', 'LISTA_DEP_DISC'
    Departamento.all.each do |dep|
      dep.disciplinas.each do |disc|
        puts "dept_id:#{dep.id} (#{dep.nome}), disc_id:#{disc.id} (#{disc.nome})"
      end
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
    atributos.each do |attr|
      chave, valor = attr.split('=',2)
      obj = Aluno.find_by(id: valor.to_i) if chave.downcase=='id'
    end
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
    atributos.each do |attr|
      chave, valor = attr.split('=',2)
      obj = Grr.find_by(id: valor.to_i) if chave.downcase=='id'
    end
    if obj
      atributos.each do |attr|
        chave, valor = attr.split('=',2)
        obj.numero = valor if chave.downcase=='numero'
        if chave.downcase=='aluno_id'
          obj.aluno = Aluno.find_by(id: valor.to_i)
        end
      end
      obj.save!
    end
  when 'DISCIPLINA', 'DISCIPLINAS'
    obj = nil
    atributos.each do |attr|
      chave, valor = attr.split('=',2)
      obj = Disciplina.find_by(id: valor.to_i) if chave.downcase=='id'
    end
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
    atributos.each do |attr|
      chave, valor = attr.split('=',2)
      obj = Departamento.find_by(id: valor.to_i) if chave.downcase=='id'
    end
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
puts 'Digite "help" para ver comandos. "q" sai.'
loop do
  print '> '
  input = gets&.strip
  break if input.nil? || input.upcase=='Q'
  args = input.split
  cmd = args[0].upcase

  case cmd
  when 'HELP'   then printa_comandos
  when 'TABELAS' then puts 'Aluno, Grr, Disciplina, Departamento, Dep_Disc'
  when 'INSERE'
    if args.size>=3
      insere_in(args[1], args[2..])
    else
      puts 'Uso: insere <tabela> { atributo=valor ... }'
    end
  when 'LISTA'
    if args.size>=2
      lista_from(args[1])
    else
      puts 'Uso: lista <tabela>'
    end
  when 'EXCLUI'
    if args.size==3
      exclui_from
