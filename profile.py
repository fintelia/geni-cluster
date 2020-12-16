"""Spawn a cluster of nodes

"""

# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg

pc = portal.Context()
pc.defineParameter("n", "Number of nodes", portal.ParameterType.INTEGER, 2)

params = pc.bindParameters()
request = pc.makeRequestRSpec()

if params.n < 1 or params.n > 128:
    pc.reportError( portal.ParameterError("You must choose at least 1 and no more than 128 nodes."))
pc.verifyParameters()

link = request.LAN("lan")
for i in range(params.n):
    node = request.RawPC("node" + str(i))
    if i == 0:
        node.addService(pg.Execute(shell="bash", command="/bin/bash /local/repository/leader.sh | tee /local/repository/log"))
    else:
        node.addService(pg.Execute(shell="bash", command="/bin/bash /local/repository/worker.sh | tee /local/repository/log"))
    link.addInterface(node.addInterface("if0"))

pc.printRequestRSpec()