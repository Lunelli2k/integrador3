create table "ItemConfiguracao" (
    "Codigo" serial primary key,
    "Descricao" varchar(50),
    "Fabricante" varchar(50),
    "Marca" varchar(50),
    "Porcentagem" double precision,
    "Temperatura" double precision,
    "Situacao" int,
    "CodigoIntegracao" varchar(50),
    "CapacidadeGB" int,
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

create table "Incidente" (
    "Codigo" serial primary key,
    "Descricao" varchar(50),
    "CodigoItemConfiguracao" int references "ItemConfiguracao"("Codigo"),
    "CodigoSolucaoContorno" int references "SolucaoContorno"("Codigo"),
    "Situacao" int,
    "Impacto" int,
    "Observacao" text
);

create table "RegraEventoCriticidade" (
    "Codigo" serial primary key,
    "Descricao" varchar(50),
    "TipoEventoCriticidade" int,
    "Condicao" int,
    "PropriedadeVerificar" int,
    "ValorPropriedade" float,
    "CodigoItemConfiguracao" int references "ItemConfiguracao"("Codigo"),
    "CodigoSolucaoContorno" int references "SolucaoContorno"("Codigo")
);
