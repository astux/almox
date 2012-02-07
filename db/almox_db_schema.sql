--
-- PostgreSQL database dump
--

-- Started on 2012-02-07 13:44:19 BRT

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 140 (class 1259 OID 47868)
-- Dependencies: 6
-- Name: entradas; Type: TABLE; Schema: public; Owner: almox; Tablespace: 
--

CREATE TABLE entradas (
    id integer NOT NULL,
    nota_fiscal character varying,
    data_entrada timestamp with time zone,
    empenho character varying,
    fornecedor_id integer,
    usuario_id integer
);


ALTER TABLE public.entradas OWNER TO almox;

--
-- TOC entry 142 (class 1259 OID 47876)
-- Dependencies: 6
-- Name: entradas_itens; Type: TABLE; Schema: public; Owner: almox; Tablespace: 
--

CREATE TABLE entradas_itens (
    id integer NOT NULL,
    entrada_id integer NOT NULL,
    item_id integer NOT NULL,
    quantidade double precision,
    valor_unitario double precision
);


ALTER TABLE public.entradas_itens OWNER TO almox;

--
-- TOC entry 143 (class 1259 OID 47880)
-- Dependencies: 6
-- Name: fornecedores; Type: TABLE; Schema: public; Owner: almox; Tablespace: 
--

CREATE TABLE fornecedores (
    id integer NOT NULL,
    nome character varying,
    ativacao boolean
);


ALTER TABLE public.fornecedores OWNER TO almox;

--
-- TOC entry 144 (class 1259 OID 47886)
-- Dependencies: 6
-- Name: itens; Type: TABLE; Schema: public; Owner: almox; Tablespace: 
--

CREATE TABLE itens (
    id integer NOT NULL,
    nome character varying,
    descricao text,
    ativacao boolean,
    marca character varying
);


ALTER TABLE public.itens OWNER TO almox;

--
-- TOC entry 155 (class 1259 OID 47934)
-- Dependencies: 6
-- Name: usuarios; Type: TABLE; Schema: public; Owner: almox; Tablespace: 
--

CREATE TABLE usuarios (
    id integer NOT NULL,
    nome_de_usuario character varying,
    senha character varying,
    ativacao boolean,
    nome character varying
);


ALTER TABLE public.usuarios OWNER TO almox;

--
-- TOC entry 157 (class 1259 OID 48020)
-- Dependencies: 1656 6
-- Name: entradas_detalhadas; Type: VIEW; Schema: public; Owner: almox
--

CREATE VIEW entradas_detalhadas AS
    SELECT e.id AS entrada_id, e.nota_fiscal, e.data_entrada, e.empenho, e.fornecedor_id, e.usuario_id, ei.item_id, ei.quantidade, ei.valor_unitario, (ei.quantidade * ei.valor_unitario) AS valor_total, i.nome AS item_nome, i.descricao AS item_descricao, i.marca AS item_marca, i.ativacao AS item_ativacao, u.nome AS usuario_nome, u.nome_de_usuario, u.ativacao AS usuario_ativacao, f.nome AS fornecedor_nome, f.ativacao AS fornecedor_ativacao FROM ((((entradas e LEFT JOIN entradas_itens ei ON ((ei.entrada_id = e.id))) LEFT JOIN itens i ON ((i.id = ei.item_id))) LEFT JOIN usuarios u ON ((u.id = e.usuario_id))) LEFT JOIN fornecedores f ON ((f.id = e.fornecedor_id)));


ALTER TABLE public.entradas_detalhadas OWNER TO almox;

--
-- TOC entry 145 (class 1259 OID 47897)
-- Dependencies: 6 140
-- Name: entradas_id_seq; Type: SEQUENCE; Schema: public; Owner: almox
--

CREATE SEQUENCE entradas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.entradas_id_seq OWNER TO almox;

--
-- TOC entry 1903 (class 0 OID 0)
-- Dependencies: 145
-- Name: entradas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: almox
--

ALTER SEQUENCE entradas_id_seq OWNED BY entradas.id;


--
-- TOC entry 1904 (class 0 OID 0)
-- Dependencies: 145
-- Name: entradas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: almox
--

SELECT pg_catalog.setval('entradas_id_seq', 34, true);


