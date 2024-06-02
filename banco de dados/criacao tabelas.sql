create table "ItemConfiguracao" (
    "Codigo" serial primary key,
    "Descricao" varchar(50),
    "Fabricante" varchar(50),
    "Modelo" varchar(50),
    "Porcentagem" float,
    "Temperatura" float,
    "Situacao" int,
    "CodigoIntegracao" varchar(50),
    "CapacidadeGB" double precision,
    "Categoria" int,
    "Tipo" varchar(50),
    "FrequenciaMHz" int,
    "Nucleos" int
);

create table "SolucaoContorno" (
    "Codigo" serial primary key,
    "Descricao" varchar(50),
    "Situacao" int,
    "Solucao" text
);

create table "RegraEventoCriticidade" (
    "Codigo" serial primary key,
    "Descricao" varchar(50),
    "TipoEventoCriticidade" int,
    "Condicao" int,
    "PropriedadeVerificar" int,
    "ValorPropriedade" float,
    "CodigoItemConfiguracao" int references "ItemConfiguracao"("Codigo"),
    "CodigoSolucaoContorno" int references "SolucaoContorno"("Codigo"),
    "Prioridade" int,
    "Impacto" int
);

create table "Incidente" (
    "Codigo" serial primary key,
    "Descricao" varchar(50),
    "CodigoItemConfiguracao" int references "ItemConfiguracao"("Codigo"),
    "CodigoSolucaoContorno" int references "SolucaoContorno"("Codigo"),
    "Situacao" int,
    "Impacto" int,
    "Prioridade" int,
    "Observacao" text,
    "CodigoRegraEventoCriticidade" int references "RegraEventoCriticidade"("Codigo")
);

create table "EventoCriticidade" (
    "Codigo" serial primary key,
    "Descricao" varchar(50),
    "TipoEventoCriticidade" int,
    "Condicao" int,
    "PropriedadeVerificada" int,
    "ValorPropriedade" float,
    "CodigoItemConfiguracao" int references "ItemConfiguracao"("Codigo"),
    "CodigoSolucaoContorno" int references "SolucaoContorno"("Codigo"),
    "Prioridade" int,
    "Impacto" int,
    "CodigoRegraEventoCriticidade" int references "RegraEventoCriticidade"("Codigo")
);