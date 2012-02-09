--
-- PostgreSQL database dump
--

-- Started on 2012-02-09 12:31:00 BRT

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
-- TOC entry 141 (class 1259 OID 53125)
-- Dependencies: 3
-- Name: itens; Type: TABLE; Schema: public; Owner: almox; Tablespace: 
--

CREATE TABLE itens (
    id integer NOT NULL,
    nome character varying,
    descricao text,
    ativacao boolean
);


ALTER TABLE public.itens OWNER TO almox;

--
-- TOC entry 147 (class 1259 OID 53232)
-- Dependencies: 3
-- Name: movimentacoes; Type: TABLE; Schema: public; Owner: almox; Tablespace: 
--

CREATE TABLE movimentacoes (
    id integer NOT NULL,
    origem_setor_id integer,
    destino_setor_id integer,
    nota_fiscal character varying,
    empenho character varying,
    t_created timestamp with time zone,
    usuario_id integer,
    fornecedor_id integer,
    t_updated timestamp with time zone
);


ALTER TABLE public.movimentacoes OWNER TO almox;

--
-- TOC entry 149 (class 1259 OID 53263)
-- Dependencies: 3
-- Name: movimentacoes_itens; Type: TABLE; Schema: public; Owner: almox; Tablespace: 
--

CREATE TABLE movimentacoes_itens (
    id integer NOT NULL,
    movimentacao_id integer,
    item_id integer,
    quantidade integer,
    tombamento character varying
);


ALTER TABLE public.movimentacoes_itens OWNER TO almox;

--
-- TOC entry 145 (class 1259 OID 53158)
-- Dependencies: 3
-- Name: setores; Type: TABLE; Schema: public; Owner: almox; Tablespace: 
--

CREATE TABLE setores (
    id integer NOT NULL,
    nome character varying,
    ativacao boolean
);


ALTER TABLE public.setores OWNER TO almox;

--
-- TOC entry 150 (class 1259 OID 53282)
-- Dependencies: 1620 3
-- Name: estoque; Type: VIEW; Schema: public; Owner: almox
--

CREATE VIEW estoque AS
    SELECT movimentacoes_quantitativas.setor_id, movimentacoes_quantitativas.setor_nome, movimentacoes_quantitativas.item_id, movimentacoes_quantitativas.item_nome, sum(movimentacoes_quantitativas.quantidade) AS quantidade FROM (SELECT s.id AS setor_id, s.nome AS setor_nome, s.ativacao AS setor_ativacao, mov.origem_setor_id, mov.destino_setor_id, mov.quantidade, mov.item_id, mov.data_hora, i.nome AS item_nome FROM ((setores s JOIN (SELECT m.id, m.origem_setor_id, m.destino_setor_id, m.nota_fiscal, m.empenho, m.t_created AS data_hora, m.usuario_id, m.fornecedor_id, mi.id, mi.movimentacao_id, mi.item_id, mi.quantidade, mi.tombamento FROM (movimentacoes m JOIN movimentacoes_itens mi ON ((m.id = mi.movimentacao_id)))) mov ON ((mov.destino_setor_id = s.id))) JOIN itens i ON ((i.id = mov.item_id))) UNION ALL SELECT s.id AS setor_id, s.nome AS setor_nome, s.ativacao AS setor_ativacao, mov.origem_setor_id, mov.destino_setor_id, (- mov.quantidade) AS quantidade, mov.item_id, mov.data_hora, i.nome AS item_nome FROM ((setores s JOIN (SELECT m.id, m.origem_setor_id, m.destino_setor_id, m.nota_fiscal, m.empenho, m.t_created AS data_hora, m.usuario_id, m.fornecedor_id, mi.id, mi.movimentacao_id, mi.item_id, mi.quantidade, mi.tombamento FROM (movimentacoes m JOIN movimentacoes_itens mi ON ((m.id = mi.movimentacao_id)))) mov ON ((mov.origem_setor_id = s.id))) JOIN itens i ON ((i.id = mov.item_id)))) movimentacoes_quantitativas GROUP BY movimentacoes_quantitativas.setor_id, movimentacoes_quantitativas.item_id, movimentacoes_quantitativas.setor_nome, movimentacoes_quantitativas.item_nome ORDER BY movimentacoes_quantitativas.setor_id, movimentacoes_quantitativas.item_id;


ALTER TABLE public.estoque OWNER TO almox;

