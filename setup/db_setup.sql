CREATE DATABASE band_sched;
CREATE USER "foo" identified by "1337";
GRANT ALL on band_sched.* to "foo"@"localhost" identified by "1337";
