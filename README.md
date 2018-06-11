Somewhat useless sample app for Ravel to test out rules and triggers.

Usage: Copy dup.py and dup.sql to apps folder. Start ravel instance and run test script using exec followed by relative path to the script.

Rule: Detects duplicate flows, where duplicate means same source and destination routers. In addition, creates a table called worked that has the value 1 if trigger has been triggered. Else, the table has value 0.
