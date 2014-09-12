thesis
======

Requires:
  - The BBOB python processing files (available at http://coco.gforge.inria.fr/doku.php) in a directory called 'bbob_pproc'.
  - BBOB data in a directory called 'BBOB_data'.
    - Contains directories named after the year of the results.
	- See the file structure below
	
Outputs:
  - ert.csv: a CSV of the ERT results
	
File Structure:
  - calc_ert_from_pickle.py: run this to calculate ERT
  - bbob_pproc: contains all BBOB processing python files (available athttp://coco.gforge.inria.fr/doku.php)
  - BBOB_data
    - 2009
      - ALPS
	  - AMALGAM
	  - etc...
	- 2010
	- 2012
	- 2013