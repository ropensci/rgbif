sname = 'Turdus migratorius' # American Robin
# Get 20 records of sname
out1 <- occurrencelist(sciname = sname, coordinatestatus = TRUE, maxresults = 20, latlongdf = TRUE )
out1

sname = 'Aratinga holochlore'  # Wrong name
# Get records of sname (which is wrong )
out2 <- occurrencelist(sciname = sname, coordinatestatus = TRUE, latlongdf = TRUE )
out2

sname = 'Danaus plexippus' # Monarch butterfly
# Get records of sname (which is wrong )
out3 <- occurrencelist(sciname = sname, coordinatestatus = TRUE, latlongdf = TRUE, format = 'brief' )
out3


sname = 'Aratinga holochlora rubritorquis'
# Basis of Record : Specimen 
outsp <- occurrencelist(sciname = sname, coordinatestatus = TRUE, maxresults = 10, latlongdf = TRUE, basisofrecordcode="specimen")
outsp

#  Basis of Record : Observations
outob <- occurrencelist(sciname = sname, coordinatestatus = TRUE, maxresults = 10, latlongdf = TRUE, basisofrecordcode="observation")
outob

# Cellid get data for a cellid
outc <- occurrencelist(coordinatestatus = TRUE, latlongdf = TRUE,  cellid = 46910)
outc

# Host Country ISO code
outc1 <- occurrencelist(coordinatestatus = TRUE, latlongdf = TRUE, hostisocountrycode="IN" )
outc1

# Origin Country ISO code
outc2 <- occurrencelist(coordinatestatus = TRUE, latlongdf = TRUE, originisocountrycode="IN" )
outc2

# removeZeros 
outz <- occurrencelist(coordinatestatus = TRUE, latlongdf = TRUE, hostisocountrycode="IN", removeZeros =TRUE )
outz

# specifying bounding box using latitude and longitude
outbx <- occurrencelist(coordinatestatus = TRUE, latlongdf = TRUE, minlatitude = 15, maxlatitude = 25, minlongitude=20,maxlongitude=21)
outbx

#Using Taxon concept key : Hackberry (Prunus padus)
outk <- occurrencelist(coordinatestatus = TRUE, latlongdf = TRUE,  taxonconceptKey = 50027707)
outk
