"""Spawn a cluster of nodes

"""

# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg

pc = portal.Context()
pc.defineParameter("n", "Number of nodes", portal.ParameterType.INTEGER, 1)

params = pc.bindParameters()
request = pc.makeRequestRSpec()

if params.n < 1 or params.n > 128:
    pc.reportError( portal.ParameterError("You must choose at least 1 and no more than 128 nodes."))
pc.verifyParameters()

for i in range(params.n):
    node = request.RawPC("node" + str(i))
    if i == 0:
        node.addService(pg.Execute(shell="sh", command="/local/repository/leader.sh"))
    else:
        node.addService(pg.Execute(shell="sh", command="/local/repository/worker.sh"))

pc.printRequestRSpec()