--
-- PostgreSQL database dump
--

\restrict GsBXchrMfAK50bSOZL3PgWRqawRQdbKWSpVMtNFdld9FQsVkBRq6kSC0aY9p54F

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
1	I/a	Juru Muda	I/a	1
2	I/b	Juru Muda Tingkat I	I/b	1
3	I/c	Juru	I/c	1
4	I/d	Juru Tingkat I	I/d	1
5	II/a	Pengatur Muda	II/a	2
6	II/b	Pengatur Muda Tingkat I	II/b	2
7	II/c	Pengatur	II/c	2
8	II/d	Pengatur Tingkat I	II/d	2
9	III/a	Penata Muda	III/a	3
10	III/b	Penata Muda Tingkat I	III/b	3
11	III/c	Penata	III/c	3
12	III/d	Penata Tingkat I	III/d	3
13	IV/a	Pembina	IV/a	4
14	IV/b	Pembina Tingkat I	IV/b	4
15	IV/c	Pembina Utama Muda	IV/c	4
16	IV/d	Pembina Utama Madya	IV/d	4
17	IV/e	Pembina Utama	IV/e	4
\.


--
-- Data for Name: kendaraan; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.kendaraan (id, nomor_polisi, kode_barang, nomor_register, merk, tipe, jenis, tahun_produksi, warna, nomor_rangka, nomor_mesin, bahan_bakar, isi_silinder, kondisi, tanggal_perolehan, nilai_perolehan, masa_berlaku_stnk, jatuh_tempo_pajak, perangkat_daerah_id, keterangan, created_at, updated_at, deleted_at) FROM stdin;
1	B 1001 AA	1.3.2.02.01.01.001	REG-001	Toyota	Avanza	roda_4	2013	Hitam	RANGKA-SIMKDO-001	MESIN-SIMKDO-001	bensin	1496	baik	2013-01-10	15500000.00	2027-02-20	2026-02-20	1		2026-11-14 06:08:48.176681+00	2026-11-14 06:08:48.176681+00	\N
2	B 1002 BA	1.3.2.02.01.01.002	REG-002	Toyota	Kijang Innova	roda_4	2014	Hitam	RANGKA-SIMKDO-002	MESIN-SIMKDO-002	solar	2393	baik	2014-01-10	19000000.00	2027-03-20	2026-03-20	2		2026-11-14 06:08:48.181751+00	2026-11-14 06:08:48.181751+00	\N
3	B 1003 CA	1.3.2.02.01.01.003	REG-003	Honda	Vario	roda_2	2015	Hitam	RANGKA-SIMKDO-003	MESIN-SIMKDO-003	bensin	160	baik	2015-01-10	22500000.00	2027-04-20	2026-04-20	3		2026-11-14 06:08:48.185145+00	2026-11-14 06:08:48.185145+00	\N
4	B 1004 DA	1.3.2.02.01.01.004	REG-004	Mitsubishi	L300	roda_4	2016	Hitam	RANGKA-SIMKDO-004	MESIN-SIMKDO-004	solar	2477	baik	2016-01-10	26000000.00	2027-05-20	2026-05-20	4		2026-11-14 06:08:48.188378+00	2026-11-14 06:08:48.188378+00	\N
5	B 1005 EA	1.3.2.02.01.01.005	REG-005	Suzuki	Ertiga	roda_4	2017	Hitam	RANGKA-SIMKDO-005	MESIN-SIMKDO-005	bensin	1462	rusak_ringan	2017-01-10	29500000.00	2027-06-20	2026-06-20	5		2026-11-14 06:08:48.191353+00	2026-11-14 06:08:48.191353+00	\N
6	B 1006 FA	1.3.2.02.01.01.006	REG-006	Toyota	Avanza	roda_4	2018	Hitam	RANGKA-SIMKDO-006	MESIN-SIMKDO-006	bensin	1496	baik	2018-01-10	33000000.00	2027-07-20	2026-07-20	6		2026-11-14 06:08:48.193725+00	2026-11-14 06:08:48.193725+00	\N
7	B 1007 GA	1.3.2.02.01.01.007	REG-007	Toyota	Kijang Innova	roda_4	2019	Hitam	RANGKA-SIMKDO-007	MESIN-SIMKDO-007	solar	2393	baik	2019-01-10	36500000.00	2027-08-20	2026-08-20	7		2026-11-14 06:08:48.19662+00	2026-11-14 06:08:48.19662+00	\N
8	B 1008 HA	1.3.2.02.01.01.008	REG-008	Honda	Vario	roda_2	2020	Hitam	RANGKA-SIMKDO-008	MESIN-SIMKDO-008	bensin	160	baik	2020-01-10	40000000.00	2027-09-20	2026-09-20	8		2026-11-14 06:08:48.198631+00	2026-11-14 06:08:48.198631+00	\N
9	B 1009 IA	1.3.2.02.01.01.009	REG-009	Mitsubishi	L300	roda_4	2021	Hitam	RANGKA-SIMKDO-009	MESIN-SIMKDO-009	solar	2477	baik	2021-01-10	43500000.00	2027-10-20	2026-10-20	9		2026-11-14 06:08:48.201004+00	2026-11-14 06:08:48.201004+00	\N
10	B 1010 JA	1.3.2.02.01.01.010	REG-010	Suzuki	Ertiga	roda_4	2022	Hitam	RANGKA-SIMKDO-010	MESIN-SIMKDO-010	bensin	1462	rusak_ringan	2022-01-10	47000000.00	2027-11-20	2026-11-20	10		2026-11-14 06:08:48.202908+00	2026-11-14 06:08:48.202908+00	\N
11	B 1011 KA	1.3.2.02.01.01.011	REG-011	Toyota	Avanza	roda_4	2023	Hitam	RANGKA-SIMKDO-011	MESIN-SIMKDO-011	bensin	1496	baik	2023-01-10	50500000.00	2027-12-20	2026-12-20	11		2026-11-14 06:08:48.204471+00	2026-11-14 06:08:48.204471+00	\N
12	B 1012 LA	1.3.2.02.01.01.012	REG-012	Toyota	Kijang Innova	roda_4	2024	Hitam	RANGKA-SIMKDO-012	MESIN-SIMKDO-012	solar	2393	baik	2024-01-10	54000000.00	2027-01-20	2026-01-20	12		2026-11-14 06:08:48.206117+00	2026-11-14 06:08:48.206117+00	\N
13	B 1013 MA	1.3.2.02.01.01.013	REG-013	Honda	Vario	roda_2	2025	Hitam	RANGKA-SIMKDO-013	MESIN-SIMKDO-013	bensin	160	baik	2025-01-10	57500000.00	2027-02-20	2026-02-20	13		2026-11-14 06:08:48.208221+00	2026-11-14 06:08:48.208221+00	\N
14	B 1014 NA	1.3.2.02.01.01.014	REG-014	Mitsubishi	L300	roda_4	2012	Hitam	RANGKA-SIMKDO-014	MESIN-SIMKDO-014	solar	2477	baik	2012-01-10	61000000.00	2027-03-20	2026-03-20	14		2026-11-14 06:08:48.21068+00	2026-11-14 06:08:48.21068+00	\N
15	B 1015 OA	1.3.2.02.01.01.015	REG-015	Suzuki	Ertiga	roda_4	2013	Hitam	RANGKA-SIMKDO-015	MESIN-SIMKDO-015	bensin	1462	rusak_ringan	2013-01-10	64500000.00	2027-04-20	2026-04-20	15		2026-11-14 06:08:48.21273+00	2026-11-14 06:08:48.21273+00	\N
16	B 1016 PA	1.3.2.02.01.01.016	REG-016	Toyota	Avanza	roda_4	2014	Hitam	RANGKA-SIMKDO-016	MESIN-SIMKDO-016	bensin	1496	baik	2014-01-10	68000000.00	2027-05-20	2026-05-20	16		2026-11-14 06:08:48.215874+00	2026-11-14 06:08:48.215874+00	\N
17	B 1017 QA	1.3.2.02.01.01.017	REG-017	Toyota	Kijang Innova	roda_4	2015	Hitam	RANGKA-SIMKDO-017	MESIN-SIMKDO-017	solar	2393	rusak_berat	2015-01-10	71500000.00	2027-06-20	2026-06-20	1		2026-11-14 06:08:48.218335+00	2026-11-14 06:08:48.218335+00	\N
18	B 1018 RA	1.3.2.02.01.01.018	REG-018	Honda	Vario	roda_2	2016	Hitam	RANGKA-SIMKDO-018	MESIN-SIMKDO-018	bensin	160	baik	2016-01-10	75000000.00	2027-07-20	2026-07-20	2		2026-11-14 06:08:48.220883+00	2026-11-14 06:08:48.220883+00	\N
19	B 1019 SA	1.3.2.02.01.01.019	REG-019	Mitsubishi	L300	roda_4	2017	Hitam	RANGKA-SIMKDO-019	MESIN-SIMKDO-019	solar	2477	baik	2017-01-10	78500000.00	2027-08-20	2026-08-20	3		2026-11-14 06:08:48.223383+00	2026-11-14 06:08:48.223383+00	\N
20	B 1020 TA	1.3.2.02.01.01.020	REG-020	Suzuki	Ertiga	roda_4	2018	Hitam	RANGKA-SIMKDO-020	MESIN-SIMKDO-020	bensin	1462	rusak_ringan	2018-01-10	82000000.00	2027-09-20	2026-09-20	4		2026-11-14 06:08:48.225265+00	2026-11-14 06:08:48.225265+00	\N
21	B 1021 UA	1.3.2.02.01.01.021	REG-021	Toyota	Avanza	roda_4	2019	Hitam	RANGKA-SIMKDO-021	MESIN-SIMKDO-021	bensin	1496	baik	2019-01-10	85500000.00	2027-10-20	2026-10-20	5		2026-11-14 06:08:48.227352+00	2026-11-14 06:08:48.227352+00	\N
22	B 1022 VA	1.3.2.02.01.01.022	REG-022	Toyota	Kijang Innova	roda_4	2020	Hitam	RANGKA-SIMKDO-022	MESIN-SIMKDO-022	solar	2393	baik	2020-01-10	89000000.00	2027-11-20	2026-11-20	6		2026-11-14 06:08:48.229163+00	2026-11-14 06:08:48.229163+00	\N
23	B 1023 WA	1.3.2.02.01.01.023	REG-023	Honda	Vario	roda_2	2021	Hitam	RANGKA-SIMKDO-023	MESIN-SIMKDO-023	bensin	160	baik	2021-01-10	92500000.00	2027-12-20	2026-12-20	7		2026-11-14 06:08:48.231141+00	2026-11-14 06:08:48.231141+00	\N
24	B 1024 XA	1.3.2.02.01.01.024	REG-024	Mitsubishi	L300	roda_4	2022	Hitam	RANGKA-SIMKDO-024	MESIN-SIMKDO-024	solar	2477	baik	2022-01-10	96000000.00	2027-01-20	2026-01-20	8		2026-11-14 06:08:48.23522+00	2026-11-14 06:08:48.23522+00	\N
25	B 1025 YA	1.3.2.02.01.01.025	REG-025	Suzuki	Ertiga	roda_4	2023	Hitam	RANGKA-SIMKDO-025	MESIN-SIMKDO-025	bensin	1462	rusak_ringan	2023-01-10	99500000.00	2027-02-20	2026-02-20	9		2026-11-14 06:08:48.237449+00	2026-11-14 06:08:48.237449+00	\N
26	B 1026 ZB	1.3.2.02.01.01.026	REG-026	Toyota	Avanza	roda_4	2024	Hitam	RANGKA-SIMKDO-026	MESIN-SIMKDO-026	bensin	1496	baik	2024-01-10	103000000.00	2027-03-20	2026-03-20	10		2026-11-14 06:08:48.239513+00	2026-11-14 06:08:48.239513+00	\N
27	B 1027 AB	1.3.2.02.01.01.027	REG-027	Toyota	Kijang Innova	roda_4	2025	Hitam	RANGKA-SIMKDO-027	MESIN-SIMKDO-027	solar	2393	baik	2025-01-10	106500000.00	2027-04-20	2026-04-20	11		2026-11-14 06:08:48.241251+00	2026-11-14 06:08:48.241251+00	\N
28	B 1028 BB	1.3.2.02.01.01.028	REG-028	Honda	Vario	roda_2	2012	Hitam	RANGKA-SIMKDO-028	MESIN-SIMKDO-028	bensin	160	baik	2012-01-10	110000000.00	2027-05-20	2026-05-20	12		2026-11-14 06:08:48.243466+00	2026-11-14 06:08:48.243466+00	\N
29	B 1029 CB	1.3.2.02.01.01.029	REG-029	Mitsubishi	L300	roda_4	2013	Hitam	RANGKA-SIMKDO-029	MESIN-SIMKDO-029	solar	2477	baik	2013-01-10	113500000.00	2027-06-20	2026-06-20	13		2026-11-14 06:08:48.245459+00	2026-11-14 06:08:48.245459+00	\N
30	B 1030 DB	1.3.2.02.01.01.030	REG-030	Suzuki	Ertiga	roda_4	2014	Hitam	RANGKA-SIMKDO-030	MESIN-SIMKDO-030	bensin	1462	rusak_ringan	2014-01-10	117000000.00	2027-07-20	2026-07-20	14		2026-11-14 06:08:48.247064+00	2026-11-14 06:08:48.247064+00	\N
31	B 1031 EB	1.3.2.02.01.01.031	REG-031	Toyota	Avanza	roda_4	2015	Hitam	RANGKA-SIMKDO-031	MESIN-SIMKDO-031	bensin	1496	baik	2015-01-10	120500000.00	2027-08-20	2026-08-20	15		2026-11-14 06:08:48.248988+00	2026-11-14 06:08:48.248988+00	\N
32	B 1032 FB	1.3.2.02.01.01.032	REG-032	Toyota	Kijang Innova	roda_4	2016	Hitam	RANGKA-SIMKDO-032	MESIN-SIMKDO-032	solar	2393	baik	2016-01-10	124000000.00	2027-09-20	2026-09-20	16		2026-11-14 06:08:48.251405+00	2026-11-14 06:08:48.251405+00	\N
33	B 1033 GB	1.3.2.02.01.01.033	REG-033	Honda	Vario	roda_2	2017	Hitam	RANGKA-SIMKDO-033	MESIN-SIMKDO-033	bensin	160	baik	2017-01-10	127500000.00	2027-10-20	2026-10-20	1		2026-11-14 06:08:48.253155+00	2026-11-14 06:08:48.253155+00	\N
34	B 1034 HB	1.3.2.02.01.01.034	REG-034	Mitsubishi	L300	roda_4	2018	Hitam	RANGKA-SIMKDO-034	MESIN-SIMKDO-034	solar	2477	rusak_berat	2018-01-10	131000000.00	2027-11-20	2026-11-20	2		2026-11-14 06:08:48.254829+00	2026-11-14 06:08:48.254829+00	\N
35	B 1035 IB	1.3.2.02.01.01.035	REG-035	Suzuki	Ertiga	roda_4	2019	Hitam	RANGKA-SIMKDO-035	MESIN-SIMKDO-035	bensin	1462	rusak_ringan	2019-01-10	134500000.00	2027-12-20	2026-12-20	3		2026-11-14 06:08:48.256367+00	2026-11-14 06:08:48.256367+00	\N
36	B 1036 JB	1.3.2.02.01.01.036	REG-036	Toyota	Avanza	roda_4	2020	Hitam	RANGKA-SIMKDO-036	MESIN-SIMKDO-036	bensin	1496	baik	2020-01-10	138000000.00	2027-01-20	2026-01-20	4		2026-11-14 06:08:48.260226+00	2026-11-14 06:08:48.260226+00	\N
37	B 1037 KB	1.3.2.02.01.01.037	REG-037	Toyota	Kijang Innova	roda_4	2021	Hitam	RANGKA-SIMKDO-037	MESIN-SIMKDO-037	solar	2393	baik	2021-01-10	141500000.00	2027-02-20	2026-02-20	5		2026-11-14 06:08:48.262409+00	2026-11-14 06:08:48.262409+00	\N
38	B 1038 LB	1.3.2.02.01.01.038	REG-038	Honda	Vario	roda_2	2022	Hitam	RANGKA-SIMKDO-038	MESIN-SIMKDO-038	bensin	160	baik	2022-01-10	145000000.00	2027-03-20	2026-03-20	6		2026-11-14 06:08:48.264628+00	2026-11-14 06:08:48.264628+00	\N
39	B 1039 MB	1.3.2.02.01.01.039	REG-039	Mitsubishi	L300	roda_4	2023	Hitam	RANGKA-SIMKDO-039	MESIN-SIMKDO-039	solar	2477	baik	2023-01-10	148500000.00	2027-04-20	2026-04-20	7		2026-11-14 06:08:48.266832+00	2026-11-14 06:08:48.266832+00	\N
40	B 1040 NB	1.3.2.02.01.01.040	REG-040	Suzuki	Ertiga	roda_4	2024	Hitam	RANGKA-SIMKDO-040	MESIN-SIMKDO-040	bensin	1462	rusak_ringan	2024-01-10	152000000.00	2027-05-20	2026-05-20	8		2026-11-14 06:08:48.268561+00	2026-11-14 06:08:48.268561+00	\N
41	B 1041 OB	1.3.2.02.01.01.041	REG-041	Toyota	Avanza	roda_4	2025	Hitam	RANGKA-SIMKDO-041	MESIN-SIMKDO-041	bensin	1496	baik	2025-01-10	155500000.00	2027-06-20	2026-06-20	9		2026-11-14 06:08:48.27027+00	2026-11-14 06:08:48.27027+00	\N
42	B 1042 PB	1.3.2.02.01.01.042	REG-042	Toyota	Kijang Innova	roda_4	2012	Hitam	RANGKA-SIMKDO-042	MESIN-SIMKDO-042	solar	2393	baik	2012-01-10	159000000.00	2027-07-20	2026-07-20	10		2026-11-14 06:08:48.271814+00	2026-11-14 06:08:48.271814+00	\N
43	B 1043 QB	1.3.2.02.01.01.043	REG-043	Honda	Vario	roda_2	2013	Hitam	RANGKA-SIMKDO-043	MESIN-SIMKDO-043	bensin	160	baik	2013-01-10	162500000.00	2027-08-20	2026-08-20	11		2026-11-14 06:08:48.273535+00	2026-11-14 06:08:48.273535+00	\N
44	B 1044 RB	1.3.2.02.01.01.044	REG-044	Mitsubishi	L300	roda_4	2014	Hitam	RANGKA-SIMKDO-044	MESIN-SIMKDO-044	solar	2477	baik	2014-01-10	166000000.00	2027-09-20	2026-09-20	12		2026-11-14 06:08:48.275113+00	2026-11-14 06:08:48.275113+00	\N
45	B 1045 SB	1.3.2.02.01.01.045	REG-045	Suzuki	Ertiga	roda_4	2015	Hitam	RANGKA-SIMKDO-045	MESIN-SIMKDO-045	bensin	1462	rusak_ringan	2015-01-10	169500000.00	2027-10-20	2026-10-20	13		2026-11-14 06:08:48.276828+00	2026-11-14 06:08:48.276828+00	\N
46	B 1046 TB	1.3.2.02.01.01.046	REG-046	Toyota	Avanza	roda_4	2016	Hitam	RANGKA-SIMKDO-046	MESIN-SIMKDO-046	bensin	1496	baik	2016-01-10	173000000.00	2027-11-20	2026-11-20	14		2026-11-14 06:08:48.278596+00	2026-11-14 06:08:48.278596+00	\N
47	B 1047 UB	1.3.2.02.01.01.047	REG-047	Toyota	Kijang Innova	roda_4	2017	Hitam	RANGKA-SIMKDO-047	MESIN-SIMKDO-047	solar	2393	baik	2017-01-10	176500000.00	2027-12-20	2026-12-20	15		2026-11-14 06:08:48.280268+00	2026-11-14 06:08:48.280268+00	\N
48	B 1048 VB	1.3.2.02.01.01.048	REG-048	Honda	Vario	roda_2	2018	Hitam	RANGKA-SIMKDO-048	MESIN-SIMKDO-048	bensin	160	baik	2018-01-10	180000000.00	2027-01-20	2026-01-20	16		2026-11-14 06:08:48.282309+00	2026-11-14 06:08:48.282309+00	\N
49	B 1049 WB	1.3.2.02.01.01.049	REG-049	Mitsubishi	L300	roda_4	2019	Hitam	RANGKA-SIMKDO-049	MESIN-SIMKDO-049	solar	2477	baik	2019-01-10	183500000.00	2027-02-20	2026-02-20	1		2026-11-14 06:08:48.284618+00	2026-11-14 06:08:48.284618+00	\N
50	B 1050 XB	1.3.2.02.01.01.050	REG-050	Suzuki	Ertiga	roda_4	2020	Hitam	RANGKA-SIMKDO-050	MESIN-SIMKDO-050	bensin	1462	rusak_ringan	2020-01-10	187000000.00	2027-03-20	2026-03-20	2		2026-11-14 06:08:48.286839+00	2026-11-14 06:08:48.286839+00	\N
\.


