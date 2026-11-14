--
-- PostgreSQL database dump
--

\restrict ycrQQd1dU3PXCAg2l4NAO4bZsSJERmdQZ5qPajd6Clu0azDgq4RQZAO35zmCLol

-- Dumped from database version 17.12
-- Dumped by pg_dump version 17.12

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: golongan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.golongan (
    id bigint NOT NULL,
    kode character varying(5) NOT NULL,
    pangkat character varying(80) NOT NULL,
    ruang character varying(20) NOT NULL,
    tingkat smallint NOT NULL,
    CONSTRAINT golongan_tingkat_check CHECK (((tingkat >= 1) AND (tingkat <= 4)))
);


--
-- Name: golongan_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.golongan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: golongan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.golongan_id_seq OWNED BY public.golongan.id;


--
-- Name: kendaraan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.kendaraan (
    id bigint NOT NULL,
    nomor_polisi character varying(20) NOT NULL,
    kode_barang character varying(40) NOT NULL,
    nomor_register character varying(40) NOT NULL,
    merk character varying(60) NOT NULL,
    tipe character varying(80) NOT NULL,
    jenis character varying(20) NOT NULL,
    tahun_produksi smallint NOT NULL,
    warna character varying(30) NOT NULL,
    nomor_rangka character varying(80) NOT NULL,
    nomor_mesin character varying(80) NOT NULL,
    bahan_bakar character varying(20) NOT NULL,
    isi_silinder integer NOT NULL,
    kondisi character varying(20) NOT NULL,
    tanggal_perolehan date NOT NULL,
    nilai_perolehan numeric(15,2) NOT NULL,
    masa_berlaku_stnk date NOT NULL,
    jatuh_tempo_pajak date NOT NULL,
    perangkat_daerah_id bigint NOT NULL,
    keterangan text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT kendaraan_bahan_bakar_check CHECK (((bahan_bakar)::text = ANY ((ARRAY['bensin'::character varying, 'solar'::character varying, 'listrik'::character varying, 'hybrid'::character varying])::text[]))),
    CONSTRAINT kendaraan_isi_silinder_check CHECK ((isi_silinder >= 0)),
    CONSTRAINT kendaraan_jenis_check CHECK (((jenis)::text = ANY ((ARRAY['roda_2'::character varying, 'roda_4'::character varying, 'roda_6_lebih'::character varying])::text[]))),
    CONSTRAINT kendaraan_kondisi_check CHECK (((kondisi)::text = ANY ((ARRAY['baik'::character varying, 'rusak_ringan'::character varying, 'rusak_berat'::character varying])::text[]))),
    CONSTRAINT kendaraan_nilai_perolehan_check CHECK ((nilai_perolehan >= (0)::numeric)),
    CONSTRAINT kendaraan_nomor_polisi_check CHECK (((nomor_polisi)::text ~ '^B [0-9]{1,4} [A-Z]{1,3}$'::text)),
    CONSTRAINT kendaraan_tahun_produksi_check CHECK (((tahun_produksi >= 1980) AND (tahun_produksi <= 2100)))
);


--
-- Name: kendaraan_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.kendaraan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: kendaraan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.kendaraan_id_seq OWNED BY public.kendaraan.id;


--
-- Name: pegawai; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pegawai (
    id bigint NOT NULL,
    nip character(18) NOT NULL,
    nama character varying(120) NOT NULL,
    jabatan character varying(120) NOT NULL,
    golongan_id bigint NOT NULL,
    perangkat_daerah_id bigint NOT NULL,
    jenis_kelamin character(1) NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    no_hp character varying(30) DEFAULT ''::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT pegawai_jenis_kelamin_check CHECK ((jenis_kelamin = ANY (ARRAY['L'::bpchar, 'P'::bpchar]))),
    CONSTRAINT pegawai_nip_check CHECK ((TRIM(BOTH FROM nip) ~ '^[0-9]{18}$'::text))
);


--
-- Name: pegawai_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pegawai_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pegawai_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pegawai_id_seq OWNED BY public.pegawai.id;


--
-- Name: pemeliharaan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pemeliharaan (
    id bigint NOT NULL,
    kendaraan_id bigint NOT NULL,
    tanggal date NOT NULL,
    jenis character varying(30) NOT NULL,
    bengkel character varying(120) NOT NULL,
    kilometer integer NOT NULL,
    biaya numeric(15,2) NOT NULL,
    uraian text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT pemeliharaan_biaya_check CHECK ((biaya >= (0)::numeric)),
    CONSTRAINT pemeliharaan_jenis_check CHECK (((jenis)::text = ANY ((ARRAY['servis_rutin'::character varying, 'perbaikan'::character varying, 'penggantian_suku_cadang'::character varying, 'lainnya'::character varying])::text[]))),
    CONSTRAINT pemeliharaan_kilometer_check CHECK ((kilometer >= 0))
);


--
-- Name: pemeliharaan_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pemeliharaan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pemeliharaan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pemeliharaan_id_seq OWNED BY public.pemeliharaan.id;


--
-- Name: penugasan_kendaraan; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.penugasan_kendaraan (
    id bigint NOT NULL,
    kendaraan_id bigint NOT NULL,
    pegawai_id bigint NOT NULL,
    nomor_bast character varying(60) NOT NULL,
    tanggal_mulai date NOT NULL,
    tanggal_selesai date,
    keterangan text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT ck_penugasan_tanggal CHECK (((tanggal_selesai IS NULL) OR (tanggal_selesai >= tanggal_mulai)))
);


--
-- Name: penugasan_kendaraan_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.penugasan_kendaraan_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: penugasan_kendaraan_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.penugasan_kendaraan_id_seq OWNED BY public.penugasan_kendaraan.id;


--
-- Name: perangkat_daerah; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.perangkat_daerah (
    id bigint NOT NULL,
    kode character varying(30) NOT NULL,
    nama character varying(180) NOT NULL,
    singkatan character varying(30) NOT NULL,
    jenis character varying(20) NOT NULL,
    alamat character varying(255) DEFAULT ''::character varying NOT NULL,
    telepon character varying(30) DEFAULT ''::character varying NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT perangkat_daerah_jenis_check CHECK (((jenis)::text = ANY ((ARRAY['dinas'::character varying, 'badan'::character varying, 'kantor'::character varying, 'satuan'::character varying, 'inspektorat'::character varying, 'biro'::character varying, 'lainnya'::character varying])::text[])))
);


--
-- Name: perangkat_daerah_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.perangkat_daerah_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: perangkat_daerah_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.perangkat_daerah_id_seq OWNED BY public.perangkat_daerah.id;


--
-- Name: riwayat_kondisi; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.riwayat_kondisi (
    id bigint NOT NULL,
    kendaraan_id bigint NOT NULL,
    kondisi_lama character varying(20),
    kondisi_baru character varying(20) NOT NULL,
    user_id bigint,
    catatan text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT riwayat_kondisi_kondisi_baru_check CHECK (((kondisi_baru)::text = ANY ((ARRAY['baik'::character varying, 'rusak_ringan'::character varying, 'rusak_berat'::character varying])::text[])))
);


