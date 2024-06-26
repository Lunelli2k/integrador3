create table "ItemConfiguracao" (
    "Codigo" serial primary key,
    "Descricao" varchar(50) not null,
    "Fabricante" varchar(50),
    "Modelo" varchar(50),
    "Porcentagem" float,
    "Temperatura" float,
    "Situacao" int not null,
    "CapacidadeGB" double precision,
    "Categoria" int not null,
    "Tipo" varchar(50),
    "FrequenciaMHz" int,
    "Nucleos" int
);

create table "SolucaoContorno" (
    "Codigo" serial primary key,
    "Descricao" varchar(50) not null,
    "Situacao" int not null,
    "Solucao" text not null
);

create table "RegraEventoCriticidade" (
    "Codigo" serial primary key,
    "Descricao" varchar(50) not null,
    "TipoEventoCriticidade" int not null,
    "Condicao" int not null,
    "PropriedadeVerificar" int not null,
    "ValorPropriedade" float not null,
    "CodigoItemConfiguracao" int references "ItemConfiguracao"("Codigo") not null,
    "CodigoSolucaoContorno" int references "SolucaoContorno"("Codigo"),
    "Prioridade" int not null,
    "Impacto" int not null,
    "GeraIncidente" bool not null
);

create table "Incidente" (
    "Codigo" serial primary key,
    "Descricao" varchar(50) not null,
    "CodigoItemConfiguracao" int references "ItemConfiguracao"("Codigo"),
    "CodigoSolucaoContorno" int references "SolucaoContorno"("Codigo"),
    "Situacao" int not null,
    "Impacto" int not null,
    "Prioridade" int not null,
    "Observacao" text,
    "CodigoRegraEventoCriticidade" int references "RegraEventoCriticidade"("Codigo"),
    "DataGeracao" timestamp not null
);

create table "EventoCriticidade" (
    "Codigo" serial primary key,
    "Descricao" varchar(50) not null,
    "TipoEventoCriticidade" int not null,
    "DataGeracao" timestamp not null,
    "Condicao" int not null,
    "PropriedadeVerificada" int not null,
    "ValorPropriedade" float not null,
    "CodigoItemConfiguracao" int references "ItemConfiguracao"("Codigo") not null,
    "CodigoSolucaoContorno" int references "SolucaoContorno"("Codigo"),
    "Prioridade" int not null,
    "Impacto" int not null,
    "CodigoRegraEventoCriticidade" int references "RegraEventoCriticidade"("Codigo") not null
);