--
-- TOC entry 141 (class 1259 OID 47874)
-- Dependencies: 142 6
-- Name: entradas_itens_id_seq; Type: SEQUENCE; Schema: public; Owner: almox
--

CREATE SEQUENCE entradas_itens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.entradas_itens_id_seq OWNER TO almox;

--
-- TOC entry 1905 (class 0 OID 0)
-- Dependencies: 141
-- Name: entradas_itens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: almox
--

ALTER SEQUENCE entradas_itens_id_seq OWNED BY entradas_itens.id;


--
-- TOC entry 1906 (class 0 OID 0)
-- Dependencies: 141
-- Name: entradas_itens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: almox
--

SELECT pg_catalog.setval('entradas_itens_id_seq', 37, true);


--
-- TOC entry 146 (class 1259 OID 47904)
-- Dependencies: 6
-- Name: saidas_itens; Type: TABLE; Schema: public; Owner: almox; Tablespace: 
--

CREATE TABLE saidas_itens (
    saida_id integer NOT NULL,
    item_id integer NOT NULL,
    quantidade double precision
);


ALTER TABLE public.saidas_itens OWNER TO almox;

--
-- TOC entry 147 (class 1259 OID 47907)
-- Dependencies: 1654 6
-- Name: estoque; Type: VIEW; Schema: public; Owner: almox
--

CREATE VIEW estoque AS
    SELECT estoque.total, i.id, i.nome, i.descricao, i.ativacao, i.marca FROM ((SELECT entradas_saidas_soma.id, sum(entradas_saidas_soma.quantidade) AS total FROM (SELECT i.id, sum(ei.quantidade) AS quantidade FROM (itens i LEFT JOIN entradas_itens ei ON ((ei.item_id = i.id))) GROUP BY i.id UNION ALL SELECT i.id, sum((- si.quantidade)) AS total FROM (itens i LEFT JOIN saidas_itens si ON ((si.item_id = i.id))) GROUP BY i.id) entradas_saidas_soma GROUP BY entradas_saidas_soma.id ORDER BY entradas_saidas_soma.id) estoque JOIN itens i ON ((estoque.id = i.id)));


ALTER TABLE public.estoque OWNER TO almox;

--
-- TOC entry 148 (class 1259 OID 47912)
-- Dependencies: 6 143
-- Name: fornecedores_id_seq; Type: SEQUENCE; Schema: public; Owner: almox
--

CREATE SEQUENCE fornecedores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.fornecedores_id_seq OWNER TO almox;

--
-- TOC entry 1907 (class 0 OID 0)
-- Dependencies: 148
-- Name: fornecedores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: almox
--

ALTER SEQUENCE fornecedores_id_seq OWNED BY fornecedores.id;


--
-- TOC entry 1908 (class 0 OID 0)
-- Dependencies: 148
-- Name: fornecedores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: almox
--

SELECT pg_catalog.setval('fornecedores_id_seq', 1, true);


--
-- TOC entry 149 (class 1259 OID 47914)
-- Dependencies: 144 6
-- Name: itens_id_seq; Type: SEQUENCE; Schema: public; Owner: almox
--

CREATE SEQUENCE itens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.itens_id_seq OWNER TO almox;

--
-- TOC entry 1909 (class 0 OID 0)
-- Dependencies: 149
-- Name: itens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: almox
--

ALTER SEQUENCE itens_id_seq OWNED BY itens.id;


--
-- TOC entry 1910 (class 0 OID 0)
-- Dependencies: 149
-- Name: itens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: almox
--

SELECT pg_catalog.setval('itens_id_seq', 14, true);


--
-- TOC entry 150 (class 1259 OID 47916)
-- Dependencies: 6
-- Name: saidas; Type: TABLE; Schema: public; Owner: almox; Tablespace: 
--

CREATE TABLE saidas (
    id integer NOT NULL,
    data_saida timestamp with time zone,
    usuario_id integer,
    setor_id integer
);


ALTER TABLE public.saidas OWNER TO almox;

--
-- TOC entry 151 (class 1259 OID 47919)
-- Dependencies: 1655 6
-- Name: movimentacoes; Type: VIEW; Schema: public; Owner: almox
--