--
-- Name: riwayat_kondisi_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.riwayat_kondisi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: riwayat_kondisi_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.riwayat_kondisi_id_seq OWNED BY public.riwayat_kondisi.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    dirty boolean NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying(120) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    role character varying(20) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT users_role_check CHECK (((role)::text = ANY ((ARRAY['admin'::character varying, 'operator'::character varying])::text[])))
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: golongan id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.golongan ALTER COLUMN id SET DEFAULT nextval('public.golongan_id_seq'::regclass);


--
-- Name: kendaraan id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kendaraan ALTER COLUMN id SET DEFAULT nextval('public.kendaraan_id_seq'::regclass);


--
-- Name: pegawai id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pegawai ALTER COLUMN id SET DEFAULT nextval('public.pegawai_id_seq'::regclass);


--
-- Name: pemeliharaan id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pemeliharaan ALTER COLUMN id SET DEFAULT nextval('public.pemeliharaan_id_seq'::regclass);


--
-- Name: penugasan_kendaraan id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.penugasan_kendaraan ALTER COLUMN id SET DEFAULT nextval('public.penugasan_kendaraan_id_seq'::regclass);


--
-- Name: perangkat_daerah id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.perangkat_daerah ALTER COLUMN id SET DEFAULT nextval('public.perangkat_daerah_id_seq'::regclass);


