-- init.sql
SELECT 'CREATE DATABASE tododb'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'tododb');

\c tododb;

CREATE SCHEMA IF NOT EXISTS public;

CREATE TABLE IF NOT EXISTS public.todolist (
    id SERIAL PRIMARY KEY,
    title VARCHAR NOT NULL,
    description VARCHAR NOT NULL,
    completed BOOLEAN NOT NULL
);

-- Insert entries into the table
INSERT INTO public.todolist (title, description, completed) VALUES
    ('subashtest', 'random input', FALSE),
    ('devtest', 'testing at development', FALSE);

