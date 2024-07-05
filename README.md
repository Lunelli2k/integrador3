# Remote Monitoring Manager

A aplicação desenvolvida tem como principal funcionalidade o monitoramento dos Itens de Configuração da TI de uma organização.

## Índice

- [Visão Geral](#visão-geral)
- [Funcionalidades](#funcionalidades)
- [Instalação](#instalação)
- [Uso](#uso)

## Visão Geral

A aplicação é útil para gestores de TI identificarem problemas na infraestrutura de forma assertiva e rápida, a fim de diminuir o downtime dos sistemas.

## Funcionalidades

- **Monitoramento de Hardware**: Monitore uso de CPU, memória, armazenamento, temperatura.
- **Alertas e Notificações**: Configure alertas para diferentes parâmetros de monitoramento.
- **Dashboard em Tempo Real**: Controle em tempo real o estado de diferentes Itens de Configuração.
- **Integração com Terceiros**: Integre com outras ferramentas e serviços via API.

## Instalação

### Pré-requisitos

- [Elixir](https://elixir-lang.org/install.html)
- [Phoenix Framework](https://hexdocs.pm/phoenix/installation.html)
- Banco de dados (PostgreSQL, MySQL, etc.)

### Passos para Instalação

1. Clone o repositório:

    ```sh
    git clone https://github.com/Lunelli2k/integrador3.git
    cd integrador3
    ```

2. Instale as dependências:

    ```sh
    cd remote_monitoring_management_umbrella
    mix deps.get
    ```

3. Configure o banco de dados no arquivo `config/dev.exs`, por padrão, o sistema conectará ao banco executando na porta **5432**:

    ```elixir
        config :rmm, Rmm.Repo,
        username: "<your-username>",
        password: "<your-passwd>",
        hostname: "<db-host>",
        database: "<database>",
        stacktrace: true,
        show_sensitive_data_on_connection_error: true,
        pool_size: 10
    ```

4. Crie e migre o banco de dados:

    ```sh
    mix ecto.create
    mix ecto.migrate
    ```

5. Inicie o servidor Phoenix:

    ```sh
    mix phx.server
    ```

A aplicação estará disponível em `http://localhost:4000`.

## Uso

### **Interface Web**

Após acessar a interface, precisará criar uma conta com email e senha. Após isso, será redirecionado para a Dashboard do sistema. Aqui você poderá criar diferentes ICs e controlar as regras de geração de eventos e incidentes. Além de registrar soluções de contorno.

#### **Autenticação**

A autenticação foi criada utilizando o utilitário do próprio Phoenix:
```sh
    mix phx.gen.auth
```

