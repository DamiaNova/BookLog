--Pronalazak naziva sekvence tablice:
SELECT column_name, data_type, column_default
FROM information_schema.columns
WHERE table_name = 'user_login_profiles';

--Unos defaultnog sloga unutar tablice:
INSERT INTO user_login_profiles
  (
	id,
	profile_name,
	profile_password,
	profile_initials,
	created_by,
	creation_date
  )
  VALUES
  (
    nextval('user_login_profiles_seq'), 
    'DummyUser',
	'Password',
	null, --Generira se automatikom/BEFORE INSERT funkcijom
	null, --Generira se automatikom/BEFORE INSERT funkcijom
	null  --Generira se automatikom/BEFORE INSERT funkcijom
  );

--Provjera unesenog sloga na bazi putem Query Tool-a:
SELECT *
FROM user_login_profiles
ORDER BY id DESC LIMIT 1;