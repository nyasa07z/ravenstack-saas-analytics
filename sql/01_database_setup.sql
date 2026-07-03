--
-- PostgreSQL database dump
--

\restrict 85u5c3SBN4Qfmy45EVo2bedfWWrcwIsaeys3rwJflyAvN47EfwllFRWOIwitAC8

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-07-01 14:19:01

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
-- TOC entry 219 (class 1259 OID 16390)
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    account_id character varying(20) NOT NULL,
    account_name character varying(100),
    industry character varying(50),
    country character varying(20),
    signup_date date,
    referral_source character varying(50),
    plan_tier character varying(20),
    seats integer,
    is_trial boolean,
    churn_flag boolean
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16429)
-- Name: churn_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.churn_events (
    churn_event_id character varying(20) NOT NULL,
    account_id character varying(20),
    churn_date date,
    reason_code character varying(30),
    refund_amount_usd numeric(10,2),
    preceding_upgrade_flag boolean,
    preceding_downgrade_flag boolean,
    is_reactivation boolean,
    feedback_text text
);


ALTER TABLE public.churn_events OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16407)
-- Name: feature_usage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feature_usage (
    usage_id character varying(20) NOT NULL,
    subscription_id character varying(20),
    usage_date date,
    feature_name character varying(50),
    usage_count integer,
    usage_duration_secs integer,
    error_count integer,
    is_beta_feature boolean
);


ALTER TABLE public.feature_usage OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 16396)
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subscriptions (
    subscription_id character varying(20) NOT NULL,
    account_id character varying(20),
    start_date date,
    end_date date,
    plan_tier character varying(20),
    seats integer,
    mrr_amount integer,
    arr_amount integer,
    is_trial boolean,
    upgrade_flag boolean,
    downgrade_flag boolean,
    churn_flag boolean,
    billing_frequency character varying(20),
    auto_renew_flag boolean
);


ALTER TABLE public.subscriptions OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 16418)
-- Name: support_tickets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.support_tickets (
    ticket_id character varying(20) NOT NULL,
    account_id character varying(20),
    submitted_at timestamp without time zone,
    closed_at timestamp without time zone,
    resolution_time_hours numeric(10,2),
    priority character varying(20),
    first_response_time_minutes integer,
    satisfaction_score numeric(3,1),
    escalation_flag boolean
);


ALTER TABLE public.support_tickets OWNER TO postgres;

--
-- TOC entry 4872 (class 2606 OID 16395)
-- Name: accounts accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (account_id);


--
-- TOC entry 4880 (class 2606 OID 16436)
-- Name: churn_events churn_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.churn_events
    ADD CONSTRAINT churn_events_pkey PRIMARY KEY (churn_event_id);


--
-- TOC entry 4876 (class 2606 OID 16412)
-- Name: feature_usage feature_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_usage
    ADD CONSTRAINT feature_usage_pkey PRIMARY KEY (usage_id);


--
-- TOC entry 4874 (class 2606 OID 16401)
-- Name: subscriptions subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (subscription_id);


--
-- TOC entry 4878 (class 2606 OID 16423)
-- Name: support_tickets support_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT support_tickets_pkey PRIMARY KEY (ticket_id);


--
-- TOC entry 4881 (class 2606 OID 16402)
-- Name: subscriptions fk_account; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subscriptions
    ADD CONSTRAINT fk_account FOREIGN KEY (account_id) REFERENCES public.accounts(account_id);


--
-- TOC entry 4884 (class 2606 OID 16437)
-- Name: churn_events fk_churn_account; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.churn_events
    ADD CONSTRAINT fk_churn_account FOREIGN KEY (account_id) REFERENCES public.accounts(account_id);


--
-- TOC entry 4882 (class 2606 OID 16413)
-- Name: feature_usage fk_subscription; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feature_usage
    ADD CONSTRAINT fk_subscription FOREIGN KEY (subscription_id) REFERENCES public.subscriptions(subscription_id);


--
-- TOC entry 4883 (class 2606 OID 16424)
-- Name: support_tickets fk_support_account; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.support_tickets
    ADD CONSTRAINT fk_support_account FOREIGN KEY (account_id) REFERENCES public.accounts(account_id);


-- Completed on 2026-07-01 14:19:01

--
-- PostgreSQL database dump complete
--