CREATE VIEW movimentacoes AS
    SELECT movimentacoes.data, movimentacoes.item_id, movimentacoes.quantidade, movimentacoes.setor_id, movimentacoes.tipo, movimentacoes.entrada_id, movimentacoes.saida_id FROM (SELECT e.data_entrada AS data, ei.item_id, ei.quantidade, NULL::unknown AS setor_id, 'entrada' AS tipo, e.id AS entrada_id, NULL::unknown AS saida_id FROM (entradas e JOIN entradas_itens ei ON ((ei.entrada_id = e.id))) UNION SELECT s.data_saida AS data, si.item_id, (- si.quantidade), s.setor_id, 'saida' AS tipo, NULL::unknown AS entrada_id, s.id AS saida_id FROM (saidas s JOIN saidas_itens si ON ((si.saida_id = s.id)))) movimentacoes ORDER BY movimentacoes.data;


ALTER TABLE public.movimentacoes OWNER TO almox;

--
-- TOC entry 160 (class 1259 OID 48032)
-- Dependencies: 6
-- Name: perfis; Type: TABLE; Schema: public; Owner: almox; Tablespace: 
--

CREATE TABLE perfis (
    id integer NOT NULL,
    nome character varying
);


ALTER TABLE public.perfis OWNER TO almox;

--
-- TOC entry 159 (class 1259 OID 48030)
-- Dependencies: 160 6
-- Name: perfis_id_seq; Type: SEQUENCE; Schema: public; Owner: almox
--

CREATE SEQUENCE perfis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.perfis_id_seq OWNER TO almox;

--
-- TOC entry 1911 (class 0 OID 0)
-- Dependencies: 159
-- Name: perfis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: almox
--

ALTER SEQUENCE perfis_id_seq OWNED BY perfis.id;


--
-- TOC entry 1912 (class 0 OID 0)
-- Dependencies: 159
-- Name: perfis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: almox
--

SELECT pg_catalog.setval('perfis_id_seq', 1, true);


--
-- TOC entry 153 (class 1259 OID 47926)
-- Dependencies: 6
-- Name: setores; Type: TABLE; Schema: public; Owner: almox; Tablespace: 
--

CREATE TABLE setores (
    id integer NOT NULL,
    nome character varying,
    ativacao boolean
);


ALTER TABLE public.setores OWNER TO almox;

--
-- TOC entry 158 (class 1259 OID 48025)
-- Dependencies: 1657 6
-- Name: saidas_detalhadas; Type: VIEW; Schema: public; Owner: almox
--

CREATE VIEW saidas_detalhadas AS
    SELECT s.id AS saida_id, s.data_saida, s.usuario_id, s.setor_id, si.item_id, si.quantidade, i.nome AS item_nome, i.descricao AS item_descricao, i.marca AS item_marca, i.ativacao AS item_ativacao, u.nome AS usuario_nome, u.nome_de_usuario, u.ativacao AS usuario_ativacao, se.nome AS setor_nome, se.ativacao AS setor_ativacao FROM ((((saidas s LEFT JOIN saidas_itens si ON ((si.saida_id = s.id))) LEFT JOIN itens i ON ((si.item_id = i.id))) LEFT JOIN usuarios u ON ((u.id = s.usuario_id))) LEFT JOIN setores se ON ((s.setor_id = se.id)));


ALTER TABLE public.saidas_detalhadas OWNER TO almox;

--
-- TOC entry 152 (class 1259 OID 47924)
-- Dependencies: 150 6
-- Name: saidas_id_seq; Type: SEQUENCE; Schema: public; Owner: almox
--

CREATE SEQUENCE saidas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.saidas_id_seq OWNER TO almox;

--
-- TOC entry 1913 (class 0 OID 0)
-- Dependencies: 152
-- Name: saidas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: almox
--

ALTER SEQUENCE saidas_id_seq OWNED BY saidas.id;


--
-- TOC entry 1914 (class 0 OID 0)
-- Dependencies: 152
-- Name: saidas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: almox
--

SELECT pg_catalog.setval('saidas_id_seq', 1, true);


--
-- TOC entry 154 (class 1259 OID 47932)
-- Dependencies: 153 6
-- Name: setores_id_seq; Type: SEQUENCE; Schema: public; Owner: almox
--

CREATE SEQUENCE setores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.setores_id_seq OWNER TO almox;

--
-- TOC entry 1915 (class 0 OID 0)
-- Dependencies: 154
-- Name: setores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: almox
--

