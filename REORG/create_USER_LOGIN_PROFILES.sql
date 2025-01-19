-- 1. Sekvenca za automatsko povećavanje ID-a:
CREATE SEQUENCE user_login_profiles_seq
    START WITH 1   -- Početna vrijednost
    INCREMENT BY 1 -- Povećava za 1
    NO MINVALUE    -- Nema minimalne vrijednosti
    MAXVALUE 500   -- Maksimalna vrijednost = 500
    CACHE 1;       -- Keširanje jedne vrijednosti

-- 2. Kreiranje tablice USER_LOGIN_PROFILES:
CREATE TABLE USER_LOGIN_PROFILES (
    ID                NUMERIC(5,0) PRIMARY KEY DEFAULT nextval('user_login_profiles_seq'), -- Primarni ključ s automatskom sekvencom
    PROFILE_NAME      VARCHAR(10)  NOT NULL, 			    	  --Polje za ime profila (maksimalno 10 znakova)
    PROFILE_PASSWORD  VARCHAR(12)  NOT NULL, 		            	  --Lozinka za profil, obavezno polje
    PROFILE_INITIALS  VARCHAR(3)   NOT NULL UNIQUE, 	            	  --Jedinstveni inicijali profila
    CREATED_BY        VARCHAR(3)   NOT NULL, 			    	  --Korisnik koji je kreirao profil
    CREATION_DATE     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,          	  --Datum kreiranja
    CONSTRAINT id_max_check CHECK (ID <= 500), 			    	  --Ograničenje na maksimalan broj ID-a
    CONSTRAINT profile_name_min CHECK (LENGTH(PROFILE_NAME) >= 5),  	  --Ograničenje na minimalan broj znakova u korisničkom imenu
    CONSTRAINT profile_password_min CHECK (LENGTH(PROFILE_PASSWORD) >= 5) --Ograničenje na minimalan broj znakova za lozinku profila
);

-- 3. Provjera rezultata:
--SELECT * FROM USER_LOGIN_PROFILES;

-----------------------FUNKCIJE------------------------------------------
--4. Funkcija koja diže exception ako je ID veći od maksimuma:
CREATE OR REPLACE FUNCTION check_id_limit()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.ID > 500 THEN
        RAISE EXCEPTION 'ID cannot exceed 500';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

--5. Funkcija koja generira jedinstvene inicijale za profil:
CREATE OR REPLACE FUNCTION generate_profile_initials()
RETURNS TRIGGER AS $$
DECLARE
    generirani_inicijali VARCHAR(3); --Generirani inicijali
    is_jedinstveno       BOOLEAN;    --Oznaka jesu li generirani inicijali jedinstveni
BEGIN
    LOOP
        -- Generiraj inicijale spajanjem nasumična dva slova iz naziva profila + nasumična znamenka:
        generirani_inicijali := 
		UPPER(SUBSTRING(NEW.PROFILE_NAME FROM CAST(FLOOR(RANDOM() * LENGTH(NEW.PROFILE_NAME) + 1) AS INTEGER) FOR 1)) || 
	    	UPPER(SUBSTRING(NEW.PROFILE_NAME FROM CAST(FLOOR(RANDOM() * LENGTH(NEW.PROFILE_NAME) + 1) AS INTEGER) FOR 1)) || 
	    	CAST((RANDOM() * 9)::INTEGER AS TEXT);

        -- Provjeri jedinstvenost:
        SELECT COUNT(*) = 0
	    INTO is_jedinstveno
        FROM USER_LOGIN_PROFILES
        WHERE PROFILE_INITIALS = generirani_inicijali;

        -- Ako je jedinstveno, izađi iz petlje:
        IF is_jedinstveno THEN
            EXIT;
        END IF;
    END LOOP;

    -- Postavi generirane inicijale:
    NEW.PROFILE_INITIALS := generirani_inicijali;

    -- Postavi inicijale korisnika koji je generirao slog:
    NEW.CREATED_BY := generirani_inicijali;

    -- Postavi datum kreiranja:
    NEW.CREATION_DATE := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
------------------------------------------------------------------------
-----------------------TRIGGERI-----------------------------------------
--6. Trigger koji kontrolira vrijednost ID-a:
CREATE TRIGGER trg_check_id
BEFORE INSERT OR UPDATE ON USER_LOGIN_PROFILES
FOR EACH ROW EXECUTE FUNCTION check_id_limit();

--7. Trigger koji kreira jedinstvene inicijale profila:
CREATE TRIGGER trg_generate_profile_initials
BEFORE INSERT ON USER_LOGIN_PROFILES
FOR EACH ROW
EXECUTE FUNCTION generate_profile_initials();
------------------------------------------------------------------------
-----------------------KOMENTARI----------------------------------------

--8. Opis tablice:
COMMENT ON TABLE USER_LOGIN_PROFILES IS 'Tablica za pohranu podataka o korisničkim profilima za prijavu. Alias: ULP';

--9. Komentari na polja tablice:
COMMENT ON COLUMN USER_LOGIN_PROFILES.ID 		IS 'Sekvenca: user_login_profiles_seq';
COMMENT ON COLUMN USER_LOGIN_PROFILES.PROFILE_NAME 	IS 'Naziv korisničkog profila (maksimalno 10 znakova)';
COMMENT ON COLUMN USER_LOGIN_PROFILES.PROFILE_PASSWORD  IS 'Lozinka profila (maksimalno 12, minimalno 5 znakova)';
COMMENT ON COLUMN USER_LOGIN_PROFILES.PROFILE_INITIALS  IS 'Jedinstveni inicijali korisnika';
COMMENT ON COLUMN USER_LOGIN_PROFILES.CREATED_BY 	IS 'Korisnik koji je kreirao profil';
COMMENT ON COLUMN USER_LOGIN_PROFILES.CREATION_DATE 	IS 'Datum kreiranja';

-----------------------BRISANJE----------------------------------------
--Naredbe za brisanje triggera:
--DROP TRIGGER IF EXISTS trg_check_id ON USER_LOGIN_PROFILES;
--DROP TRIGGER IF EXISTS trg_generate_profile_initials ON USER_LOGIN_PROFILES;

--Naredbe za brisanje funkcija:
--DROP FUNCTION IF EXISTS check_id_limit();
--DROP FUNCTION IF EXISTS generate_profile_initials();

--Naredba za brisanje tablice:
--DROP TABLE IF EXISTS user_login_profiles;

--Naredba za brisanje sekvence:
--DROP SEQUENCE IF EXISTS user_login_profiles_seq;