--
-- Name: riwayat_kondisi id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riwayat_kondisi ALTER COLUMN id SET DEFAULT nextval('public.riwayat_kondisi_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: golongan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.golongan (id, kode, pangkat, ruang, tingkat) FROM stdin;
35	I/a	Juru Muda	I/a	1
36	I/b	Juru Muda Tingkat I	I/b	1
37	I/c	Juru	I/c	1
38	I/d	Juru Tingkat I	I/d	1
39	II/a	Pengatur Muda	II/a	2
40	II/b	Pengatur Muda Tingkat I	II/b	2
41	II/c	Pengatur	II/c	2
42	II/d	Pengatur Tingkat I	II/d	2
43	III/a	Penata Muda	III/a	3
44	III/b	Penata Muda Tingkat I	III/b	3
45	III/c	Penata	III/c	3
46	III/d	Penata Tingkat I	III/d	3
47	IV/a	Pembina	IV/a	4
48	IV/b	Pembina Tingkat I	IV/b	4
49	IV/c	Pembina Utama Muda	IV/c	4
50	IV/d	Pembina Utama Madya	IV/d	4
51	IV/e	Pembina Utama	IV/e	4
\.


--
-- Data for Name: kendaraan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.kendaraan (id, nomor_polisi, kode_barang, nomor_register, merk, tipe, jenis, tahun_produksi, warna, nomor_rangka, nomor_mesin, bahan_bakar, isi_silinder, kondisi, tanggal_perolehan, nilai_perolehan, masa_berlaku_stnk, jatuh_tempo_pajak, perangkat_daerah_id, keterangan, created_at, updated_at, deleted_at) FROM stdin;
1	B 1001 AA	1.3.2.02.01.01.001	REG-001	Toyota	Avanza	roda_4	2013	Hitam	RANGKA-SIMKDO-001	MESIN-SIMKDO-001	bensin	1496	baik	2013-01-10	15500000.00	2027-02-20	2026-02-20	33		2026-11-14 05:20:22.517619+00	2026-11-14 05:20:22.517619+00	\N
3	B 1003 CA	1.3.2.02.01.01.003	REG-003	Honda	Vario	roda_2	2015	Hitam	RANGKA-SIMKDO-003	MESIN-SIMKDO-003	bensin	160	baik	2015-01-10	22500000.00	2027-04-20	2026-04-20	35		2026-11-14 05:20:22.536952+00	2026-11-14 05:20:22.536952+00	\N
4	B 1004 DA	1.3.2.02.01.01.004	REG-004	Mitsubishi	L300	roda_4	2016	Hitam	RANGKA-SIMKDO-004	MESIN-SIMKDO-004	solar	2477	baik	2016-01-10	26000000.00	2027-05-20	2026-05-20	36		2026-11-14 05:20:22.540189+00	2026-11-14 05:20:22.540189+00	\N
5	B 1005 EA	1.3.2.02.01.01.005	REG-005	Suzuki	Ertiga	roda_4	2017	Hitam	RANGKA-SIMKDO-005	MESIN-SIMKDO-005	bensin	1462	rusak_ringan	2017-01-10	29500000.00	2027-06-20	2026-06-20	37		2026-11-14 05:20:22.543723+00	2026-11-14 05:20:22.543723+00	\N
6	B 1006 FA	1.3.2.02.01.01.006	REG-006	Toyota	Avanza	roda_4	2018	Hitam	RANGKA-SIMKDO-006	MESIN-SIMKDO-006	bensin	1496	baik	2018-01-10	33000000.00	2027-07-20	2026-07-20	38		2026-11-14 05:20:22.547093+00	2026-11-14 05:20:22.547093+00	\N
7	B 1007 GA	1.3.2.02.01.01.007	REG-007	Toyota	Kijang Innova	roda_4	2019	Hitam	RANGKA-SIMKDO-007	MESIN-SIMKDO-007	solar	2393	baik	2019-01-10	36500000.00	2027-08-20	2026-08-20	39		2026-11-14 05:20:22.550145+00	2026-11-14 05:20:22.550145+00	\N
8	B 1008 HA	1.3.2.02.01.01.008	REG-008	Honda	Vario	roda_2	2020	Hitam	RANGKA-SIMKDO-008	MESIN-SIMKDO-008	bensin	160	baik	2020-01-10	40000000.00	2027-09-20	2026-09-20	40		2026-11-14 05:20:22.556389+00	2026-11-14 05:20:22.556389+00	\N
9	B 1009 IA	1.3.2.02.01.01.009	REG-009	Mitsubishi	L300	roda_4	2021	Hitam	RANGKA-SIMKDO-009	MESIN-SIMKDO-009	solar	2477	baik	2021-01-10	43500000.00	2027-10-20	2026-10-20	41		2026-11-14 05:20:22.558925+00	2026-11-14 05:20:22.558925+00	\N
10	B 1010 JA	1.3.2.02.01.01.010	REG-010	Suzuki	Ertiga	roda_4	2022	Hitam	RANGKA-SIMKDO-010	MESIN-SIMKDO-010	bensin	1462	rusak_ringan	2022-01-10	47000000.00	2027-11-20	2026-11-20	42		2026-11-14 05:20:22.561197+00	2026-11-14 05:20:22.561197+00	\N
11	B 1011 KA	1.3.2.02.01.01.011	REG-011	Toyota	Avanza	roda_4	2023	Hitam	RANGKA-SIMKDO-011	MESIN-SIMKDO-011	bensin	1496	baik	2023-01-10	50500000.00	2027-12-20	2026-12-20	43		2026-11-14 05:20:22.563485+00	2026-11-14 05:20:22.563485+00	\N
12	B 1012 LA	1.3.2.02.01.01.012	REG-012	Toyota	Kijang Innova	roda_4	2024	Hitam	RANGKA-SIMKDO-012	MESIN-SIMKDO-012	solar	2393	baik	2024-01-10	54000000.00	2027-01-20	2026-01-20	44		2026-11-14 05:20:22.566254+00	2026-11-14 05:20:22.566254+00	\N
13	B 1013 MA	1.3.2.02.01.01.013	REG-013	Honda	Vario	roda_2	2025	Hitam	RANGKA-SIMKDO-013	MESIN-SIMKDO-013	bensin	160	baik	2025-01-10	57500000.00	2027-02-20	2026-02-20	45		2026-11-14 05:20:22.568977+00	2026-11-14 05:20:22.568977+00	\N
14	B 1014 NA	1.3.2.02.01.01.014	REG-014	Mitsubishi	L300	roda_4	2012	Hitam	RANGKA-SIMKDO-014	MESIN-SIMKDO-014	solar	2477	baik	2012-01-10	61000000.00	2027-03-20	2026-03-20	46		2026-11-14 05:20:22.571572+00	2026-11-14 05:20:22.571572+00	\N
15	B 1015 OA	1.3.2.02.01.01.015	REG-015	Suzuki	Ertiga	roda_4	2013	Hitam	RANGKA-SIMKDO-015	MESIN-SIMKDO-015	bensin	1462	rusak_ringan	2013-01-10	64500000.00	2027-04-20	2026-04-20	47		2026-11-14 05:20:22.574276+00	2026-11-14 05:20:22.574276+00	\N
16	B 1016 PA	1.3.2.02.01.01.016	REG-016	Toyota	Avanza	roda_4	2014	Hitam	RANGKA-SIMKDO-016	MESIN-SIMKDO-016	bensin	1496	baik	2014-01-10	68000000.00	2027-05-20	2026-05-20	48		2026-11-14 05:20:22.584599+00	2026-11-14 05:20:22.584599+00	\N
17	B 1017 QA	1.3.2.02.01.01.017	REG-017	Toyota	Kijang Innova	roda_4	2015	Hitam	RANGKA-SIMKDO-017	MESIN-SIMKDO-017	solar	2393	rusak_berat	2015-01-10	71500000.00	2027-06-20	2026-06-20	33		2026-11-14 05:20:22.587213+00	2026-11-14 05:20:22.587213+00	\N
18	B 1018 RA	1.3.2.02.01.01.018	REG-018	Honda	Vario	roda_2	2016	Hitam	RANGKA-SIMKDO-018	MESIN-SIMKDO-018	bensin	160	baik	2016-01-10	75000000.00	2027-07-20	2026-07-20	34		2026-11-14 05:20:22.589773+00	2026-11-14 05:20:22.589773+00	\N
19	B 1019 SA	1.3.2.02.01.01.019	REG-019	Mitsubishi	L300	roda_4	2017	Hitam	RANGKA-SIMKDO-019	MESIN-SIMKDO-019	solar	2477	baik	2017-01-10	78500000.00	2027-08-20	2026-08-20	35		2026-11-14 05:20:22.592235+00	2026-11-14 05:20:22.592235+00	\N
20	B 1020 TA	1.3.2.02.01.01.020	REG-020	Suzuki	Ertiga	roda_4	2018	Hitam	RANGKA-SIMKDO-020	MESIN-SIMKDO-020	bensin	1462	rusak_ringan	2018-01-10	82000000.00	2027-09-20	2026-09-20	36		2026-11-14 05:20:22.599684+00	2026-11-14 05:20:22.599684+00	\N
21	B 1021 UA	1.3.2.02.01.01.021	REG-021	Toyota	Avanza	roda_4	2019	Hitam	RANGKA-SIMKDO-021	MESIN-SIMKDO-021	bensin	1496	baik	2019-01-10	85500000.00	2027-10-20	2026-10-20	37		2026-11-14 05:20:22.601824+00	2026-11-14 05:20:22.601824+00	\N
22	B 1022 VA	1.3.2.02.01.01.022	REG-022	Toyota	Kijang Innova	roda_4	2020	Hitam	RANGKA-SIMKDO-022	MESIN-SIMKDO-022	solar	2393	baik	2020-01-10	89000000.00	2027-11-20	2026-11-20	38		2026-11-14 05:20:22.603974+00	2026-11-14 05:20:22.603974+00	\N
23	B 1023 WA	1.3.2.02.01.01.023	REG-023	Honda	Vario	roda_2	2021	Hitam	RANGKA-SIMKDO-023	MESIN-SIMKDO-023	bensin	160	baik	2021-01-10	92500000.00	2027-12-20	2026-12-20	39		2026-11-14 05:20:22.606127+00	2026-11-14 05:20:22.606127+00	\N
24	B 1024 XA	1.3.2.02.01.01.024	REG-024	Mitsubishi	L300	roda_4	2022	Hitam	RANGKA-SIMKDO-024	MESIN-SIMKDO-024	solar	2477	baik	2022-01-10	96000000.00	2027-01-20	2026-01-20	40		2026-11-14 05:20:22.608609+00	2026-11-14 05:20:22.608609+00	\N
25	B 1025 YA	1.3.2.02.01.01.025	REG-025	Suzuki	Ertiga	roda_4	2023	Hitam	RANGKA-SIMKDO-025	MESIN-SIMKDO-025	bensin	1462	rusak_ringan	2023-01-10	99500000.00	2027-02-20	2026-02-20	41		2026-11-14 05:20:22.617206+00	2026-11-14 05:20:22.617206+00	\N
26	B 1026 ZB	1.3.2.02.01.01.026	REG-026	Toyota	Avanza	roda_4	2024	Hitam	RANGKA-SIMKDO-026	MESIN-SIMKDO-026	bensin	1496	baik	2024-01-10	103000000.00	2027-03-20	2026-03-20	42		2026-11-14 05:20:22.619752+00	2026-11-14 05:20:22.619752+00	\N
27	B 1027 AB	1.3.2.02.01.01.027	REG-027	Toyota	Kijang Innova	roda_4	2025	Hitam	RANGKA-SIMKDO-027	MESIN-SIMKDO-027	solar	2393	baik	2025-01-10	106500000.00	2027-04-20	2026-04-20	43		2026-11-14 05:20:22.622158+00	2026-11-14 05:20:22.622158+00	\N
28	B 1028 BB	1.3.2.02.01.01.028	REG-028	Honda	Vario	roda_2	2012	Hitam	RANGKA-SIMKDO-028	MESIN-SIMKDO-028	bensin	160	baik	2012-01-10	110000000.00	2027-05-20	2026-05-20	44		2026-11-14 05:20:22.624686+00	2026-11-14 05:20:22.624686+00	\N
29	B 1029 CB	1.3.2.02.01.01.029	REG-029	Mitsubishi	L300	roda_4	2013	Hitam	RANGKA-SIMKDO-029	MESIN-SIMKDO-029	solar	2477	baik	2013-01-10	113500000.00	2027-06-20	2026-06-20	45		2026-11-14 05:20:22.626531+00	2026-11-14 05:20:22.626531+00	\N
30	B 1030 DB	1.3.2.02.01.01.030	REG-030	Suzuki	Ertiga	roda_4	2014	Hitam	RANGKA-SIMKDO-030	MESIN-SIMKDO-030	bensin	1462	rusak_ringan	2014-01-10	117000000.00	2027-07-20	2026-07-20	46		2026-11-14 05:20:22.628636+00	2026-11-14 05:20:22.628636+00	\N
31	B 1031 EB	1.3.2.02.01.01.031	REG-031	Toyota	Avanza	roda_4	2015	Hitam	RANGKA-SIMKDO-031	MESIN-SIMKDO-031	bensin	1496	baik	2015-01-10	120500000.00	2027-08-20	2026-08-20	47		2026-11-14 05:20:22.635564+00	2026-11-14 05:20:22.635564+00	\N
32	B 1032 FB	1.3.2.02.01.01.032	REG-032	Toyota	Kijang Innova	roda_4	2016	Hitam	RANGKA-SIMKDO-032	MESIN-SIMKDO-032	solar	2393	baik	2016-01-10	124000000.00	2027-09-20	2026-09-20	48		2026-11-14 05:20:22.637914+00	2026-11-14 05:20:22.637914+00	\N
33	B 1033 GB	1.3.2.02.01.01.033	REG-033	Honda	Vario	roda_2	2017	Hitam	RANGKA-SIMKDO-033	MESIN-SIMKDO-033	bensin	160	baik	2017-01-10	127500000.00	2027-10-20	2026-10-20	33		2026-11-14 05:20:22.640515+00	2026-11-14 05:20:22.640515+00	\N
34	B 1034 HB	1.3.2.02.01.01.034	REG-034	Mitsubishi	L300	roda_4	2018	Hitam	RANGKA-SIMKDO-034	MESIN-SIMKDO-034	solar	2477	rusak_berat	2018-01-10	131000000.00	2027-11-20	2026-11-20	34		2026-11-14 05:20:22.642952+00	2026-11-14 05:20:22.642952+00	\N
35	B 1035 IB	1.3.2.02.01.01.035	REG-035	Suzuki	Ertiga	roda_4	2019	Hitam	RANGKA-SIMKDO-035	MESIN-SIMKDO-035	bensin	1462	rusak_ringan	2019-01-10	134500000.00	2027-12-20	2026-12-20	35		2026-11-14 05:20:22.645576+00	2026-11-14 05:20:22.645576+00	\N
36	B 1036 JB	1.3.2.02.01.01.036	REG-036	Toyota	Avanza	roda_4	2020	Hitam	RANGKA-SIMKDO-036	MESIN-SIMKDO-036	bensin	1496	baik	2020-01-10	138000000.00	2027-01-20	2026-01-20	36		2026-11-14 05:20:22.648083+00	2026-11-14 05:20:22.648083+00	\N
37	B 1037 KB	1.3.2.02.01.01.037	REG-037	Toyota	Kijang Innova	roda_4	2021	Hitam	RANGKA-SIMKDO-037	MESIN-SIMKDO-037	solar	2393	baik	2021-01-10	141500000.00	2027-02-20	2026-02-20	37		2026-11-14 05:20:22.650658+00	2026-11-14 05:20:22.650658+00	\N
38	B 1038 LB	1.3.2.02.01.01.038	REG-038	Honda	Vario	roda_2	2022	Hitam	RANGKA-SIMKDO-038	MESIN-SIMKDO-038	bensin	160	baik	2022-01-10	145000000.00	2027-03-20	2026-03-20	38		2026-11-14 05:20:22.653265+00	2026-11-14 05:20:22.653265+00	\N
39	B 1039 MB	1.3.2.02.01.01.039	REG-039	Mitsubishi	L300	roda_4	2023	Hitam	RANGKA-SIMKDO-039	MESIN-SIMKDO-039	solar	2477	baik	2023-01-10	148500000.00	2027-04-20	2026-04-20	39		2026-11-14 05:20:22.656257+00	2026-11-14 05:20:22.656257+00	\N
40	B 1040 NB	1.3.2.02.01.01.040	REG-040	Suzuki	Ertiga	roda_4	2024	Hitam	RANGKA-SIMKDO-040	MESIN-SIMKDO-040	bensin	1462	rusak_ringan	2024-01-10	152000000.00	2027-05-20	2026-05-20	40		2026-11-14 05:20:22.658686+00	2026-11-14 05:20:22.658686+00	\N
41	B 1041 OB	1.3.2.02.01.01.041	REG-041	Toyota	Avanza	roda_4	2025	Hitam	RANGKA-SIMKDO-041	MESIN-SIMKDO-041	bensin	1496	baik	2025-01-10	155500000.00	2027-06-20	2026-06-20	41		2026-11-14 05:20:22.662275+00	2026-11-14 05:20:22.662275+00	\N
42	B 1042 PB	1.3.2.02.01.01.042	REG-042	Toyota	Kijang Innova	roda_4	2012	Hitam	RANGKA-SIMKDO-042	MESIN-SIMKDO-042	solar	2393	baik	2012-01-10	159000000.00	2027-07-20	2026-07-20	42		2026-11-14 05:20:22.66436+00	2026-11-14 05:20:22.66436+00	\N
43	B 1043 QB	1.3.2.02.01.01.043	REG-043	Honda	Vario	roda_2	2013	Hitam	RANGKA-SIMKDO-043	MESIN-SIMKDO-043	bensin	160	baik	2013-01-10	162500000.00	2027-08-20	2026-08-20	43		2026-11-14 05:20:22.666249+00	2026-11-14 05:20:22.666249+00	\N
44	B 1044 RB	1.3.2.02.01.01.044	REG-044	Mitsubishi	L300	roda_4	2014	Hitam	RANGKA-SIMKDO-044	MESIN-SIMKDO-044	solar	2477	baik	2014-01-10	166000000.00	2027-09-20	2026-09-20	44		2026-11-14 05:20:22.668133+00	2026-11-14 05:20:22.668133+00	\N
45	B 1045 SB	1.3.2.02.01.01.045	REG-045	Suzuki	Ertiga	roda_4	2015	Hitam	RANGKA-SIMKDO-045	MESIN-SIMKDO-045	bensin	1462	rusak_ringan	2015-01-10	169500000.00	2027-10-20	2026-10-20	45		2026-11-14 05:20:22.670429+00	2026-11-14 05:20:22.670429+00	\N
46	B 1046 TB	1.3.2.02.01.01.046	REG-046	Toyota	Avanza	roda_4	2016	Hitam	RANGKA-SIMKDO-046	MESIN-SIMKDO-046	bensin	1496	baik	2016-01-10	173000000.00	2027-11-20	2026-11-20	46		2026-11-14 05:20:22.674054+00	2026-11-14 05:20:22.674054+00	\N
47	B 1047 UB	1.3.2.02.01.01.047	REG-047	Toyota	Kijang Innova	roda_4	2017	Hitam	RANGKA-SIMKDO-047	MESIN-SIMKDO-047	solar	2393	baik	2017-01-10	176500000.00	2027-12-20	2026-12-20	47		2026-11-14 05:20:22.676287+00	2026-11-14 05:20:22.676287+00	\N
48	B 1048 VB	1.3.2.02.01.01.048	REG-048	Honda	Vario	roda_2	2018	Hitam	RANGKA-SIMKDO-048	MESIN-SIMKDO-048	bensin	160	baik	2018-01-10	180000000.00	2027-01-20	2026-01-20	48		2026-11-14 05:20:22.678772+00	2026-11-14 05:20:22.678772+00	\N
49	B 1049 WB	1.3.2.02.01.01.049	REG-049	Mitsubishi	L300	roda_4	2019	Hitam	RANGKA-SIMKDO-049	MESIN-SIMKDO-049	solar	2477	baik	2019-01-10	183500000.00	2027-02-20	2026-02-20	33		2026-11-14 05:20:22.682464+00	2026-11-14 05:20:22.682464+00	\N
50	B 1050 XB	1.3.2.02.01.01.050	REG-050	Suzuki	Ertiga	roda_4	2020	Hitam	RANGKA-SIMKDO-050	MESIN-SIMKDO-050	bensin	1462	rusak_ringan	2020-01-10	187000000.00	2027-03-20	2026-03-20	34		2026-11-14 05:20:22.684924+00	2026-11-14 05:20:22.684924+00	\N
52	B 9999 ZZY	1.3.2.02.01.01.999	REG-999	Toyota	Avanza	roda_4	2024	Hitam	RANGKA-TEST-998	MESIN-TEST-998	bensin	1496	baik	2024-01-01	250000000.00	2027-01-01	2026-12-01	33	Uji API	2026-11-14 05:39:22.906394+00	2026-11-14 05:42:06.252003+00	\N
54	B 8888 KDO	1.3.2.02.01.01.004	REG-888	Mitsubishi	Pajero Sport Dakar	roda_4	2023	Putih	MK2KRWPNUPJ888888	4N15UHN88888	solar	2442	baik	2023-06-20	650000000.00	2028-06-20	2027-06-20	43	Kendaraan operasional Kepala Badan	2026-11-14 05:59:04.256587+00	2026-11-14 05:59:04.256587+00	\N
\.


--
-- Data for Name: pegawai; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pegawai (id, nip, nama, jabatan, golongan_id, perangkat_daerah_id, jenis_kelamin, email, no_hp, created_at, updated_at, deleted_at) FROM stdin;
1	198001012008011001	Pegawai Fiktif 01	Pengurus Barang	43	33	L	pegawai01@simkdo.test		2026-11-14 05:20:22.3955+00	2026-11-14 05:20:22.3955+00	\N
2	198001022008012002	Pegawai Fiktif 02	Pengurus Barang	44	34	P	pegawai02@simkdo.test		2026-11-14 05:20:22.40166+00	2026-11-14 05:20:22.40166+00	\N
3	198001032008011003	Pegawai Fiktif 03	Pengurus Barang	45	35	L	pegawai03@simkdo.test		2026-11-14 05:20:22.404675+00	2026-11-14 05:20:22.404675+00	\N
4	198001042008012004	Pegawai Fiktif 04	Pengurus Barang	41	36	P	pegawai04@simkdo.test		2026-11-14 05:20:22.407655+00	2026-11-14 05:20:22.407655+00	\N
5	198001052008011005	Pegawai Fiktif 05	Pengurus Barang	43	37	L	pegawai05@simkdo.test		2026-11-14 05:20:22.409994+00	2026-11-14 05:20:22.409994+00	\N
6	198001062008012006	Pegawai Fiktif 06	Pengurus Barang	44	38	P	pegawai06@simkdo.test		2026-11-14 05:20:22.412791+00	2026-11-14 05:20:22.412791+00	\N
7	198001072008011007	Pegawai Fiktif 07	Pengurus Barang	45	39	L	pegawai07@simkdo.test		2026-11-14 05:20:22.415518+00	2026-11-14 05:20:22.415518+00	\N
8	198001082008012008	Pegawai Fiktif 08	Pengurus Barang	41	40	P	pegawai08@simkdo.test		2026-11-14 05:20:22.417612+00	2026-11-14 05:20:22.417612+00	\N
9	198001092008011009	Pegawai Fiktif 09	Pengurus Barang	43	41	L	pegawai09@simkdo.test		2026-11-14 05:20:22.420747+00	2026-11-14 05:20:22.420747+00	\N
10	198001102008012010	Pegawai Fiktif 10	Pengurus Barang	44	42	P	pegawai10@simkdo.test		2026-11-14 05:20:22.424818+00	2026-11-14 05:20:22.424818+00	\N
11	198001112008011011	Pegawai Fiktif 11	Pengurus Barang	45	43	L	pegawai11@simkdo.test		2026-11-14 05:20:22.430878+00	2026-11-14 05:20:22.430878+00	\N
12	198001122008012012	Pegawai Fiktif 12	Pengurus Barang	41	44	P	pegawai12@simkdo.test		2026-11-14 05:20:22.434339+00	2026-11-14 05:20:22.434339+00	\N
13	198001132008011013	Pegawai Fiktif 13	Pengurus Barang	43	45	L	pegawai13@simkdo.test		2026-11-14 05:20:22.436031+00	2026-11-14 05:20:22.436031+00	\N
14	198001142008012014	Pegawai Fiktif 14	Pengurus Barang	44	46	P	pegawai14@simkdo.test		2026-11-14 05:20:22.437594+00	2026-11-14 05:20:22.437594+00	\N
15	198001152008011015	Pegawai Fiktif 15	Pengurus Barang	45	47	L	pegawai15@simkdo.test		2026-11-14 05:20:22.439482+00	2026-11-14 05:20:22.439482+00	\N
16	198001162008012016	Pegawai Fiktif 16	Pengurus Barang	41	48	P	pegawai16@simkdo.test		2026-11-14 05:20:22.441499+00	2026-11-14 05:20:22.441499+00	\N
17	198001172008011017	Pegawai Fiktif 17	Pengurus Barang	43	33	L	pegawai17@simkdo.test		2026-11-14 05:20:22.44503+00	2026-11-14 05:20:22.44503+00	\N
18	198001182008012018	Pegawai Fiktif 18	Pengurus Barang	44	34	P	pegawai18@simkdo.test		2026-11-14 05:20:22.446788+00	2026-11-14 05:20:22.446788+00	\N
19	198001192008011019	Pegawai Fiktif 19	Pengurus Barang	45	35	L	pegawai19@simkdo.test		2026-11-14 05:20:22.449313+00	2026-11-14 05:20:22.449313+00	\N
20	198001202008012020	Pegawai Fiktif 20	Pengurus Barang	41	36	P	pegawai20@simkdo.test		2026-11-14 05:20:22.451868+00	2026-11-14 05:20:22.451868+00	\N
21	198001212008011021	Pegawai Fiktif 21	Pengurus Barang	43	37	L	pegawai21@simkdo.test		2026-11-14 05:20:22.454006+00	2026-11-14 05:20:22.454006+00	\N
22	198001222008012022	Pegawai Fiktif 22	Pengurus Barang	44	38	P	pegawai22@simkdo.test		2026-11-14 05:20:22.456408+00	2026-11-14 05:20:22.456408+00	\N
23	198001232008011023	Pegawai Fiktif 23	Pengurus Barang	45	39	L	pegawai23@simkdo.test		2026-11-14 05:20:22.459367+00	2026-11-14 05:20:22.459367+00	\N
24	198001242008012024	Pegawai Fiktif 24	Pengurus Barang	41	40	P	pegawai24@simkdo.test		2026-11-14 05:20:22.467024+00	2026-11-14 05:20:22.467024+00	\N
25	198001252008011025	Pegawai Fiktif 25	Pengurus Barang	43	41	L	pegawai25@simkdo.test		2026-11-14 05:20:22.470473+00	2026-11-14 05:20:22.470473+00	\N
26	198001262008012026	Pegawai Fiktif 26	Pengurus Barang	44	42	P	pegawai26@simkdo.test		2026-11-14 05:20:22.474116+00	2026-11-14 05:20:22.474116+00	\N
27	198001272008011027	Pegawai Fiktif 27	Pengurus Barang	45	43	L	pegawai27@simkdo.test		2026-11-14 05:20:22.476367+00	2026-11-14 05:20:22.476367+00	\N
28	198001282008012028	Pegawai Fiktif 28	Pengurus Barang	41	44	P	pegawai28@simkdo.test		2026-11-14 05:20:22.479521+00	2026-11-14 05:20:22.479521+00	\N
29	198001012008011029	Pegawai Fiktif 29	Pengurus Barang	43	45	L	pegawai29@simkdo.test		2026-11-14 05:20:22.481589+00	2026-11-14 05:20:22.481589+00	\N
30	198001022008012030	Pegawai Fiktif 30	Pengurus Barang	44	46	P	pegawai30@simkdo.test		2026-11-14 05:20:22.483716+00	2026-11-14 05:20:22.483716+00	\N
31	198001032008011031	Pegawai Fiktif 31	Pengurus Barang	45	47	L	pegawai31@simkdo.test		2026-11-14 05:20:22.485854+00	2026-11-14 05:20:22.485854+00	\N
32	198001042008012032	Pegawai Fiktif 32	Pengurus Barang	41	48	P	pegawai32@simkdo.test		2026-11-14 05:20:22.490736+00	2026-11-14 05:20:22.490736+00	\N
33	198001052008011033	Pegawai Fiktif 33	Pengurus Barang	43	33	L	pegawai33@simkdo.test		2026-11-14 05:20:22.493119+00	2026-11-14 05:20:22.493119+00	\N
34	198001062008012034	Pegawai Fiktif 34	Pengurus Barang	44	34	P	pegawai34@simkdo.test		2026-11-14 05:20:22.495345+00	2026-11-14 05:20:22.495345+00	\N
35	198001072008011035	Pegawai Fiktif 35	Pengurus Barang	45	35	L	pegawai35@simkdo.test		2026-11-14 05:20:22.497528+00	2026-11-14 05:20:22.497528+00	\N
36	198001082008012036	Pegawai Fiktif 36	Pengurus Barang	41	36	P	pegawai36@simkdo.test		2026-11-14 05:20:22.499833+00	2026-11-14 05:20:22.499833+00	\N
37	198001092008011037	Pegawai Fiktif 37	Pengurus Barang	43	37	L	pegawai37@simkdo.test		2026-11-14 05:20:22.501842+00	2026-11-14 05:20:22.501842+00	\N
38	198001102008012038	Pegawai Fiktif 38	Pengurus Barang	44	38	P	pegawai38@simkdo.test		2026-11-14 05:20:22.504037+00	2026-11-14 05:20:22.504037+00	\N
39	198001112008011039	Pegawai Fiktif 39	Pengurus Barang	45	39	L	pegawai39@simkdo.test		2026-11-14 05:20:22.506195+00	2026-11-14 05:20:22.506195+00	\N
40	198001122008012040	Pegawai Fiktif 40	Pengurus Barang	41	40	P	pegawai40@simkdo.test		2026-11-14 05:20:22.508707+00	2026-11-14 05:20:22.508707+00	\N
\.


--
-- Data for Name: pemeliharaan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pemeliharaan (id, kendaraan_id, tanggal, jenis, bengkel, kilometer, biaya, uraian, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: penugasan_kendaraan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.penugasan_kendaraan (id, kendaraan_id, pegawai_id, nomor_bast, tanggal_mulai, tanggal_selesai, keterangan, created_at, updated_at, deleted_at) FROM stdin;
1	1	1	BAST-SIMKDO-001	2025-01-02	\N	Penugasan seed	2026-11-14 05:20:22.690631+00	2026-11-14 05:20:22.690631+00	\N
3	3	3	BAST-SIMKDO-003	2025-01-04	2025-04-04	Penugasan seed	2026-11-14 05:20:22.697671+00	2026-11-14 05:20:22.697671+00	\N
4	4	4	BAST-SIMKDO-004	2025-01-05	\N	Penugasan seed	2026-11-14 05:20:22.700242+00	2026-11-14 05:20:22.700242+00	\N
5	5	5	BAST-SIMKDO-005	2025-01-06	2025-04-06	Penugasan seed	2026-11-14 05:20:22.702935+00	2026-11-14 05:20:22.702935+00	\N
6	6	6	BAST-SIMKDO-006	2025-01-07	2025-04-07	Penugasan seed	2026-11-14 05:20:22.705247+00	2026-11-14 05:20:22.705247+00	\N
7	7	7	BAST-SIMKDO-007	2025-01-08	\N	Penugasan seed	2026-11-14 05:20:22.707753+00	2026-11-14 05:20:22.707753+00	\N
8	8	8	BAST-SIMKDO-008	2025-01-09	2025-04-09	Penugasan seed	2026-11-14 05:20:22.709658+00	2026-11-14 05:20:22.709658+00	\N
9	9	9	BAST-SIMKDO-009	2025-01-10	2025-04-10	Penugasan seed	2026-11-14 05:20:22.711411+00	2026-11-14 05:20:22.711411+00	\N
10	10	10	BAST-SIMKDO-010	2025-01-11	\N	Penugasan seed	2026-11-14 05:20:22.720082+00	2026-11-14 05:20:22.720082+00	\N
11	11	11	BAST-SIMKDO-011	2025-01-12	2025-04-12	Penugasan seed	2026-11-14 05:20:22.723405+00	2026-11-14 05:20:22.723405+00	\N
12	12	12	BAST-SIMKDO-012	2025-01-13	2025-04-13	Penugasan seed	2026-11-14 05:20:22.725386+00	2026-11-14 05:20:22.725386+00	\N
13	13	13	BAST-SIMKDO-013	2025-01-14	\N	Penugasan seed	2026-11-14 05:20:22.727722+00	2026-11-14 05:20:22.727722+00	\N
14	14	14	BAST-SIMKDO-014	2025-01-15	2025-04-15	Penugasan seed	2026-11-14 05:20:22.729614+00	2026-11-14 05:20:22.729614+00	\N
15	15	15	BAST-SIMKDO-015	2025-01-16	2025-04-16	Penugasan seed	2026-11-14 05:20:22.732241+00	2026-11-14 05:20:22.732241+00	\N
16	16	16	BAST-SIMKDO-016	2025-01-17	\N	Penugasan seed	2026-11-14 05:20:22.73406+00	2026-11-14 05:20:22.73406+00	\N
17	18	18	BAST-SIMKDO-018	2025-01-19	2025-04-19	Penugasan seed	2026-11-14 05:20:22.736817+00	2026-11-14 05:20:22.736817+00	\N
18	19	19	BAST-SIMKDO-019	2025-01-20	\N	Penugasan seed	2026-11-14 05:20:22.742373+00	2026-11-14 05:20:22.742373+00	\N
19	20	20	BAST-SIMKDO-020	2025-01-21	2025-04-21	Penugasan seed	2026-11-14 05:20:22.746318+00	2026-11-14 05:20:22.746318+00	\N
20	21	21	BAST-SIMKDO-021	2025-01-22	2025-04-22	Penugasan seed	2026-11-14 05:20:22.748682+00	2026-11-14 05:20:22.748682+00	\N
21	22	22	BAST-SIMKDO-022	2025-01-23	\N	Penugasan seed	2026-11-14 05:20:22.750773+00	2026-11-14 05:20:22.750773+00	\N
22	23	23	BAST-SIMKDO-023	2025-01-24	2025-04-24	Penugasan seed	2026-11-14 05:20:22.752365+00	2026-11-14 05:20:22.752365+00	\N
23	24	24	BAST-SIMKDO-024	2025-01-25	2025-04-25	Penugasan seed	2026-11-14 05:20:22.753673+00	2026-11-14 05:20:22.753673+00	\N
24	25	25	BAST-SIMKDO-025	2025-01-26	\N	Penugasan seed	2026-11-14 05:20:22.755478+00	2026-11-14 05:20:22.755478+00	\N
25	26	26	BAST-SIMKDO-026	2025-01-27	2025-04-27	Penugasan seed	2026-11-14 05:20:22.75725+00	2026-11-14 05:20:22.75725+00	\N
26	27	27	BAST-SIMKDO-027	2025-01-28	2025-04-28	Penugasan seed	2026-11-14 05:20:22.758593+00	2026-11-14 05:20:22.758593+00	\N
27	28	28	BAST-SIMKDO-028	2025-01-29	\N	Penugasan seed	2026-11-14 05:20:22.760505+00	2026-11-14 05:20:22.760505+00	\N
28	29	29	BAST-SIMKDO-029	2025-01-30	2025-04-30	Penugasan seed	2026-11-14 05:20:22.762436+00	2026-11-14 05:20:22.762436+00	\N
29	30	30	BAST-SIMKDO-030	2025-01-31	2025-05-01	Penugasan seed	2026-11-14 05:20:22.764308+00	2026-11-14 05:20:22.764308+00	\N
\.


--
-- Data for Name: perangkat_daerah; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.perangkat_daerah (id, kode, nama, singkatan, jenis, alamat, telepon, email, created_at, updated_at, deleted_at) FROM stdin;
33	DISDIK	Dinas Pendidikan	DISDIK	dinas	Jakarta		DISDIK@jakarta.go.id	2026-11-14 05:20:22.35347+00	2026-11-14 05:20:22.35347+00	\N
34	DINKES	Dinas Kesehatan	DINKES	dinas	Jakarta		DINKES@jakarta.go.id	2026-11-14 05:20:22.356773+00	2026-11-14 05:20:22.356773+00	\N
35	DBM	Dinas Bina Marga	DBM	dinas	Jakarta		DBM@jakarta.go.id	2026-11-14 05:20:22.359114+00	2026-11-14 05:20:22.359114+00	\N
36	DSDA	Dinas Sumber Daya Air	DSDA	dinas	Jakarta		DSDA@jakarta.go.id	2026-11-14 05:20:22.361747+00	2026-11-14 05:20:22.361747+00	\N
37	DCKTRP	Dinas Cipta Karya Tata Ruang dan Pertanahan	DCKTRP	dinas	Jakarta		DCKTRP@jakarta.go.id	2026-11-14 05:20:22.3638+00	2026-11-14 05:20:22.3638+00	\N
38	DISHUB	Dinas Perhubungan	DISHUB	dinas	Jakarta		DISHUB@jakarta.go.id	2026-11-14 05:20:22.365961+00	2026-11-14 05:20:22.365961+00	\N
39	DLH	Dinas Lingkungan Hidup	DLH	dinas	Jakarta		DLH@jakarta.go.id	2026-11-14 05:20:22.37243+00	2026-11-14 05:20:22.37243+00	\N
40	DINSOS	Dinas Sosial	DINSOS	dinas	Jakarta		DINSOS@jakarta.go.id	2026-11-14 05:20:22.374497+00	2026-11-14 05:20:22.374497+00	\N
41	GULKAR	Dinas Penanggulangan Kebakaran dan Penyelamatan	GULKAR	dinas	Jakarta		GULKAR@jakarta.go.id	2026-11-14 05:20:22.376524+00	2026-11-14 05:20:22.376524+00	\N
42	DISTAMHUT	Dinas Pertamanan dan Hutan Kota	DISTAMHUT	dinas	Jakarta		DISTAMHUT@jakarta.go.id	2026-11-14 05:20:22.378354+00	2026-11-14 05:20:22.378354+00	\N
43	BPAD	Badan Pengelolaan Aset Daerah	BPAD	badan	Jakarta		BPAD@jakarta.go.id	2026-11-14 05:20:22.380209+00	2026-11-14 05:20:22.380209+00	\N
44	BAPENDA	Badan Pendapatan Daerah	BAPENDA	badan	Jakarta		BAPENDA@jakarta.go.id	2026-11-14 05:20:22.381757+00	2026-11-14 05:20:22.381757+00	\N
45	BPBD	Badan Penanggulangan Bencana Daerah	BPBD	badan	Jakarta		BPBD@jakarta.go.id	2026-11-14 05:20:22.383467+00	2026-11-14 05:20:22.383467+00	\N
46	INSPEKTORAT	Inspektorat	INSPEKTORAT	inspektorat	Jakarta		INSPEKTORAT@jakarta.go.id	2026-11-14 05:20:22.385151+00	2026-11-14 05:20:22.385151+00	\N
47	SATPOLPP	Satuan Polisi Pamong Praja	SATPOLPP	satuan	Jakarta		SATPOLPP@jakarta.go.id	2026-11-14 05:20:22.386683+00	2026-11-14 05:20:22.386683+00	\N
48	BIROUMUM	Biro Umum Sekretariat Daerah	BIROUMUM	biro	Jakarta		BIROUMUM@jakarta.go.id	2026-11-14 05:20:22.388504+00	2026-11-14 05:20:22.388504+00	\N
\.


--
-- Data for Name: riwayat_kondisi; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.riwayat_kondisi (id, kendaraan_id, kondisi_lama, kondisi_baru, user_id, catatan, created_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schema_migrations (version, dirty) FROM stdin;
1	f
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, name, email, password_hash, role, created_at, updated_at) FROM stdin;
7	Admin SIM-KDO	admin@simkdo.test	$2a$10$np/fP/De6zUyiNgD6tnM0OtokUKN9yhL90VlMVmUvSORYRrybiglq	admin	2026-11-14 05:20:22.309829+00	2026-11-14 05:20:22.309829+00
8	Operator SIM-KDO	operator@simkdo.test	$2a$10$np/fP/De6zUyiNgD6tnM0OtokUKN9yhL90VlMVmUvSORYRrybiglq	operator	2026-11-14 05:20:22.314159+00	2026-11-14 05:20:22.314159+00
\.


--
-- Name: golongan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.golongan_id_seq', 51, true);


--
-- Name: kendaraan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.kendaraan_id_seq', 54, true);


--
-- Name: pegawai_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pegawai_id_seq', 40, true);


--
-- Name: pemeliharaan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.pemeliharaan_id_seq', 1, false);


--
-- Name: penugasan_kendaraan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.penugasan_kendaraan_id_seq', 29, true);


--
-- Name: perangkat_daerah_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.perangkat_daerah_id_seq', 48, true);


--
-- Name: riwayat_kondisi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.riwayat_kondisi_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 8, true);


--
-- Name: golongan golongan_kode_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.golongan
    ADD CONSTRAINT golongan_kode_key UNIQUE (kode);


--
-- Name: golongan golongan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.golongan
    ADD CONSTRAINT golongan_pkey PRIMARY KEY (id);


--
-- Name: kendaraan kendaraan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kendaraan
    ADD CONSTRAINT kendaraan_pkey PRIMARY KEY (id);


--
-- Name: pegawai pegawai_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pegawai
    ADD CONSTRAINT pegawai_pkey PRIMARY KEY (id);


--
-- Name: pemeliharaan pemeliharaan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pemeliharaan
    ADD CONSTRAINT pemeliharaan_pkey PRIMARY KEY (id);


--
-- Name: penugasan_kendaraan penugasan_kendaraan_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.penugasan_kendaraan
    ADD CONSTRAINT penugasan_kendaraan_pkey PRIMARY KEY (id);


--
-- Name: perangkat_daerah perangkat_daerah_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.perangkat_daerah
    ADD CONSTRAINT perangkat_daerah_pkey PRIMARY KEY (id);


--
-- Name: riwayat_kondisi riwayat_kondisi_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riwayat_kondisi
    ADD CONSTRAINT riwayat_kondisi_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_kendaraan_kondisi; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kendaraan_kondisi ON public.kendaraan USING btree (kondisi);


--
-- Name: idx_kendaraan_pajak; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kendaraan_pajak ON public.kendaraan USING btree (jatuh_tempo_pajak);


--
-- Name: idx_kendaraan_pd; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_kendaraan_pd ON public.kendaraan USING btree (perangkat_daerah_id);


--
-- Name: idx_pegawai_nama; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pegawai_nama ON public.pegawai USING btree (nama);


--
-- Name: idx_pegawai_pd; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_pegawai_pd ON public.pegawai USING btree (perangkat_daerah_id);


--
-- Name: idx_penugasan_pegawai; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_penugasan_pegawai ON public.penugasan_kendaraan USING btree (pegawai_id);


--
-- Name: uq_kendaraan_mesin_aktif; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_kendaraan_mesin_aktif ON public.kendaraan USING btree (nomor_mesin) WHERE (deleted_at IS NULL);


--
-- Name: uq_kendaraan_nopol_aktif; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_kendaraan_nopol_aktif ON public.kendaraan USING btree (nomor_polisi) WHERE (deleted_at IS NULL);


--
-- Name: uq_kendaraan_rangka_aktif; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_kendaraan_rangka_aktif ON public.kendaraan USING btree (nomor_rangka) WHERE (deleted_at IS NULL);


--
-- Name: uq_pd_kode_aktif; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_pd_kode_aktif ON public.perangkat_daerah USING btree (kode) WHERE (deleted_at IS NULL);


--
-- Name: uq_pd_nama_aktif; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_pd_nama_aktif ON public.perangkat_daerah USING btree (nama) WHERE (deleted_at IS NULL);


--
-- Name: uq_pegawai_nip_aktif; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_pegawai_nip_aktif ON public.pegawai USING btree (nip) WHERE (deleted_at IS NULL);


--
-- Name: uq_penugasan_aktif; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX uq_penugasan_aktif ON public.penugasan_kendaraan USING btree (kendaraan_id) WHERE ((tanggal_selesai IS NULL) AND (deleted_at IS NULL));


--
-- Name: kendaraan kendaraan_perangkat_daerah_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.kendaraan
    ADD CONSTRAINT kendaraan_perangkat_daerah_id_fkey FOREIGN KEY (perangkat_daerah_id) REFERENCES public.perangkat_daerah(id) ON DELETE RESTRICT;


--
-- Name: pegawai pegawai_golongan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pegawai
    ADD CONSTRAINT pegawai_golongan_id_fkey FOREIGN KEY (golongan_id) REFERENCES public.golongan(id) ON DELETE RESTRICT;


--
-- Name: pegawai pegawai_perangkat_daerah_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pegawai
    ADD CONSTRAINT pegawai_perangkat_daerah_id_fkey FOREIGN KEY (perangkat_daerah_id) REFERENCES public.perangkat_daerah(id) ON DELETE RESTRICT;


--
-- Name: pemeliharaan pemeliharaan_kendaraan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pemeliharaan
    ADD CONSTRAINT pemeliharaan_kendaraan_id_fkey FOREIGN KEY (kendaraan_id) REFERENCES public.kendaraan(id) ON DELETE CASCADE;


--
-- Name: penugasan_kendaraan penugasan_kendaraan_kendaraan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.penugasan_kendaraan
    ADD CONSTRAINT penugasan_kendaraan_kendaraan_id_fkey FOREIGN KEY (kendaraan_id) REFERENCES public.kendaraan(id) ON DELETE CASCADE;


--
-- Name: penugasan_kendaraan penugasan_kendaraan_pegawai_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.penugasan_kendaraan
    ADD CONSTRAINT penugasan_kendaraan_pegawai_id_fkey FOREIGN KEY (pegawai_id) REFERENCES public.pegawai(id) ON DELETE RESTRICT;


--
-- Name: riwayat_kondisi riwayat_kondisi_kendaraan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riwayat_kondisi
    ADD CONSTRAINT riwayat_kondisi_kendaraan_id_fkey FOREIGN KEY (kendaraan_id) REFERENCES public.kendaraan(id) ON DELETE CASCADE;


--
-- Name: riwayat_kondisi riwayat_kondisi_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.riwayat_kondisi
    ADD CONSTRAINT riwayat_kondisi_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- PostgreSQL database dump complete
--

\unrestrict ycrQQd1dU3PXCAg2l4NAO4bZsSJERmdQZ5qPajd6Clu0azDgq4RQZAO35zmCLol