ALTER SEQUENCE setores_id_seq OWNED BY setores.id;


--
-- TOC entry 1916 (class 0 OID 0)
-- Dependencies: 154
-- Name: setores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: almox
--

SELECT pg_catalog.setval('setores_id_seq', 2, true);


--
-- TOC entry 156 (class 1259 OID 47940)
-- Dependencies: 155 6
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: almox
--

CREATE SEQUENCE usuarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.usuarios_id_seq OWNER TO almox;

--
-- TOC entry 1917 (class 0 OID 0)
-- Dependencies: 156
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: almox
--

ALTER SEQUENCE usuarios_id_seq OWNED BY usuarios.id;


--
-- TOC entry 1918 (class 0 OID 0)
-- Dependencies: 156
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: almox
--

SELECT pg_catalog.setval('usuarios_id_seq', 1, true);


--
-- TOC entry 162 (class 1259 OID 48043)
-- Dependencies: 6
-- Name: usuarios_perfis; Type: TABLE; Schema: public; Owner: almox; Tablespace: 
--

CREATE TABLE usuarios_perfis (
    id integer NOT NULL,
    usuario_id integer,
    perfil_id integer
);


ALTER TABLE public.usuarios_perfis OWNER TO almox;

--
-- TOC entry 161 (class 1259 OID 48041)
-- Dependencies: 162 6
-- Name: usuarios_perfis_id_seq; Type: SEQUENCE; Schema: public; Owner: almox
--

CREATE SEQUENCE usuarios_perfis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.usuarios_perfis_id_seq OWNER TO almox;

--
-- TOC entry 1919 (class 0 OID 0)
-- Dependencies: 161
-- Name: usuarios_perfis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: almox
--

ALTER SEQUENCE usuarios_perfis_id_seq OWNED BY usuarios_perfis.id;


--
-- TOC entry 1920 (class 0 OID 0)
-- Dependencies: 161
-- Name: usuarios_perfis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: almox
--

SELECT pg_catalog.setval('usuarios_perfis_id_seq', 1, true);


--
-- TOC entry 1849 (class 2604 OID 47942)
-- Dependencies: 145 140
-- Name: id; Type: DEFAULT; Schema: public; Owner: almox
--

ALTER TABLE entradas ALTER COLUMN id SET DEFAULT nextval('entradas_id_seq'::regclass);


--
-- TOC entry 1850 (class 2604 OID 47879)
-- Dependencies: 142 141 142
-- Name: id; Type: DEFAULT; Schema: public; Owner: almox
--

ALTER TABLE entradas_itens ALTER COLUMN id SET DEFAULT nextval('entradas_itens_id_seq'::regclass);


--
-- TOC entry 1851 (class 2604 OID 47943)
-- Dependencies: 148 143
-- Name: id; Type: DEFAULT; Schema: public; Owner: almox
--

ALTER TABLE fornecedores ALTER COLUMN id SET DEFAULT nextval('fornecedores_id_seq'::regclass);


--
-- TOC entry 1852 (class 2604 OID 47944)
-- Dependencies: 149 144
-- Name: id; Type: DEFAULT; Schema: public; Owner: almox
--

ALTER TABLE itens ALTER COLUMN id SET DEFAULT nextval('itens_id_seq'::regclass);


--
-- TOC entry 1856 (class 2604 OID 48035)
-- Dependencies: 159 160 160
-- Name: id; Type: DEFAULT; Schema: public; Owner: almox
--

ALTER TABLE perfis ALTER COLUMN id SET DEFAULT nextval('perfis_id_seq'::regclass);


--
-- TOC entry 1853 (class 2604 OID 47945)
-- Dependencies: 152 150
-- Name: id; Type: DEFAULT; Schema: public; Owner: almox
--

ALTER TABLE saidas ALTER COLUMN id SET DEFAULT nextval('saidas_id_seq'::regclass);


--
-- TOC entry 1854 (class 2604 OID 47946)
-- Dependencies: 154 153
-- Name: id; Type: DEFAULT; Schema: public; Owner: almox
--

ALTER TABLE setores ALTER COLUMN id SET DEFAULT nextval('setores_id_seq'::regclass);


--
-- TOC entry 1855 (class 2604 OID 47947)
-- Dependencies: 156 155
-- Name: id; Type: DEFAULT; Schema: public; Owner: almox
--

