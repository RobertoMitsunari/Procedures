create database Academia
go
use Academia

create table Aluno(
codigo_aluno INT,
nome varchar(80)
primary key(codigo_aluno))


create table Atividade(
codigo INT,
descricao varchar(MAX),
IMC decimal(3,1)
primary key(codigo))

create table Atividade_Aluno(
codigo_aluno INT,
altura decimal(3,1),
peso decimal(3,1),
IMC decimal(3,1),
atividade int
primary key(codigo_aluno,atividade),
foreign key(atividade) references Atividade(codigo),
foreign key(codigo_aluno) references Aluno(codigo_aluno))


CREATE PROCEDURE sp_prox_cod_aluno(@cod INT OUTPUT)
AS
	DECLARE @count INT
	SET @count = (SELECT COUNT(*) FROM aluno)
	IF (@count = 0)
	BEGIN
		SET @cod = 1
	END
	ELSE
	BEGIN
		SET @cod = (SELECT MAX(codigo_aluno) FROM aluno) + 1
	END

insert into Atividade VALUES
(1,           'Corrida + Step'                       ,18.5),
(2,           'Biceps + Costas + Pernas'             ,24.9),
(3,           'Esteira + Biceps + Costas + Pernas'   ,29.9),
(4,           'Bicicleta + Biceps + Costas + Pernas' ,34.9),
(5,           'Esteira + Bicicleta'                  ,39.9)

drop procedure sp_alunoatividades
create procedure sp_alunoatividades(@codigo_aluno int,@nome varchar(80),@imc decimal(3,1),@altura decimal(3,1),
@peso decimal(3,1),@cod_atividade int,@saida VARCHAR(MAX) OUTPUT)
AS
	DECLARE @prox_cod INT, @Qnt INT
	if (@codigo_aluno is null and @nome is not null and @altura is not null and @peso is not null and @cod_atividade is not null)
	begin
		EXEC sp_prox_cod_aluno @prox_cod OUTPUT
		print @prox_cod
		insert into Aluno values(@prox_cod,@nome)
		insert into Atividade_Aluno values(@prox_cod,@altura,@peso,@imc,@cod_atividade)
	end
	ELSE
	BEGIN
		print 'Aqui'
		set @Qnt  = (select COUNT(*) from Atividade_Aluno where codigo_aluno = @codigo_aluno)
		if(@Qnt = 0)
		begin
			EXEC sp_prox_cod_aluno @prox_cod OUTPUT
			insert into Aluno values(@codigo_aluno,@nome)
			insert into Atividade_Aluno values(@codigo_aluno,@altura,@peso,@imc,@cod_atividade)
		end
		else
		begin
			update Atividade_Aluno set altura = @altura, peso = @peso,IMC = @imc,atividade = @cod_atividade where codigo_aluno = @codigo_aluno
		end
	END

insert into Aluno values(1,'Teste')
select * from Aluno
/*
Criar uma Stored Procedure (sp_alunoatividades), com as seguintes regras:
 - Se, dos dados inseridos, o código for nulo, mas, existirem nome, altura, peso, deve-se inserir um 
 novo registro nas tabelas aluno e aluno atividade com o imc calculado e as atividades pelas 
 regras estabelecidas acima.
 - Se, dos dados inseridos, o nome for (ou não nulo), mas, existirem código, altura, peso, deve-se 
 verificar se aquele código existe na base de dados e atualizar a altura, o peso, o imc calculado e 
 as atividades pelas regras estabelecidas acima.
 */

-- 1 caso
DECLARE @out VARCHAR(MAX)
EXEC sp_alunoatividades null,'Zé',35.1,1.70,70.5,4, @out
-- 2 caso
DECLARE @out VARCHAR(MAX)
EXEC sp_alunoatividades 2,'Zé',25.4,1.70,65.5,4, @out
select * from Atividade_Aluno


--Buscar a PRIMEIRA atividade referente ao IMC imediatamente acima do calculado.
--* Caso o IMC seja maior que 40, utilizar o código 5.
declare @cod_aluno int,
		@aluno_imc decimal(3,1)

set @cod_aluno = 2
set @aluno_imc = (select IMC From Atividade_Aluno where codigo_aluno = @cod_aluno)
if(@aluno_imc > 40)
BEGIN
	select TOP 1 * from Atividade where Atividade.IMC = 5
END
ELSE
BEGIN
	select TOP 1 * from Atividade where Atividade.IMC > @aluno_imc
END



