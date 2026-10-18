#!/bin/bash

PSQL=(psql -X --username=freecodecamp --dbname=periodic_table --tuples-only --no-align --quiet)

if [[ $# -eq 0 ]]; then
  printf '%s\n' 'Please provide an element as an argument.'
  exit 0
fi

element=$("${PSQL[@]}" -v element="$1" <<'SQL'
SELECT 'The element with atomic number ' || e.atomic_number || ' is ' || e.name || ' (' || e.symbol || '). It''s a ' || t.type || ', with a mass of ' || p.atomic_mass || ' amu. ' || e.name || ' has a melting point of ' || p.melting_point_celsius || ' celsius and a boiling point of ' || p.boiling_point_celsius || ' celsius.'
FROM elements AS e
JOIN properties AS p USING (atomic_number)
JOIN types AS t USING (type_id)
WHERE e.atomic_number::TEXT = :'element'
  OR e.symbol = :'element'
  OR e.name = :'element'
LIMIT 1;
SQL
)

if [[ -z $element ]]; then
  printf '%s\n' 'I could not find that element in the database.'
else
  printf '%s\n' "$element"
fi