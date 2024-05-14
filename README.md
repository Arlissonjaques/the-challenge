# Seja Bem-vindo(a) :star2:

## 🚀 Tecnologias

* Ruby 3.2.2
* Rails 7.0.8.1
* Postgresql 16.2

<br>

## :arrow_forward: Como rodar o projeto
Infelizmente não deu tempo de adicionar docker no projeto. Então segue os passos:

Primeiro, vamos gerar nossas variaveis, execute o comando:
```
cp .env.exemple .env
```

Preencha as variaveis contidas no arquivo:
```
JWT_SECRET=paocommortadela  # voce pode escolher o que por. 

DB_NAME=thechallenge        # nome do banco
DB_USER=postgres            # usuario do seu banco
DB_PASSWORD=postgres        # senha do seu banco
```

Instale as dependencias:
```
bundle install
```
Configure o banco
```
rails db:create
rails db:migrate
```

## :syringe: Testes
```
rspec                              # executa todos os testes
rspec spec/requests    # executa apenas os testes de request
rspec spec/models      # executa apenas os testes de model
```
