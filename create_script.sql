CREATE SCHEMA IF NOT EXISTS nobel_laureate_database
    AUTHORIZATION postgres;
    
CREATE TABLE nobel_laureate_database.nobel_prize_category
(
    category_id bigint,
    category text,
    category_full_name text,
    PRIMARY KEY (category_id)
);

ALTER TABLE IF EXISTS nobel_laureate_database.nobel_prize_category
    OWNER to postgres;

CREATE TABLE nobel_laureate_database.source
(
    openalex_source_id text,
    display_name text,
    type text,
    issn_l text,
    issn text,
    host_organization_name text,
    PRIMARY KEY (openalex_source_id)
);

ALTER TABLE IF EXISTS nobel_laureate_database.source
    OWNER to postgres;

CREATE TABLE nobel_laureate_database.institution
(
    openalex_institution_id text,
    institution_display_name text,
    institution_ror text,
    country_code text,
    city text,
    region text,
    country text,
    type text,
    latitude text,
    longitude text,
    PRIMARY KEY (openalex_institution_id)
);

ALTER TABLE IF EXISTS nobel_laureate_database.institution
    OWNER to postgres;

CREATE TABLE nobel_laureate_database.laureate
(
    nobel_laureate_id bigint,
    known_name text,
    given_name text,
    family_name text,
    full_name text,
    file_name text,
    gender text,
    nationality text,
    bachelor text,
    master text,
    doctoral text,
    birth_date text,
    death_date text,
    wikipedia_link text,
    wikidata_link text,
    PRIMARY KEY (nobel_laureate_id)
);

ALTER TABLE IF EXISTS nobel_laureate_database.laureate
    OWNER to postgres;

CREATE TABLE nobel_laureate_database.laureate_openalex_matching
(
    openalex_author_id text,
    nobel_laureate_id bigint,
    PRIMARY KEY (openalex_author_id),
    FOREIGN KEY (nobel_laureate_id)
        REFERENCES nobel_laureate_database.laureate (nobel_laureate_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS nobel_laureate_database.laureate_openalex_matching
    OWNER to postgres;

CREATE TABLE nobel_laureate_database.award_info
(
    award_year bigint,
    category_id bigint,
    nobel_laureate_id bigint,
    portion text,
    award_date text,
    prize_status text,
    motivation text,
    prize_amount text,
    prize_amount_adjusted text,
    nobel_prize_link text,
    PRIMARY KEY (award_year, category_id, nobel_laureate_id),
    FOREIGN KEY (category_id)
        REFERENCES nobel_laureate_database.nobel_prize_category (category_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    FOREIGN KEY (nobel_laureate_id)
        REFERENCES nobel_laureate_database.laureate (nobel_laureate_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS nobel_laureate_database.award_info
    OWNER to postgres;

CREATE TABLE nobel_laureate_database.laureate_location_info
(
    nobel_laureate_id bigint,
    location_type text,
    location_string text,
    date text,
    city text,
    country text,
    city_now text,
    country_now text,
    continent text,
    city_now_latitude text,
    city_now_longitude text,
    PRIMARY KEY (nobel_laureate_id, location_type, location_string, date),
    FOREIGN KEY (nobel_laureate_id)
        REFERENCES nobel_laureate_database.laureate (nobel_laureate_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS nobel_laureate_database.laureate_location_info
    OWNER to postgres;

CREATE TABLE nobel_laureate_database.work
(
    openalex_work_id text,
    doi text,
    title text,
    display_name text,
    publication_year bigint,
    publication_date text,
    language text,
    openalex_source_id text,
    type text,
    type_crossref text,
    is_oa text,
    oa_status text,
    oa_url text,
    is_retracted text,
    keywords text,
    abstract text,
    referenced_works text,
    cited_by_api_url text,
    landing_page_url text,
    pdf_url text,
    PRIMARY KEY (openalex_work_id),
    FOREIGN KEY (openalex_source_id)
        REFERENCES nobel_laureate_database.source (openalex_source_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS nobel_laureate_database.work
    OWNER to postgres;

CREATE TABLE nobel_laureate_database.work_citation_by_year
(
    openalex_work_id text,
    year bigint,
    citation_count bigint,
    PRIMARY KEY (openalex_work_id, year),
    FOREIGN KEY (openalex_work_id)
        REFERENCES nobel_laureate_database.work (openalex_work_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS nobel_laureate_database.work_citation_by_year
    OWNER to postgres;

CREATE TABLE nobel_laureate_database.work_authorship
(
    openalex_work_id text,
    openalex_author_id text,
	openalex_institution_id text,
    author_position text,
    author_display_name text,
    orcid text,
    is_corresponding text,
    affiliation_string text,
    PRIMARY KEY (openalex_work_id, openalex_author_id,openalex_institution_id),
    FOREIGN KEY (openalex_work_id)
        REFERENCES nobel_laureate_database.work (openalex_work_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    FOREIGN KEY (openalex_author_id)
        REFERENCES nobel_laureate_database.laureate_openalex_matching (openalex_author_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    FOREIGN KEY (openalex_institution_id)
        REFERENCES nobel_laureate_database.institution (openalex_institution_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

ALTER TABLE IF EXISTS nobel_laureate_database.work_authorship
    OWNER to postgres;