--
-- Data for Name: pegawai; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.pegawai (id, nip, nama, jabatan, golongan_id, perangkat_daerah_id, jenis_kelamin, email, no_hp, created_at, updated_at, deleted_at) FROM stdin;
1	198001012008011001	Pegawai Fiktif 01	Pengurus Barang	9	1	L	pegawai01@simkdo.test		2026-11-14 06:08:48.081581+00	2026-11-14 06:08:48.081581+00	\N
2	198001022008012002	Pegawai Fiktif 02	Pengurus Barang	10	2	P	pegawai02@simkdo.test		2026-11-14 06:08:48.087564+00	2026-11-14 06:08:48.087564+00	\N
3	198001032008011003	Pegawai Fiktif 03	Pengurus Barang	11	3	L	pegawai03@simkdo.test		2026-11-14 06:08:48.090274+00	2026-11-14 06:08:48.090274+00	\N
4	198001042008012004	Pegawai Fiktif 04	Pengurus Barang	7	4	P	pegawai04@simkdo.test		2026-11-14 06:08:48.09307+00	2026-11-14 06:08:48.09307+00	\N
5	198001052008011005	Pegawai Fiktif 05	Pengurus Barang	9	5	L	pegawai05@simkdo.test		2026-11-14 06:08:48.095124+00	2026-11-14 06:08:48.095124+00	\N
6	198001062008012006	Pegawai Fiktif 06	Pengurus Barang	10	6	P	pegawai06@simkdo.test		2026-11-14 06:08:48.097802+00	2026-11-14 06:08:48.097802+00	\N
7	198001072008011007	Pegawai Fiktif 07	Pengurus Barang	11	7	L	pegawai07@simkdo.test		2026-11-14 06:08:48.099605+00	2026-11-14 06:08:48.099605+00	\N
8	198001082008012008	Pegawai Fiktif 08	Pengurus Barang	7	8	P	pegawai08@simkdo.test		2026-11-14 06:08:48.101162+00	2026-11-14 06:08:48.101162+00	\N
9	198001092008011009	Pegawai Fiktif 09	Pengurus Barang	9	9	L	pegawai09@simkdo.test		2026-11-14 06:08:48.103877+00	2026-11-14 06:08:48.103877+00	\N
10	198001102008012010	Pegawai Fiktif 10	Pengurus Barang	10	10	P	pegawai10@simkdo.test		2026-11-14 06:08:48.109296+00	2026-11-14 06:08:48.109296+00	\N
11	198001112008011011	Pegawai Fiktif 11	Pengurus Barang	11	11	L	pegawai11@simkdo.test		2026-11-14 06:08:48.111819+00	2026-11-14 06:08:48.111819+00	\N
12	198001122008012012	Pegawai Fiktif 12	Pengurus Barang	7	12	P	pegawai12@simkdo.test		2026-11-14 06:08:48.114123+00	2026-11-14 06:08:48.114123+00	\N
13	198001132008011013	Pegawai Fiktif 13	Pengurus Barang	9	13	L	pegawai13@simkdo.test		2026-11-14 06:08:48.115815+00	2026-11-14 06:08:48.115815+00	\N
14	198001142008012014	Pegawai Fiktif 14	Pengurus Barang	10	14	P	pegawai14@simkdo.test		2026-11-14 06:08:48.117483+00	2026-11-14 06:08:48.117483+00	\N
15	198001152008011015	Pegawai Fiktif 15	Pengurus Barang	11	15	L	pegawai15@simkdo.test		2026-11-14 06:08:48.119249+00	2026-11-14 06:08:48.119249+00	\N
16	198001162008012016	Pegawai Fiktif 16	Pengurus Barang	7	16	P	pegawai16@simkdo.test		2026-11-14 06:08:48.120848+00	2026-11-14 06:08:48.120848+00	\N
17	198001172008011017	Pegawai Fiktif 17	Pengurus Barang	9	1	L	pegawai17@simkdo.test		2026-11-14 06:08:48.122601+00	2026-11-14 06:08:48.122601+00	\N
18	198001182008012018	Pegawai Fiktif 18	Pengurus Barang	10	2	P	pegawai18@simkdo.test		2026-11-14 06:08:48.124593+00	2026-11-14 06:08:48.124593+00	\N
19	198001192008011019	Pegawai Fiktif 19	Pengurus Barang	11	3	L	pegawai19@simkdo.test		2026-11-14 06:08:48.126195+00	2026-11-14 06:08:48.126195+00	\N
20	198001202008012020	Pegawai Fiktif 20	Pengurus Barang	7	4	P	pegawai20@simkdo.test		2026-11-14 06:08:48.127687+00	2026-11-14 06:08:48.127687+00	\N
21	198001212008011021	Pegawai Fiktif 21	Pengurus Barang	9	5	L	pegawai21@simkdo.test		2026-11-14 06:08:48.129285+00	2026-11-14 06:08:48.129285+00	\N
22	198001222008012022	Pegawai Fiktif 22	Pengurus Barang	10	6	P	pegawai22@simkdo.test		2026-11-14 06:08:48.130901+00	2026-11-14 06:08:48.130901+00	\N
23	198001232008011023	Pegawai Fiktif 23	Pengurus Barang	11	7	L	pegawai23@simkdo.test		2026-11-14 06:08:48.13534+00	2026-11-14 06:08:48.13534+00	\N
24	198001242008012024	Pegawai Fiktif 24	Pengurus Barang	7	8	P	pegawai24@simkdo.test		2026-11-14 06:08:48.13724+00	2026-11-14 06:08:48.13724+00	\N
25	198001252008011025	Pegawai Fiktif 25	Pengurus Barang	9	9	L	pegawai25@simkdo.test		2026-11-14 06:08:48.139389+00	2026-11-14 06:08:48.139389+00	\N
26	198001262008012026	Pegawai Fiktif 26	Pengurus Barang	10	10	P	pegawai26@simkdo.test		2026-11-14 06:08:48.142168+00	2026-11-14 06:08:48.142168+00	\N
27	198001272008011027	Pegawai Fiktif 27	Pengurus Barang	11	11	L	pegawai27@simkdo.test		2026-11-14 06:08:48.143732+00	2026-11-14 06:08:48.143732+00	\N
28	198001282008012028	Pegawai Fiktif 28	Pengurus Barang	7	12	P	pegawai28@simkdo.test		2026-11-14 06:08:48.145328+00	2026-11-14 06:08:48.145328+00	\N
29	198001012008011029	Pegawai Fiktif 29	Pengurus Barang	9	13	L	pegawai29@simkdo.test		2026-11-14 06:08:48.146838+00	2026-11-14 06:08:48.146838+00	\N
30	198001022008012030	Pegawai Fiktif 30	Pengurus Barang	10	14	P	pegawai30@simkdo.test		2026-11-14 06:08:48.148483+00	2026-11-14 06:08:48.148483+00	\N
31	198001032008011031	Pegawai Fiktif 31	Pengurus Barang	11	15	L	pegawai31@simkdo.test		2026-11-14 06:08:48.150272+00	2026-11-14 06:08:48.150272+00	\N
32	198001042008012032	Pegawai Fiktif 32	Pengurus Barang	7	16	P	pegawai32@simkdo.test		2026-11-14 06:08:48.151949+00	2026-11-14 06:08:48.151949+00	\N
33	198001052008011033	Pegawai Fiktif 33	Pengurus Barang	9	1	L	pegawai33@simkdo.test		2026-11-14 06:08:48.153445+00	2026-11-14 06:08:48.153445+00	\N
34	198001062008012034	Pegawai Fiktif 34	Pengurus Barang	10	2	P	pegawai34@simkdo.test		2026-11-14 06:08:48.155169+00	2026-11-14 06:08:48.155169+00	\N
35	198001072008011035	Pegawai Fiktif 35	Pengurus Barang	11	3	L	pegawai35@simkdo.test		2026-11-14 06:08:48.156877+00	2026-11-14 06:08:48.156877+00	\N
36	198001082008012036	Pegawai Fiktif 36	Pengurus Barang	7	4	P	pegawai36@simkdo.test		2026-11-14 06:08:48.16027+00	2026-11-14 06:08:48.16027+00	\N
37	198001092008011037	Pegawai Fiktif 37	Pengurus Barang	9	5	L	pegawai37@simkdo.test		2026-11-14 06:08:48.16338+00	2026-11-14 06:08:48.16338+00	\N
38	198001102008012038	Pegawai Fiktif 38	Pengurus Barang	10	6	P	pegawai38@simkdo.test		2026-11-14 06:08:48.16653+00	2026-11-14 06:08:48.16653+00	\N
39	198001112008011039	Pegawai Fiktif 39	Pengurus Barang	11	7	L	pegawai39@simkdo.test		2026-11-14 06:08:48.168147+00	2026-11-14 06:08:48.168147+00	\N
40	198001122008012040	Pegawai Fiktif 40	Pengurus Barang	7	8	P	pegawai40@simkdo.test		2026-11-14 06:08:48.169799+00	2026-11-14 06:08:48.169799+00	\N
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
1	1	1	BAST-SIMKDO-001	2025-01-02	\N	Penugasan seed	2026-11-14 06:08:48.291711+00	2026-11-14 06:08:48.291711+00	\N
2	2	2	BAST-SIMKDO-002	2025-01-03	2025-04-03	Penugasan seed	2026-11-14 06:08:48.295323+00	2026-11-14 06:08:48.295323+00	\N
3	3	3	BAST-SIMKDO-003	2025-01-04	2025-04-04	Penugasan seed	2026-11-14 06:08:48.297584+00	2026-11-14 06:08:48.297584+00	\N
4	4	4	BAST-SIMKDO-004	2025-01-05	\N	Penugasan seed	2026-11-14 06:08:48.29948+00	2026-11-14 06:08:48.29948+00	\N
5	5	5	BAST-SIMKDO-005	2025-01-06	2025-04-06	Penugasan seed	2026-11-14 06:08:48.301225+00	2026-11-14 06:08:48.301225+00	\N
6	6	6	BAST-SIMKDO-006	2025-01-07	2025-04-07	Penugasan seed	2026-11-14 06:08:48.302877+00	2026-11-14 06:08:48.302877+00	\N
7	7	7	BAST-SIMKDO-007	2025-01-08	\N	Penugasan seed	2026-11-14 06:08:48.304643+00	2026-11-14 06:08:48.304643+00	\N
8	8	8	BAST-SIMKDO-008	2025-01-09	2025-04-09	Penugasan seed	2026-11-14 06:08:48.305982+00	2026-11-14 06:08:48.305982+00	\N
9	9	9	BAST-SIMKDO-009	2025-01-10	2025-04-10	Penugasan seed	2026-11-14 06:08:48.307299+00	2026-11-14 06:08:48.307299+00	\N
10	10	10	BAST-SIMKDO-010	2025-01-11	\N	Penugasan seed	2026-11-14 06:08:48.310011+00	2026-11-14 06:08:48.310011+00	\N
11	11	11	BAST-SIMKDO-011	2025-01-12	2025-04-12	Penugasan seed	2026-11-14 06:08:48.311953+00	2026-11-14 06:08:48.311953+00	\N
12	12	12	BAST-SIMKDO-012	2025-01-13	2025-04-13	Penugasan seed	2026-11-14 06:08:48.31354+00	2026-11-14 06:08:48.31354+00	\N
13	13	13	BAST-SIMKDO-013	2025-01-14	\N	Penugasan seed	2026-11-14 06:08:48.314897+00	2026-11-14 06:08:48.314897+00	\N
14	14	14	BAST-SIMKDO-014	2025-01-15	2025-04-15	Penugasan seed	2026-11-14 06:08:48.316132+00	2026-11-14 06:08:48.316132+00	\N
15	15	15	BAST-SIMKDO-015	2025-01-16	2025-04-16	Penugasan seed	2026-11-14 06:08:48.317568+00	2026-11-14 06:08:48.317568+00	\N
16	16	16	BAST-SIMKDO-016	2025-01-17	\N	Penugasan seed	2026-11-14 06:08:48.319281+00	2026-11-14 06:08:48.319281+00	\N
17	18	18	BAST-SIMKDO-018	2025-01-19	2025-04-19	Penugasan seed	2026-11-14 06:08:48.320581+00	2026-11-14 06:08:48.320581+00	\N
18	19	19	BAST-SIMKDO-019	2025-01-20	\N	Penugasan seed	2026-11-14 06:08:48.321945+00	2026-11-14 06:08:48.321945+00	\N
19	20	20	BAST-SIMKDO-020	2025-01-21	2025-04-21	Penugasan seed	2026-11-14 06:08:48.323229+00	2026-11-14 06:08:48.323229+00	\N
20	21	21	BAST-SIMKDO-021	2025-01-22	2025-04-22	Penugasan seed	2026-11-14 06:08:48.324537+00	2026-11-14 06:08:48.324537+00	\N
21	22	22	BAST-SIMKDO-022	2025-01-23	\N	Penugasan seed	2026-11-14 06:08:48.325905+00	2026-11-14 06:08:48.325905+00	\N
22	23	23	BAST-SIMKDO-023	2025-01-24	2025-04-24	Penugasan seed	2026-11-14 06:08:48.32721+00	2026-11-14 06:08:48.32721+00	\N
23	24	24	BAST-SIMKDO-024	2025-01-25	2025-04-25	Penugasan seed	2026-11-14 06:08:48.328425+00	2026-11-14 06:08:48.328425+00	\N
24	25	25	BAST-SIMKDO-025	2025-01-26	\N	Penugasan seed	2026-11-14 06:08:48.329688+00	2026-11-14 06:08:48.329688+00	\N
25	26	26	BAST-SIMKDO-026	2025-01-27	2025-04-27	Penugasan seed	2026-11-14 06:08:48.331422+00	2026-11-14 06:08:48.331422+00	\N
26	27	27	BAST-SIMKDO-027	2025-01-28	2025-04-28	Penugasan seed	2026-11-14 06:08:48.332975+00	2026-11-14 06:08:48.332975+00	\N
27	28	28	BAST-SIMKDO-028	2025-01-29	\N	Penugasan seed	2026-11-14 06:08:48.335567+00	2026-11-14 06:08:48.335567+00	\N
28	29	29	BAST-SIMKDO-029	2025-01-30	2025-04-30	Penugasan seed	2026-11-14 06:08:48.338528+00	2026-11-14 06:08:48.338528+00	\N
29	30	30	BAST-SIMKDO-030	2025-01-31	2025-05-01	Penugasan seed	2026-11-14 06:08:48.342156+00	2026-11-14 06:08:48.342156+00	\N
\.


