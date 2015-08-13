#!/bin/bash
# Rob Burtelow - rburtelow@gmail.com
#
# Time to hack up SLMPD CSV files to get them to import properly into ElasticSearch
#

# Get the name of the CSV file to be processed

echo -n "Type the name of the SLMPD CSV file to process [ENTER]: "
read filename

# Check for existence of the file before processing
if [ -f $filename ];
then
   echo ""
   echo "Proceeding with conversion ..."
   echo "========================================================================================================="
   echo ""
   echo ""
   echo ""
else
   echo ""
   echo "File ${filename} does not exist.  Please check again and re-run this script."
   echo ""
   exit 0
fi


# Remove the first line of the CSV file which contains CSV headers.  We don't want these imported.
sed -i '1d' ${filename}

# Cleaning up the descrption fields that include commas and screw up CSV parsing
sed -i 's/\$24\,999/24999/g' ${filename}
sed -i 's/\,NUISANCE ABATEMENT/NUISANCE ABATEMENT/g' ${filename}
sed -i 's/STOLEN PROPERTY-BUYING\,RECEIVING\,POSSESSING\,ET/STOLEN PROPERTY-BUYING RECEIVING POSSESSING ET/g' ${filename}
sed -i 's/AGG.ASSAULT-HNDS\,FST\,FEET/CTZEN CHLD 2ND DEGRE/AGG.ASSAULT-HNDS FST FEET/CTZEN CHLD 2ND DEGRE/g' ${filename}
sed -i 's/ASSAULT\, ADULT\, AGE 17 AND UP-DOMESTIC/ASSAULT ADUL AGE 17 AND UP-DOMESTIC/g' ${filename}
sed -i 's/STOLEN PROPERTY-BUYING\,RECEIVING\,POSSESSING/STOLEN PROPERTY-BUYING RECEIVING POSSESSING/g' ${filename}
sed -i 's/ASSAULT\, CHILD\, AGE 16 AND UNDR-DOMESTIC/ASSAULT CHILD AGE 16 AND UNDR-DOMESTIC/g' ${filename}
sed -i 's/AGG.ASSAULT-HNDS\,FST\,FEET/CTZEN ADLT 2ND DEGRE/AGG.ASSAULT-HNDS FST FEET/CTZEN ADLT 2ND DEGRE/g' ${filename}

# Need to replace the Neighborhood field with something more useful.
# The below AWK gsubs substitute the neighborhood number in the default CSV with the neighborhood name.
# Neighborhood mapping was obtained from the SLMPD Downloadable Crime file FAQ at:
#
#	http://www.slmpd.org/Crime/CrimeDataFrequentlyAskedQuestions.pdf
#

awk -F, 'BEGIN {OFS=","}
{gsub("10", "Ellendale", $14);
gsub("11", "Clifton Heights", $14);
gsub("12", "The Hill", $14);
gsub("13", "Southwest Garden", $14);
gsub("14", "North Hampton", $14);
gsub("15", "Tower Grove South", $14);
gsub("16", "Dutchtown", $14);
gsub("17", "Mount Pleasant", $14);
gsub("18", "Marine Villa", $14);
gsub("19", "Gravois Park", $14);
gsub("20", "Kosciusko", $14);
gsub("21", "Soulard", $14);
gsub("22", "Benton Park", $14);
gsub("23", "McKinley Heights", $14);
gsub("24", "Fox Park", $14);
gsub("25", "Tower Grove East", $14);
gsub("26", "Compton Heights", $14);
gsub("27", "Shaw", $14);
gsub("28", "McRee Town", $14);
gsub("29", "Tiffany", $14);
gsub("30", "Benton Park West", $14);
gsub("31", "The Gate District", $14);
gsub("32", "Lafayette Square", $14);
gsub("33", "Peabody-Darst-Webbe", $14);
gsub("34", "Lasalle", $14);
gsub("35", "Downtown", $14);
gsub("36", "Downtown West", $14);
gsub("37", "Midtown", $14);
gsub("38", "Central West End", $14);
gsub("39", "Forest Park SE", $14);
gsub("40", "Kings Oak", $14);
gsub("41", "Cheltenham", $14);
gsub("42", "Clayton-Tamm", $14);
gsub("43", "Franz Park", $14);
gsub("44", "Hi-Point", $14);
gsub("45", "Wydown-Skinker", $14);
gsub("46", "Skinker-DeBaliviere", $14);
gsub("47", "DeBaliviere Place", $14);
gsub("48", "West End", $14);
gsub("49", "Visitation Park", $14);
gsub("50", "Wells-Goodfellow", $14);
gsub("51", "Academy", $14);
gsub("52", "Kingsway West", $14);
gsub("53", "Fountain Park", $14);
gsub("54", "Lewis Place", $14);
gsub("55", "Kingsway East", $14);
gsub("56", "The Great Ville", $14);
gsub("57", "The Ville", $14);
gsub("58", "Vandeventer", $14);
gsub("59", "Jeff Vanderlou", $14);
gsub("60", "St. Louis Place", $14);
gsub("61", "Carr Square", $14);
gsub("62", "Columbus Square", $14);
gsub("63", "Old North St. Louis", $14);
gsub("64", "Near N. Riverfront", $14);
gsub("65", "Hyde Park", $14);
gsub("66", "College Hill", $14);
gsub("67", "Fairground Neighborhood", $14);
gsub("68", "Ofallon", $14);
gsub("69", "Penrose", $14);
gsub("70", "Mark Twain I70 Ind.", $14);
gsub("71", "Mark Twain", $14);
gsub("72", "Walnut Park East", $14);
gsub("73", "North Point", $14);
gsub("74", "Baden", $14);
gsub("75", "Riverview", $14);
gsub("76", "Walnut Park West", $14);
gsub("77", "Covenant Blu Grand Center", $14);
gsub("78", "Hamilton Heights", $14);
gsub("79", "North Riverfront", $14);
gsub("80", "Carondolet Park", $14);
gsub("81", "Tower Grove Park", $14);
gsub("82", "Forest Park", $14);
gsub("83", "Fairgrounds Park", $14);
gsub("84", "Penrose Park", $14);
gsub("85", "Ofallon Park", $14);
gsub("86", "Calvary Bellfontaine Cemetaries", $14);
gsub("1", "Carondolet", $14); 
gsub("2", "Patch", $14); 
gsub("3", "Holly Hills", $14);
gsub("4", "Boulevard Heights", $14);
gsub("5", "Bevo Mill", $14);
gsub("6", "Princeton Heights", $14);
gsub("7", "South Hampton", $14);
gsub("8", "St. Louis Hills", $14);
gsub("9", "Lindenwood Park", $14);
 print}' ${filename} > csv/${filename} 

# Move the original file to the archive directory, trying to not clog up the main directory.
mv ${filename} archive/

echo ""
echo ""
echo "Done."
