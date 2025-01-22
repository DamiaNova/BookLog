--1. Sekvenca za automatsko povećanje ID-a:
CREATE SEQUENCE process_log_seq
	START WITH 1    --Početna vrijednost
	INCREMENT BY 1  --Povećanje za 1
	NO MINVALUE	    --Nema minimalne vrijednosti
	MAXVALUE 999999 --Maksimalna vrijednost ID-a
	CACHE 1;        --Keširanje jedne vrijednosti

--2. Kreiranje tablice PROCESS_LOG (alias PRL):
CREATE TABLE process_log
(
	ID                NUMERIC(6,0)  PRIMARY KEY default nextval('process_log_seq'),--Primarni ključ sa sekvencom
	PACKAGE_NAME      VARCHAR(100)  NOT NULL,                           --Naziv paketa
	PROCEDURE_NAME    VARCHAR(100)  NOT NULL,                           --Naziv procedure ili funkcije
	PROCESS_STATUS    VARCHAR(1)    NOT NULL,                           --Status poziva: E-Error, W-Warning, I-Information
	PROCESS_MESSAGE   VARCHAR(500),                                     --Poruka poziva procesa
	PROCESS_TIMESTAMP TIMESTAMP     NOT NULL default CURRENT_TIMESTAMP, --Vrijeme poziva
	CREATED_BY        VARCHAR(3)    NOT NULL,                           --Inicijali korisnika koji je izvršio poziv
	CONSTRAINT id_max_check CHECK(ID<=999999)
);

--3. Provjera rezultata:
--SELECT * FROM process_log;

-------------------------------------------------------------------------
-----------------------FUNKCIJE------------------------------------------
--4. Funkcija koja diže exception ako je ID veći od maksimuma:
CREATE OR REPLACE FUNCTION f_check_id_limit_PRL()
RETURNS TRIGGER AS $$
BEGIN
	if NEW.ID > 999999 then
	  raise exception 'ID ne može biti veći od 999999';
	end if;
	return NEW;
END;
$$ LANGUAGE plpgsql;
-------------------------------------------------------------------------
-----------------------TRIGGERI------------------------------------------
--5. Trigger koji kontrolira vrijednost ID-a:
CREATE TRIGGER trg_check_id
BEFORE INSERT OR UPDATE ON process_log
FOR EACH ROW EXECUTE FUNCTION f_check_id_limit_PRL();
------------------------------------------------------------------------
-----------------------KOMENTARI----------------------------------------
--6. Opis tablice:
COMMENT ON TABLE process_log IS 'Tablica za logiranje poziva procedura i funkcija iz paketa. Alias: PRL';

--7. Komentari polja:
COMMENT ON COLUMN process_log.id                IS 'Sekvenca: process_log_seq';
COMMENT ON COLUMN process_log.package_name      IS 'Naziv paketa';
COMMENT ON COLUMN process_log.procedure_name    IS 'Naziv procedure ili funkcije';
COMMENT ON COLUMN process_log.process_status    IS 'Status poziva: E-Error, W-Warning, I-Information';
COMMENT ON COLUMN process_log.process_message   IS 'Poruka poziva procesa';
COMMENT ON COLUMN process_log.process_timestamp IS 'Vrijeme poziva';
COMMENT ON COLUMN process_log.created_by        IS 'Inicijali korisnika koji je izvršio poziv';

------------------------------------------------------------------------
-----------------------BRISANJE-----------------------------------------
--Naredba za brisanje triggera:
--DROP TRIGGER IF EXISTS trg_check_id ON process_log;

--Naredba za brisanje funkcije:
--DROP FUNCTION IF EXISTS f_check_id_limit_PRL();

--Naredba za brisanje tablice
--DROP TABLE IF EXISTS process_log;

--Naredba za brisanje sekvence:
--DROP SEQUENCE IF EXISTS process_log_seq;