--
-- Data for Name: perangkat_daerah; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.perangkat_daerah (id, kode, nama, singkatan, jenis, alamat, telepon, email, created_at, updated_at, deleted_at) FROM stdin;
1	DISDIK	Dinas Pendidikan	DISDIK	dinas	Jakarta		DISDIK@jakarta.go.id	2026-11-14 06:08:48.051264+00	2026-11-14 06:08:48.051264+00	\N
2	DINKES	Dinas Kesehatan	DINKES	dinas	Jakarta		DINKES@jakarta.go.id	2026-11-14 06:08:48.054513+00	2026-11-14 06:08:48.054513+00	\N
3	DBM	Dinas Bina Marga	DBM	dinas	Jakarta		DBM@jakarta.go.id	2026-11-14 06:08:48.05614+00	2026-11-14 06:08:48.05614+00	\N
4	DSDA	Dinas Sumber Daya Air	DSDA	dinas	Jakarta		DSDA@jakarta.go.id	2026-11-14 06:08:48.057968+00	2026-11-14 06:08:48.057968+00	\N
5	DCKTRP	Dinas Cipta Karya Tata Ruang dan Pertanahan	DCKTRP	dinas	Jakarta		DCKTRP@jakarta.go.id	2026-11-14 06:08:48.060173+00	2026-11-14 06:08:48.060173+00	\N
6	DISHUB	Dinas Perhubungan	DISHUB	dinas	Jakarta		DISHUB@jakarta.go.id	2026-11-14 06:08:48.06203+00	2026-11-14 06:08:48.06203+00	\N
7	DLH	Dinas Lingkungan Hidup	DLH	dinas	Jakarta		DLH@jakarta.go.id	2026-11-14 06:08:48.063843+00	2026-11-14 06:08:48.063843+00	\N
8	DINSOS	Dinas Sosial	DINSOS	dinas	Jakarta		DINSOS@jakarta.go.id	2026-11-14 06:08:48.065297+00	2026-11-14 06:08:48.065297+00	\N
9	GULKAR	Dinas Penanggulangan Kebakaran dan Penyelamatan	GULKAR	dinas	Jakarta		GULKAR@jakarta.go.id	2026-11-14 06:08:48.066755+00	2026-11-14 06:08:48.066755+00	\N
10	DISTAMHUT	Dinas Pertamanan dan Hutan Kota	DISTAMHUT	dinas	Jakarta		DISTAMHUT@jakarta.go.id	2026-11-14 06:08:48.068046+00	2026-11-14 06:08:48.068046+00	\N
11	BPAD	Badan Pengelolaan Aset Daerah	BPAD	badan	Jakarta		BPAD@jakarta.go.id	2026-11-14 06:08:48.069518+00	2026-11-14 06:08:48.069518+00	\N
12	BAPENDA	Badan Pendapatan Daerah	BAPENDA	badan	Jakarta		BAPENDA@jakarta.go.id	2026-11-14 06:08:48.071018+00	2026-11-14 06:08:48.071018+00	\N
13	BPBD	Badan Penanggulangan Bencana Daerah	BPBD	badan	Jakarta		BPBD@jakarta.go.id	2026-11-14 06:08:48.072345+00	2026-11-14 06:08:48.072345+00	\N
14	INSPEKTORAT	Inspektorat	INSPEKTORAT	inspektorat	Jakarta		INSPEKTORAT@jakarta.go.id	2026-11-14 06:08:48.073859+00	2026-11-14 06:08:48.073859+00	\N
15	SATPOLPP	Satuan Polisi Pamong Praja	SATPOLPP	satuan	Jakarta		SATPOLPP@jakarta.go.id	2026-11-14 06:08:48.075336+00	2026-11-14 06:08:48.075336+00	\N
16	BIROUMUM	Biro Umum Sekretariat Daerah	BIROUMUM	biro	Jakarta		BIROUMUM@jakarta.go.id	2026-11-14 06:08:48.076583+00	2026-11-14 06:08:48.076583+00	\N
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
1	Admin SIM-KDO	admin@simkdo.test	$2a$10$W4c9w6tghfjt0ybinku7keDNnEgC2H1m76zNMYtxxDZX9I/NzLi7i	admin	2026-11-14 06:08:47.995407+00	2026-11-14 06:08:47.995407+00
2	Operator SIM-KDO	operator@simkdo.test	$2a$10$W4c9w6tghfjt0ybinku7keDNnEgC2H1m76zNMYtxxDZX9I/NzLi7i	operator	2026-11-14 06:08:48.000132+00	2026-11-14 06:08:48.000132+00
\.


--
-- Name: golongan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.golongan_id_seq', 17, true);


--
-- Name: kendaraan_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.kendaraan_id_seq', 50, true);


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

SELECT pg_catalog.setval('public.perangkat_daerah_id_seq', 16, true);


--
-- Name: riwayat_kondisi_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.riwayat_kondisi_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


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

\unrestrict GsBXchrMfAK50bSOZL3PgWRqawRQdbKWSpVMtNFdld9FQsVkBRq6kSC0aY9p54F

