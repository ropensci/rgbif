sname = 'Danaus plexippus' # Monarch butterfly
# With coordinates
a <- occurrencecount(scientificname = sname, coordinatestatus = TRUE )
a
#All records
b <- occurrencecount(scientificname = sname )
b


sname = 'Aratinga holochlora rubritorquis'
# Basis of Record : Specimen 
a <- occurrencecount(scientificname = sname, basisofrecordcode="specimen")
a

#  Basis of Record : Observations
a <- occurrencecount(scientificname = sname, coordinatestatus = TRUE, basisofrecordcode="observation")
a

# Cellid get data for a cellid
a <- occurrencecount(coordinatestatus = TRUE, cellid = 46910)
a

# Host Country ISO code
a <- occurrencecount(coordinatestatus = TRUE, hostisocountrycode="IN" )
a

# Origin Country ISO code
a <- occurrencecount(coordinatestatus = TRUE, originisocountrycode="IN" )
a

