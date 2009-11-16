--
-- PostgreSQL database dump
--

--
-- Name: customer_update(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION customer_update(customer_id integer, customer_rating integer) RETURNS integer
    AS $_$declare
  status integer;
begin
  status := 1;
  update customers set rating = $2 where id = $1;
  return status;
end$_$
    LANGUAGE plpgsql;

--
-- Name: get_spendings_by_branch(text); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION get_spendings_by_branch(text) RETURNS SETOF record
    AS $_$
declare
    r record;
begin
    for r in execute 'select bb.name, c.first_name, c.last_name, s.amount 
                        from bank_branches bb, customers c, spendings s 
                        where bb.id = c.bank_branch 
                        and c.id = s.customer_id 
                        order by bb.name, c.last_name, c.first_name limit ' || $1 loop
    return next r;
    end loop;
    return;
end
$_$
    LANGUAGE plpgsql;

--
-- Name: bank_branches; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE bank_branches (
    id integer NOT NULL,
    name text NOT NULL
);

--
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE customers (
    id integer NOT NULL,
    first_name text,
    last_name text,
    rating integer,
    bank_branch integer
);

--
-- Name: customers_all; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW customers_all AS
    SELECT customers.id, customers.first_name, customers.last_name, customers.rating FROM customers ORDER BY customers.last_name;

--
-- Name: spendings; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE spendings (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    amount numeric(13,2) NOT NULL
);

--
-- Data for Name: bank_branches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY bank_branches (id, name) FROM stdin;
1	ABC Bank Oxford Street
2	ABC Bank Baker Street
3	ABC Bank Covent Garden
4	NewBank Oxford Street
5	NewBank King Street
\.

--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY customers (id, first_name, last_name, rating, bank_branch) FROM stdin;
1	Mark	Markinson	3	5
5	Bill	Billingston	4	1
3	Adam	Adamson	17	1
6	Nick	Nickson	2	3
2	Joe	Smith	11	1
4	Zoe	Zoponer	13	5
\.

--
-- Data for Name: spendings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY spendings (id, customer_id, amount) FROM stdin;
2	2	200.99
3	2	109.99
4	2	9.19
5	2	1.49
6	2	234.60
7	3	27.50
8	3	55.65
9	3	503.36
10	4	1.00
11	4	45.00
12	4	245.30
13	4	5456.30
14	4	0.30
15	1	100.35
16	1	13.50
17	5	78.56
18	5	56.00
19	6	1002.55
20	6	101.78
\.

--
-- Name: bank_branches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY bank_branches
    ADD CONSTRAINT bank_branches_pkey PRIMARY KEY (id);

--
-- Name: customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);

--
-- Name: spendings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY spendings
    ADD CONSTRAINT spendings_pkey PRIMARY KEY (id);

--
-- Name: customers_bank_branch_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY customers
    ADD CONSTRAINT customers_bank_branch_fkey FOREIGN KEY (bank_branch) REFERENCES bank_branches(id);

--
-- Name: spendings_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY spendings
    ADD CONSTRAINT spendings_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customers(id);

