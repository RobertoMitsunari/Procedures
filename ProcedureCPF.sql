create database Cadastro
go
use Cadastro
create table pessoa(
CPF char(11),
nome varchar(80)
primary key(CPF))

/*
Criar uma database chamada cadastro, criar uma tabela pessoa (CPF CHAR(11) PK, nome VARCHAR(80)),
pegar o algoritmo de validação de CPF, transformar em uma Stored Procedure sp_inserepessoa, 
que receba como parâmetro @cpf e @nome e @saida como parâmtero de saída. Valide o CPF e, 
só insira na tabela pessoa (cpf e nome) com CPF válido e nome com LEN Maior que zero. 
@saida deve dizer que foi inserido com sucesso. Raiserrors devem tratar violações
*/
 


CREATE PROCEDURE sp_inserepessoa(@cpf char(11),@nome varchar(80), @saida VARCHAR(MAX) OUTPUT)
AS
	declare 
			@cpfTemp as varchar(50),
			@somaCpf as int,
			@cont as int,
			@lenCont as int,
			@priDig as int,
			@segDig as int

	set @cpfTemp = REPLACE (@cpf, SUBSTRING(@cpf,1,1) ,'')

	if(@cpfTemp = '') BEGIN
		RAISERROR('Cpf invalido', 16, 1)
	end
	else
	begin
		set @cont = 10
		set @somaCpf = 0
		set @lenCont = 1

		while(@cont >= 2) 
		BEGIN
			set @somaCpf = @somaCpf + (CAST(SUBSTRING(@cpf,@lenCont,1) As INT) * @cont)
			set @cont = @cont - 1
			set @lenCont = @lenCont + 1
		END

		set @priDig = (@somaCpf * 10) % 11
		if(@priDig = 10) BEGIN
			set @priDig = 0
		END


		set @cont = 11
		set @somaCpf = 0
		set @lenCont = 1
		while(@cont >= 2) 
		BEGIN
			set @somaCpf = @somaCpf + (CAST(SUBSTRING(@cpf,@lenCont,1) As INT) * @cont)
			set @cont = @cont - 1
			set @lenCont = @lenCont + 1
		END
		set @segDig = (@somaCpf * 10) % 11
		if(@segDig = 10) BEGIN
			set @segDig = 0
		END
		if(LEN(@nome) > 0)
		BEGIN
			if(@priDig = CAST(SUBSTRING(@cpf,10,1) As INT) AND @segDig = CAST(SUBSTRING(@cpf,11,1) As INT)) BEGIN
				INSERT INTO pessoa VALUES(@cpf,@nome)
				SET @saida = 'Pessoa inserida com sucesso'
			END
			ELSE
			BEGIN
				RAISERROR('Cpf invalido', 16, 1)
			END
		END
		ELSE
		BEGIN
			RAISERROR('Nome invalido', 16, 1)
		END
	END



--cpf inválido
DECLARE @out VARCHAR(MAX)
EXEC sp_inserepessoa '11111111111','Teste', @out

--cpf inválido
DECLARE @out VARCHAR(MAX)
EXEC sp_inserepessoa '12345678957','Teste', @out

--cpf valido
DECLARE @out VARCHAR(MAX)
EXEC sp_inserepessoa '31721771140','Teste', @out

--nome inválido
DECLARE @out VARCHAR(MAX)
EXEC sp_inserepessoa '31721771140','', @out