--
-- TOC entry 143 (class 1259 OID 53147)
-- Dependencies: 3
-- Name: fornecedores; Type: TABLE; Schema: public; Owner: almox; Tablespace: 
--

CREATE TABLE fornecedores (
    id integer NOT NULL,
    nome character varying,
    ativacao boolean
);


ALTER TABLE public.fornecedores OWNER TO almox;

--
-- TOC entry 142 (class 1259 OID 53145)
-- Dependencies: 3 143
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
-- TOC entry 1841 (class 0 OID 0)
-- Dependencies: 142
-- Name: fornecedores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: almox
--

ALTER SEQUENCE fornecedores_id_seq OWNED BY fornecedores.id;


--
-- TOC entry 140 (class 1259 OID 53123)
-- Dependencies: 141 3
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
-- TOC entry 1842 (class 0 OID 0)
-- Dependencies: 140
-- Name: itens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: almox
--

ALTER SEQUENCE itens_id_seq OWNED BY itens.id;


--
-- TOC entry 146 (class 1259 OID 53230)
-- Dependencies: 147 3
-- Name: movimentacoes_id_seq; Type: SEQUENCE; Schema: public; Owner: almox
--

CREATE SEQUENCE movimentacoes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.movimentacoes_id_seq OWNER TO almox;

--
-- TOC entry 1843 (class 0 OID 0)
-- Dependencies: 146
-- Name: movimentacoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: almox
--

ALTER SEQUENCE movimentacoes_id_seq OWNED BY movimentacoes.id;


--
-- TOC entry 148 (class 1259 OID 53261)
-- Dependencies: 3 149
-- Name: movimentacoes_itens_id_seq; Type: SEQUENCE; Schema: public; Owner: almox
--

CREATE SEQUENCE movimentacoes_itens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.movimentacoes_itens_id_seq OWNER TO almox;

--
-- TOC entry 1844 (class 0 OID 0)
-- Dependencies: 148
-- Name: movimentacoes_itens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: almox
--

ALTER SEQUENCE movimentacoes_itens_id_seq OWNED BY movimentacoes_itens.id;


--
-- TOC entry 144 (class 1259 OID 53156)
-- Dependencies: 145 3
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
-- TOC entry 1845 (class 0 OID 0)
-- Dependencies: 144
-- Name: setores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: almox
--

ALTER SEQUENCE setores_id_seq OWNED BY setores.id;


--
-- TOC entry 152 (class 1259 OID 53289)
-- Dependencies: 3
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
-- TOC entry 151 (class 1259 OID 53287)
-- Dependencies: 3 152
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
-- TOC entry 1846 (class 0 OID 0)
-- Dependencies: 151
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: almox
--

ALTER SEQUENCE usuarios_id_seq OWNED BY usuarios.id;


--
-- TOC entry 1813 (class 2604 OID 53150)
-- Dependencies: 143 142 143
-- Name: id; Type: DEFAULT; Schema: public; Owner: almox
--

ALTER TABLE fornecedores ALTER COLUMN id SET DEFAULT nextval('fornecedores_id_seq'::regclass);


--
-- TOC entry 1812 (class 2604 OID 53128)
-- Dependencies: 141 140 141
-- Name: id; Type: DEFAULT; Schema: public; Owner: almox
--

ALTER TABLE itens ALTER COLUMN id SET DEFAULT nextval('itens_id_seq'::regclass);


--
-- TOC entry 1815 (class 2604 OID 53235)
-- Dependencies: 146 147 147
-- Name: id; Type: DEFAULT; Schema: public; Owner: almox
--

ALTER TABLE movimentacoes ALTER COLUMN id SET DEFAULT nextval('movimentacoes_id_seq'::regclass);


--
-- TOC entry 1816 (class 2604 OID 53266)
-- Dependencies: 149 148 149
-- Name: id; Type: DEFAULT; Schema: public; Owner: almox
--

ALTER TABLE movimentacoes_itens ALTER COLUMN id SET DEFAULT nextval('movimentacoes_itens_id_seq'::regclass);


--
-- TOC entry 1814 (class 2604 OID 53161)
-- Dependencies: 144 145 145
-- Name: id; Type: DEFAULT; Schema: public; Owner: almox
--

ALTER TABLE setores ALTER COLUMN id SET DEFAULT nextval('setores_id_seq'::regclass);


--
-- TOC entry 1817 (class 2604 OID 53292)
-- Dependencies: 152 151 152
-- Name: id; Type: DEFAULT; Schema: public; Owner: almox
--