ALTER TABLE usuarios ALTER COLUMN id SET DEFAULT nextval('usuarios_id_seq'::regclass);


--
-- TOC entry 1857 (class 2604 OID 48046)
-- Dependencies: 162 161 162
-- Name: id; Type: DEFAULT; Schema: public; Owner: almox
--

ALTER TABLE usuarios_perfis ALTER COLUMN id SET DEFAULT nextval('usuarios_perfis_id_seq'::regclass);


--
-- TOC entry 1888 (class 0 OID 47868)
-- Dependencies: 140
-- Data for Name: entradas; Type: TABLE DATA; Schema: public; Owner: almox
--

COPY entradas (id, nota_fiscal, data_entrada, empenho, fornecedor_id, usuario_id) FROM stdin;
2	123	\N	123	1	\N
4	123	\N	123	1	\N
7	123	\N	123	1	\N
8	213	\N	321	1	\N
9	123	\N	123	1	\N
10	123	2002-03-02 00:00:00-03	2	1	\N
11	123123	\N	123123	1	\N
12	1	\N	1	1	\N
13	1	\N	1	1	\N
14	1	\N	1	1	\N
15	1	\N	1	1	\N
20	1	\N	1	1	\N
24	123	\N	123	1	\N
25	123	\N	123	1	\N
26	123456	2012-01-01 00:00:00-03	123456	1	\N
27	12323	2012-01-01 00:00:00-03	123	1	\N
28	123	2012-01-02 00:00:00-03	123	1	\N
29	123123321321	2012-01-01 00:00:00-03	123123321321	1	\N
30	123	\N	123	1	\N
31	321	2012-01-01 00:00:00-03	321	1	\N
32	123	2012-01-01 00:00:00-03	123	1	\N
33	123123	2012-01-01 00:00:00-03	123123	1	\N
34	231	2012-01-01 00:00:00-03	231	1	\N
\.


--
-- TOC entry 1889 (class 0 OID 47876)
-- Dependencies: 142
-- Data for Name: entradas_itens; Type: TABLE DATA; Schema: public; Owner: almox
--

COPY entradas_itens (id, entrada_id, item_id, quantidade, valor_unitario) FROM stdin;
1	2	1	123	123
2	4	1	123	123
3	7	1	123	123
4	8	1	123	321
5	8	2	321	123
6	9	1	321	123
7	9	1	123	123
8	10	1	10	4
9	10	2	23	1
10	11	1	3	1
11	11	3	2	5
12	12	1	1	1
13	13	1	1	1
14	14	1	1	1
15	14	2	1	1
16	15	1	1	1
17	15	2	1	123
18	20	1	1	1
19	20	3	1	1
20	24	1	6	123
21	25	1	40	123
22	26	1	5	15
23	26	2	10	20
24	26	3	15	25
25	27	1	40	1
26	28	2	123	123
27	29	4	123	123
28	30	3	123	123
29	30	1	123	123
30	31	3	1	1
31	31	1	2	2
32	31	6	3	3
33	32	3	123	123
34	32	1	123	123
35	33	3	123	123
36	34	3	123	123
37	34	1	123	123
\.


--
-- TOC entry 1890 (class 0 OID 47880)
-- Dependencies: 143
-- Data for Name: fornecedores; Type: TABLE DATA; Schema: public; Owner: almox
--

COPY fornecedores (id, nome, ativacao) FROM stdin;
1	Fornecedor 1	t
\.


--
-- TOC entry 1891 (class 0 OID 47886)
-- Dependencies: 144
-- Data for Name: itens; Type: TABLE DATA; Schema: public; Owner: almox
--

COPY itens (id, nome, descricao, ativacao, marca) FROM stdin;
2	ewq	ewq	t	\N
3	Copo	eqw	t	\N
4	qweqwe	qwe	t	\N
1	Lápis	qwe	f	\N
5	eqweqwe	weqweq	t	\N
6	qwe2	qweqweq	t	\N
8	qwe	qwe	t	\N
9	qwe	qwe	t	\N
10	ewqe	qwe	t	\N
11	weqweqwe	qwe	t	\N
7	qweqweqweqweqwe	123	t	\N
12	Mais um	qwe	t	\N
13	qweqweqeqweqweqweqw	qweqweqwe	t	\N
14	Mais um item tes	ter	t	\N
\.


