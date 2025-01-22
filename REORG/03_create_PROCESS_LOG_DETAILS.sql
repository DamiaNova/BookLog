--1. Sekvenca za automatsko povećanje ID-a:
CREATE SEQUENCE process_log_details_seq
	START WITH 1    --Početna vrijednost	
	INCREMENT BY 1  --Povećanje za 1
	NO MINVALUE     --Nema minimalne vrijednosti
	MAXVALUE 999999 --Maksimalna vrijednost ID-a
	CACHE 1;        --Keširanje jedne vrijednosti

--2. Kreiranje tablice PROCESS_LOG_DETAILS (alias: PLD):
CREATE TABLE process_log_details
(
	ID                 NUMERIC(6,0)  PRIMARY KEY default nextval('process_log_details_seq'), --Primarni ključ sa sekvencom
	PRL_ID             NUMERIC(6,0)  NOT NULL, --Veza na tablicu PROCESS_LOG
	PROCESS_NAME       VARCHAR(500)  NOT NULL, --Naziv procesa za kojeg se logiraju detalji
	PROCESS_PARAMETERS VARCHAR(4000) NOT NULL, --Parametri poziva procesa i njihove odgovarajuće vrijednosti
	CREATED_BY         VARCHAR(3)    NOT NULL, --Inicijali korisnika koji je pokrenuo proces
	CREATION_DATE      TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP, --Datum kreiranja
	CONSTRAINT id_max_check          CHECK(ID<=999999),
	CONSTRAINT fk_pcl_id             FOREIGN KEY (PRL_ID) REFERENCES process_log(ID)
);

--3. Provjera rezultata:
--SELECT * FROM process_log_details;

-------------------------------------------------------------------------
-----------------------FUNKCIJE------------------------------------------
--4. Funkcija koja diže exception ako je ID veći od maksimuma:
CREATE OR REPLACE FUNCTION f_check_id_limit_PLD()
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
BEFORE INSERT OR UPDATE ON process_log_details
FOR EACH ROW EXECUTE FUNCTION f_check_id_limit_PLD();
------------------------------------------------------------------------
-----------------------KOMENTARI----------------------------------------
--6. Opis tablice:
COMMENT ON TABLE process_log_details IS 'Tablica za logiranje vrijednosti parametara poziva. Alias: PLD';

--7. Komentari polja:
COMMENT ON COLUMN process_log_details.id                  IS 'Sekvenca: process_log_details_seq';
COMMENT ON COLUMN process_log_details.prl_id              IS 'Veza na tablicu PROCESS_LOG';
COMMENT ON COLUMN process_log_details.process_name        IS 'Naziv procesa za kojeg se logiraju detalji';
COMMENT ON COLUMN process_log_details.process_parameters  IS 'Parametri poziva procesa i njihove odgovarajuće vrijednosti';
COMMENT ON COLUMN process_log_details.created_by          IS 'Inicijali korisnika koji je pokrenuo proces';
COMMENT ON COLUMN process_log_details.creation_date       IS 'Datum kreiranja';
------------------------------------------------------------------------
-----------------------BRISANJE-----------------------------------------
--Naredba za brisanje triggera:
--DROP TRIGGER IF EXISTS trg_check_id ON process_log_details;

--Naredba za brisanje funkcije:
--DROP FUNCTION IF EXISTS f_check_id_limit_PLD();

--Naredba za brisanje tablice
--DROP TABLE IF EXISTS process_log_details;

--Naredba za brisanje sekvence:
--DROP SEQUENCE IF EXISTS process_log_details_seq;