ALTER TABLE usuarios ALTER COLUMN id SET DEFAULT nextval('usuarios_id_seq'::regclass);


--
-- TOC entry 1821 (class 2606 OID 53155)
-- Dependencies: 143 143
-- Name: fornecedores_pkey; Type: CONSTRAINT; Schema: public; Owner: almox; Tablespace: 
--

ALTER TABLE ONLY fornecedores
    ADD CONSTRAINT fornecedores_pkey PRIMARY KEY (id);


--
-- TOC entry 1819 (class 2606 OID 53133)
-- Dependencies: 141 141
-- Name: itens_pkey; Type: CONSTRAINT; Schema: public; Owner: almox; Tablespace: 
--

ALTER TABLE ONLY itens
    ADD CONSTRAINT itens_pkey PRIMARY KEY (id);


--
-- TOC entry 1827 (class 2606 OID 53271)
-- Dependencies: 149 149
-- Name: movimentacoes_itens_pkey; Type: CONSTRAINT; Schema: public; Owner: almox; Tablespace: 
--

ALTER TABLE ONLY movimentacoes_itens
    ADD CONSTRAINT movimentacoes_itens_pkey PRIMARY KEY (id);


--
-- TOC entry 1825 (class 2606 OID 53240)
-- Dependencies: 147 147
-- Name: movimentacoes_pkey; Type: CONSTRAINT; Schema: public; Owner: almox; Tablespace: 
--

ALTER TABLE ONLY movimentacoes
    ADD CONSTRAINT movimentacoes_pkey PRIMARY KEY (id);


--
-- TOC entry 1823 (class 2606 OID 53166)
-- Dependencies: 145 145
-- Name: setores_pkey; Type: CONSTRAINT; Schema: public; Owner: almox; Tablespace: 
--

ALTER TABLE ONLY setores
    ADD CONSTRAINT setores_pkey PRIMARY KEY (id);


--
-- TOC entry 1829 (class 2606 OID 53297)
-- Dependencies: 152 152
-- Name: usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: almox; Tablespace: 
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 1831 (class 2606 OID 53246)
-- Dependencies: 145 1822 147
-- Name: movimentacoes_destino_setor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: almox
--

ALTER TABLE ONLY movimentacoes
    ADD CONSTRAINT movimentacoes_destino_setor_id_fkey FOREIGN KEY (destino_setor_id) REFERENCES setores(id) ON DELETE RESTRICT;


--
-- TOC entry 1832 (class 2606 OID 53256)
-- Dependencies: 147 1820 143
-- Name: movimentacoes_fornecedor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: almox
--

ALTER TABLE ONLY movimentacoes
    ADD CONSTRAINT movimentacoes_fornecedor_id_fkey FOREIGN KEY (fornecedor_id) REFERENCES fornecedores(id) ON DELETE RESTRICT;


--
-- TOC entry 1835 (class 2606 OID 53277)
-- Dependencies: 1818 149 141
-- Name: movimentacoes_itens_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: almox
--

ALTER TABLE ONLY movimentacoes_itens
    ADD CONSTRAINT movimentacoes_itens_item_id_fkey FOREIGN KEY (item_id) REFERENCES itens(id);


--
-- TOC entry 1834 (class 2606 OID 53272)
-- Dependencies: 149 1824 147
-- Name: movimentacoes_itens_movimentacao_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: almox
--

ALTER TABLE ONLY movimentacoes_itens
    ADD CONSTRAINT movimentacoes_itens_movimentacao_id_fkey FOREIGN KEY (movimentacao_id) REFERENCES movimentacoes(id);


--
-- TOC entry 1830 (class 2606 OID 53241)
-- Dependencies: 147 1822 145
-- Name: movimentacoes_origem_setor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: almox
--

ALTER TABLE ONLY movimentacoes
    ADD CONSTRAINT movimentacoes_origem_setor_id_fkey FOREIGN KEY (origem_setor_id) REFERENCES setores(id) ON DELETE RESTRICT;


--
-- TOC entry 1833 (class 2606 OID 53303)
-- Dependencies: 1828 147 152
-- Name: movimentacoes_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: almox
--

ALTER TABLE ONLY movimentacoes
    ADD CONSTRAINT movimentacoes_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE RESTRICT;


--
-- TOC entry 1840 (class 0 OID 0)
-- Dependencies: 3
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2012-02-09 12:31:00 BRT

--
-- PostgreSQL database dump complete
--

