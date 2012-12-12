scripts
=======

misc scripts

# to join address lines before insertion in db
sed -e :a -e '$!N;s/\n\([^"]\)/ | \1/;ta' -e 'P;D' data.csv > rails_app/new_data.csv