--
-- TOC entry 1896 (class 0 OID 48032)
-- Dependencies: 160
-- Data for Name: perfis; Type: TABLE DATA; Schema: public; Owner: almox
--

COPY perfis (id, nome) FROM stdin;
1	administrador
\.


--
-- TOC entry 1893 (class 0 OID 47916)
-- Dependencies: 150
-- Data for Name: saidas; Type: TABLE DATA; Schema: public; Owner: almox
--

COPY saidas (id, data_saida, usuario_id, setor_id) FROM stdin;
1	2012-01-01 00:00:00-03	\N	1
\.


--
-- TOC entry 1892 (class 0 OID 47904)
-- Dependencies: 146
-- Data for Name: saidas_itens; Type: TABLE DATA; Schema: public; Owner: almox
--

COPY saidas_itens (saida_id, item_id, quantidade) FROM stdin;
1	1	5
1	2	10
1	3	15
\.


--
-- TOC entry 1894 (class 0 OID 47926)
-- Dependencies: 153
-- Data for Name: setores; Type: TABLE DATA; Schema: public; Owner: almox
--

COPY setores (id, nome, ativacao) FROM stdin;
1	qwe	t
2	qweqweqwe	t
\.


--
-- TOC entry 1895 (class 0 OID 47934)
-- Dependencies: 155
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: almox
--

COPY usuarios (id, nome_de_usuario, senha, ativacao, nome) FROM stdin;
1	admin	admin	t	admin
\.


--
-- TOC entry 1897 (class 0 OID 48043)
-- Dependencies: 162
-- Data for Name: usuarios_perfis; Type: TABLE DATA; Schema: public; Owner: almox
--

COPY usuarios_perfis (id, usuario_id, perfil_id) FROM stdin;
1	1	1
\.


--
-- TOC entry 1861 (class 2606 OID 47949)
-- Dependencies: 142 142
-- Name: entradas_itens_pkey; Type: CONSTRAINT; Schema: public; Owner: almox; Tablespace: 
--

ALTER TABLE ONLY entradas_itens
    ADD CONSTRAINT entradas_itens_pkey PRIMARY KEY (id);


--
-- TOC entry 1859 (class 2606 OID 47951)
-- Dependencies: 140 140
-- Name: entradas_pkey; Type: CONSTRAINT; Schema: public; Owner: almox; Tablespace: 
--

ALTER TABLE ONLY entradas
    ADD CONSTRAINT entradas_pkey PRIMARY KEY (id);


--
-- TOC entry 1863 (class 2606 OID 47953)
-- Dependencies: 143 143
-- Name: fornecedores_pkey; Type: CONSTRAINT; Schema: public; Owner: almox; Tablespace: 
--

ALTER TABLE ONLY fornecedores
    ADD CONSTRAINT fornecedores_pkey PRIMARY KEY (id);


--
-- TOC entry 1865 (class 2606 OID 47955)
-- Dependencies: 144 144
-- Name: itens_pkey; Type: CONSTRAINT; Schema: public; Owner: almox; Tablespace: 
--

ALTER TABLE ONLY itens
    ADD CONSTRAINT itens_pkey PRIMARY KEY (id);


--
-- TOC entry 1875 (class 2606 OID 48040)
-- Dependencies: 160 160
-- Name: perfis_pkey; Type: CONSTRAINT; Schema: public; Owner: almox; Tablespace: 
--

ALTER TABLE ONLY perfis
    ADD CONSTRAINT perfis_pkey PRIMARY KEY (id);


--
-- TOC entry 1867 (class 2606 OID 47957)
-- Dependencies: 146 146 146
-- Name: saidas_itens_pkey; Type: CONSTRAINT; Schema: public; Owner: almox; Tablespace: 
--

ALTER TABLE ONLY saidas_itens
    ADD CONSTRAINT saidas_itens_pkey PRIMARY KEY (saida_id, item_id);


--
-- TOC entry 1869 (class 2606 OID 47959)
-- Dependencies: 150 150
-- Name: saidas_pkey; Type: CONSTRAINT; Schema: public; Owner: almox; Tablespace: 
--

ALTER TABLE ONLY saidas
    ADD CONSTRAINT saidas_pkey PRIMARY KEY (id);


