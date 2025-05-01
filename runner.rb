#!/usr/bin/env ruby
# Trabalho 2: banco de dados usando ActiveRecord
# Gabriel Pimentel Dolzan - GRR20209948

$:.push './'
require 'setup.rb'
require 'modelos/aluno.rb'
require 'modelos/grr.rb'
require 'modelos/disciplina.rb'
require 'modelos/departamento.rb'

# Mapeamento dinâmico de nomes de tabelas para classes
MODELS = {
  'ALUNO'       => Aluno,
  'GRR'         => Grr,
  'DISCIPLINA'  => Disciplina,
  'DEPARTAMENTO'=> Departamento
}.freeze

# Exibe comandos disponíveis
def commands
  puts <<~CMD
    Comandos:
      ajuda                          -> Lista comandos
      tabelas                        -> Lista tabelas disponíveis
      sair                           -> Sai do programa

    Operações em tabelas:
      insere <tabela> { atributo=valor ... }
      lista  <tabela> { atributo=valor ... }
      exclui <tabela> { atributo=valor ... }
      altera <tabela> { atributo=valor ... }

    Associação Departamento-Disciplina:
      associa_dep_disc dept_id=<id> disciplina_id=<id>
      lista dep_disc
  CMD
end

# Parseia array de strings "chave=valor" em hash de strings
def parse_attrs(attrs)
  attrs.map { |pair| k,v = pair.split('=',2); [k.downcase, v] }.to_h
end

# Converte atributos de filtro para formato do ActiveRecord
def parse_criteria(attrs)
  parse_attrs(attrs)
    .transform_keys(&:to_sym)
    .transform_values { |v| v.match?(/^\d+$/) ? v.to_i : v }
end

# Insere um novo registro dinamicamente
def generic_insere(tabela, attrs)
  model = MODELS[tabela.upcase]
  return puts "Tabela não reconhecida: #{tabela}" unless model

  data, assoc_data = {}, {}
  parse_attrs(attrs).each do |k,v|
    if k.end_with?('_id')
      assoc_data[k.chomp('_id')] = v.to_i
    else
      data[k.to_sym] = v
    end
  end

  record = model.new(data)
  assoc_data.each do |assoc, id|
    if record.respond_to?("#{assoc}=")
      assoc_class = MODELS[assoc.upcase]
      record.public_send("#{assoc}=", assoc_class.find_by(id: id))
    end
  end

  record.save!
  puts "Inserido #{tabela} id=#{record.id}"
end

# Lista registros com/ou sem filtros
def generic_lista(tabela, attrs)
  if %w[DEP_DISC DEPARTAMENTOS_DISCIPLINAS LISTA_DEP_DISC].include?(tabela.upcase)
    Departamento.all.each do |dep|
      dep.disciplinas.each { |disc| puts "dept_id:#{dep.id} (#{dep.nome}), disc_id:#{disc.id} (#{disc.nome})" }
    end
    return
  end

  model = MODELS[tabela.upcase]
  return puts "Tabela não reconhecida: #{tabela}" unless model

  records = attrs.empty? ? model.all : model.where(parse_criteria(attrs))
  records.each do |r|
    puts r.attributes.map { |k,v| "#{k}:#{v}" }.join(', ')
  end
end

# Exclui registros via condição
def generic_exclui(tabela, attrs)
  model = MODELS[tabela.upcase]
  return puts "Tabela não reconhecida: #{tabela}" unless model

  crit = parse_criteria(attrs)
  if crit.empty?
    puts 'Forneça condição válida para excluir.'
    return
  end

  count = model.where(crit).destroy_all.size
  puts "Excluídos #{count} registro(s) de #{tabela}."
end

# Altera registro existente
def generic_altera(tabela, attrs)
  model = MODELS[tabela.upcase]
  return puts "Tabela não reconhecida: #{tabela}" unless model

  data = parse_attrs(attrs)
  id = data.delete('id')&.to_i
  return puts 'É necessário informar id=<valor>' unless id

  record = model.find_by(id: id)
  return puts "#{tabela} id=#{id} não encontrado." unless record

  update_data, assoc_data = {}, {}
  data.each do |k,v|
    if k.end_with?('_id')
      assoc_data[k.chomp('_id')] = v.to_i
    else
      update_data[k.to_sym] = v
    end
  end

  record.update!(update_data)
  assoc_data.each do |assoc, id|
    if record.respond_to?("#{assoc}=")
      assoc_class = MODELS[assoc.upcase]
      record.public_send("#{assoc}=", assoc_class.find_by(id: id))
    end
  end

  puts "Alterado #{tabela} id=#{record.id}."
end

# Associação M–N Departamento ↔ Disciplina
def associa_dep_disc(attrs)
  data = parse_attrs(attrs)
  dep  = Departamento.find_by(id: data['dept_id'])
  disc = Disciplina.find_by(id: data['disciplina_id'])
  if dep && disc
    dep.disciplinas << disc
    puts "Associado departamento #{dep.id} -> disciplina #{disc.id}."
  else
    puts 'Erro na associação: ids inválidos.'
  end
end

# Loop principal de comandos
puts 'Digite "ajuda" para comandos. "sair" sai.'
loop do
  print '> '
  input = gets&.strip or break
  parts = input.split
  cmd   = parts[0]&.downcase

  case cmd
  when 'sair'            then break
  when 'ajuda'           then commands
  when 'tabelas'         then puts (MODELS.keys + ['Dep_Disc']).join(', ')
  when 'insere'          then parts.size>=3 ? generic_insere(parts[1], parts[2..]) : puts('Uso: insere <tabela> { atributo=valor ... }')
  when 'lista'           then parts.size>=2 ? generic_lista(parts[1], parts[2..]||[]) : puts('Uso: lista <tabela> { atributo=valor ... }')
  when 'exclui'          then parts.size>=3 ? generic_exclui(parts[1], parts[2..]) : puts('Uso: exclui <tabela> { atributo=valor ... }')
  when 'altera'          then parts.size>=3 ? generic_altera(parts[1], parts[2..]) : puts('Uso: altera <tabela> { atributo=valor ... }')
  when 'associa_dep_disc' then parts.size>=2 ? associa_dep_disc(parts[1..])         : puts('Uso: associa_dep_disc dept_id=<id> disciplina_id=<id>')
  else                        puts "Comando desconhecido: #{cmd}"   end
end