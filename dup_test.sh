# bas, use the --script flag:
# $ sudo ./ravel.py --topo=linear,4 --script=./myscript.sh

# From within the CLI:
# ravel> ./myscript.sh
# OR
# ravel> exec ./myscript.sh

p SELECT * FROM nodes;

orch load routing dup sample

sample echo Should be 0 since trigger not activated yet:
p SELECT * FROM worked;
orch run

#BASE
rt addflow h1 h2

sample echo Should be 1 since trigger not activated yet:
p SELECT * FROM worked;
orch run

#CASE 1
rt addflow h1 h4

sample echo Case where same src, but dst is different, so no conflict:
p SELECT * FROM dup_violation;
orch run

#CASE 2
rt addflow h3 h4

sample echo Case where same dst, but src is different, so no conflict:
p SELECT * FROM dup_violation;
orch run

#CASE 3
rt addflow h1 h2

sample echo Case where same dst, same src, so conflict:
p SELECT * FROM dup_violation;
orch run