--
-- TOC entry 1871 (class 2606 OID 47961)
-- Dependencies: 153 153
-- Name: setores_pkey; Type: CONSTRAINT; Schema: public; Owner: almox; Tablespace: 
--

ALTER TABLE ONLY setores
    ADD CONSTRAINT setores_pkey PRIMARY KEY (id);


--
-- TOC entry 1877 (class 2606 OID 48048)
-- Dependencies: 162 162
-- Name: usuarios_perfis_pkey; Type: CONSTRAINT; Schema: public; Owner: almox; Tablespace: 
--

ALTER TABLE ONLY usuarios_perfis
    ADD CONSTRAINT usuarios_perfis_pkey PRIMARY KEY (id);


--
-- TOC entry 1873 (class 2606 OID 47963)
-- Dependencies: 155 155
-- Name: usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: almox; Tablespace: 
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 1878 (class 2606 OID 47964)
-- Dependencies: 143 140 1862
-- Name: entradas_fornecedor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: almox
--

ALTER TABLE ONLY entradas
    ADD CONSTRAINT entradas_fornecedor_id_fkey FOREIGN KEY (fornecedor_id) REFERENCES fornecedores(id);


--
-- TOC entry 1880 (class 2606 OID 47969)
-- Dependencies: 1858 140 142
-- Name: entradas_itens_entrada_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: almox
--

ALTER TABLE ONLY entradas_itens
    ADD CONSTRAINT entradas_itens_entrada_id_fkey FOREIGN KEY (entrada_id) REFERENCES entradas(id);


--
-- TOC entry 1881 (class 2606 OID 47974)
-- Dependencies: 142 144 1864
-- Name: entradas_itens_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: almox
--

ALTER TABLE ONLY entradas_itens
    ADD CONSTRAINT entradas_itens_item_id_fkey FOREIGN KEY (item_id) REFERENCES itens(id);


--
-- TOC entry 1879 (class 2606 OID 47979)
-- Dependencies: 140 1872 155
-- Name: entradas_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: almox
--

ALTER TABLE ONLY entradas
    ADD CONSTRAINT entradas_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES usuarios(id);


--
-- TOC entry 1882 (class 2606 OID 47984)
-- Dependencies: 146 1864 144
-- Name: saidas_itens_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: almox
--

ALTER TABLE ONLY saidas_itens
    ADD CONSTRAINT saidas_itens_item_id_fkey FOREIGN KEY (item_id) REFERENCES itens(id);


--
-- TOC entry 1883 (class 2606 OID 47989)
-- Dependencies: 146 1868 150
-- Name: saidas_itens_saida_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: almox
--

ALTER TABLE ONLY saidas_itens
    ADD CONSTRAINT saidas_itens_saida_id_fkey FOREIGN KEY (saida_id) REFERENCES saidas(id);


--
-- TOC entry 1884 (class 2606 OID 47994)
-- Dependencies: 1870 150 153
-- Name: saidas_setor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: almox
--

ALTER TABLE ONLY saidas
    ADD CONSTRAINT saidas_setor_id_fkey FOREIGN KEY (setor_id) REFERENCES setores(id);


--
-- TOC entry 1885 (class 2606 OID 47999)
-- Dependencies: 150 1872 155
-- Name: saidas_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: almox
--

ALTER TABLE ONLY saidas
    ADD CONSTRAINT saidas_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES usuarios(id);


--
-- TOC entry 1887 (class 2606 OID 48054)
-- Dependencies: 1874 160 162
-- Name: usuarios_perfis_perfil_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: almox
--

ALTER TABLE ONLY usuarios_perfis
    ADD CONSTRAINT usuarios_perfis_perfil_id_fkey FOREIGN KEY (perfil_id) REFERENCES perfis(id);


--
-- TOC entry 1886 (class 2606 OID 48049)
-- Dependencies: 1872 162 155
-- Name: usuarios_perfis_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: almox
--

ALTER TABLE ONLY usuarios_perfis
    ADD CONSTRAINT usuarios_perfis_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES usuarios(id);


--
-- TOC entry 1902 (class 0 OID 0)
-- Dependencies: 6
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2012-02-07 13:44:19 BRT

--
-- PostgreSQL database dump complete
--

